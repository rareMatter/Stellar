//
//  TreeReconciler.swift
//  
//
//  Created by Jesse Spencer on 10/22/21.
//

import Combine
import SwiftUI

/// The Tree Reconciler handles updating of the "Live Tree" (such as `PrimitiveViewHost`) when state changes are seen in the dynamic properties declared by the "Descriptive Tree" (such as `SContent` values), or other changes occur which require updates, such as user interactions or environment properties.
///
/// Any updates in the Descriptive Tree are reflected in the Live Tree.
///
/// How does the Tree Reconciler understand user-created types?
///
/// The reconciler uses Swift's Reflection capabilities in order to inspect and understand Content types that flow through it. While this happens, the reconciler retrieves the properties of types that it's interested in, such as dynamic properties which will cause updates to the Live Tree.
///
/// The Tree Reconciler will delegate to a platform-specific Renderer which needs to provide a rendered (or renderable) translation that the platform can display on-screen. The renderable target instances will be requested whenever the Descriptive Tree needs to be reconciled with the Live Tree in order to update the rendered appearance of the Live Tree.
///
/// Updates are scheduled using a stack implementation. Performance improvements are likely if a multi-threaded implementation is proven to be possible and effective.
final
class TreeReconciler {
    
    struct Render: Hashable {
        let element: CompositeElementHost
        // TODO:
        // let transaction: Transaction
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(element)
        }
        static
        func == (lhs: Self, rhs: Self) -> Bool {
            lhs.element == rhs.element
        }
    }
    
    /// A stack of `Render` values which need reconciliation.
    ///
    /// - Note: Potential performance improvements may be gained by de-duplicating the collection before rendering. This will be left until performance tests are prepared.
    private
    var renderQueue = [Render]()
    
    // TODO: Currently, this is unused at this location. It is also stored by the root element host.
    /// The renderer's root renderable target.
    let rootTarget: UIKitTarget
    
    /// The root of the Live Tree.
    let rootElementHost: ElementHost
    
    /// The provided renderer which will be used to create renderable primitives.
    ///
    /// - Note: The renderer stores a strong reference to this reconciler object.
    private(set)
    unowned
    var renderer: UIKitRenderer
    
    /// A platform-specific event loop scheduler.
    ///
    /// Often, rendering updates are queued due to user interactions.
    /// To make updates non-blocking of the current cycle,
    /// reconciliation should be performed on the event loop following the one which received user interaction.
    private
    let scheduler: (@escaping () -> Void) -> Void
    
    init<Content>(content: Content,
                  target: UIKitTarget,
                  renderer: UIKitRenderer,
                  scheduler: @escaping (@escaping () -> Void) -> Void)
    where Content : SContent {
        self.renderer = renderer
        self.scheduler = scheduler
        self.rootTarget = target
        
        rootElementHost = AnySContent(content).makeElementHost(with: renderer,
                                                               parentTarget: rootTarget,
                                                               parent: nil)
        
        performInitialMount()
    }
    
    // TODO: Need init for other element types.
    
    private
    func performInitialMount() {
        rootElementHost.mount(beforeSibling: nil,
                              onParent: nil,
                              reconciler: self)
        performPostrenderCallbacks()
    }
    
    // MARK: - enqueuing updates and reconciling
    
    /// Updates the host's storage and schedules a render update.
    private
    func queueStorageUpdate(for elementHost: CompositeElementHost,
                              id: Int,
                              updateHandler: (inout Any) -> Void) {
        updateHandler(&elementHost.storage[id])
        queueUpdate(for: elementHost)
    }
    
    /// Adds the host to the render queue.
    ///
    /// If a rendering has already been scheduled within this event loop, the host is simply added to the existing queue.
    private
    func queueUpdate(for elementHost: CompositeElementHost) {
        let shouldSchedule = renderQueue.isEmpty
        renderQueue.append(.init(element: elementHost))
        
        guard shouldSchedule else { return }
        scheduler { [weak self] in self?.updateStateAndReconcile() }
    }
    
    /// Traverses the render queue and performs updates.
    private
    func updateStateAndReconcile() {
        let queue = renderQueue
        renderQueue.removeAll()
        
        for render in queue {
            render.element.update(inReconciler: self)
        }
        
        performPostrenderCallbacks()
    }
    
    // MARK: - storage and subscriptions
    
    private
    func initStorage(id: Int,
                     for property: PropertyInfo,
                     of compositeElement: CompositeElementHost,
                     bodyKeyPath: ReferenceWritableKeyPath<CompositeElementHost, Any>) {

        var storage = property.get(from: compositeElement[keyPath: bodyKeyPath]) as! ValueStorage
        
        if compositeElement.storage.count == id {
            compositeElement.storage.append(storage.anyInitialValue)
        }
        
        if storage.getter == nil {
            storage.getter = { compositeElement.storage[id] }
            
            guard var writableStorage = storage as? WritableValueStorage else {
                return property.set(value: storage, on: &compositeElement[keyPath: bodyKeyPath])
            }
            
            // TODO: Need Transaction param.
            writableStorage.setter = { [weak self, weak compositeElement] newValue in
                guard let element = compositeElement else { return }
                self?.queueStorageUpdate(for: element, id: id, updateHandler: { $0 = newValue })
            }
            
            property.set(value: writableStorage, on: &compositeElement[keyPath: bodyKeyPath])
        }
    }
    
    /// ...
    private
    func initTransientSubscription(for property: PropertyInfo,
                                   of compositeElement: CompositeElementHost,
                                   bodyKeyPath: ReferenceWritableKeyPath<CompositeElementHost, Any>) {
        let observed = property.get(from: compositeElement[keyPath: bodyKeyPath]) as! SObservedProperty
        
        observed
            .objectWillChange
            .sink { [weak self, weak compositeElement] _ in
                guard let compositeElement = compositeElement else { return }
                self?.queueUpdate(for: compositeElement)
            }
            .store(in: &compositeElement.transientSubscriptions)
    }
    
    /* TODO: Need EnvironmentValues and AppHost.
    private
    func initPersistentSubscription<T: Equatable>(for publisher: AnyPublisher<T, Never>,
                                                  to keyPath: WritableKeyPath<SEnvironmentValues, T>,
                                                  of appHost: AppHost) {
        // TODO: ...
        
    }
     */
    
    // MARK: - rendering and composite processing
    
    /// Updates the host's environment, inspects the element's body and sets up the host's value storage and transient subscriptions.
    ///
    /// - Returns: The body of the host's composite element using the provided key path.
    private
    func processBody(of compositeElement: CompositeElementHost,
                     keyPath: ReferenceWritableKeyPath<CompositeElementHost, Any>) -> Any {
        
        compositeElement.updateEnvironment()
        
        if let typeInfo = typeInfo(of: compositeElement.hostedElementType) {
            var stateIdx = 0
            let dynamicProperties = typeInfo.dynamicProperties(in: &compositeElement[keyPath: keyPath])
            
            compositeElement.transientSubscriptions = []
            
            for property in dynamicProperties {
                // set up state and subscriptions
                if property.type is ValueStorage.Type {
                    initStorage(id: stateIdx,
                                for: property,
                                of: compositeElement,
                                bodyKeyPath: keyPath)
                    stateIdx += 1
                }
                if property.type is SObservedProperty.Type {
                    initTransientSubscription(for: property,
                                                 of: compositeElement,
                                                 bodyKeyPath: keyPath)
                }
            }
        }
        
        return compositeElement[keyPath: keyPath]
    }
    
    /// Processes the body of the host's composite element and then asks the renderer for a rendered version of the body or continues down the chain if one is not provided.
    ///
    /// - Returns: The rendered primitive body of the host's composite element or the non-primitive body if a rendered body is not provided.
    func render(compositeElement: CompositeElementHost) -> AnySContent {
        let content = processBody(of: compositeElement,
                                  keyPath: \.content.content)
        
        guard let renderedBody = renderer.bodyFor(primitiveContent: content) else {
            return compositeElement.content.bodyProvider(content)
        }
        
        return renderedBody
    }
    
    // TODO: Need rendering for other element types.
    
    /*
     func render(mountedApp: MountedApp<R>) -> _AnyScene {
     mountedApp.app.bodyClosure(body(of: mountedApp, keyPath: \.app.app))
     }
     
     func render(mountedScene: MountedScene<R>) -> _AnyScene.BodyResult {
     mountedScene.scene.bodyClosure(body(of: mountedScene, keyPath: \.scene.scene))
     }
     */
    
    /// Reconciles the `CompositeElementHost` with an updated element.
    ///
    /// Compares the existing composite host's elements to the updated element and either adds, replaces, or updates them in-place.
    func reconcile<Element>(compositeElement: CompositeElementHost,
                            with element: Element,
                            getElementType: (Element) -> Any.Type,
                            updateChild: (ElementHost) -> Void,
                            mountChild: (Element) -> ElementHost) {
        
        // FIXME: for now without properly handling `Group` and `TupleView` mounted composite views
        // have only a single element in `mountedChildren`, but this will change when
        // fragments are implemented and this switch should be rewritten to compare
        // all elements in `mountedChildren`
        switch (compositeElement.children.last, element) {
            case let (nil, elementBody):
                // no live children previously, but now there are
                let child = mountChild(elementBody)
                compositeElement.children = [child]
                child.mount(beforeSibling: nil,
                            onParent: nil,
                            reconciler: self)
                
            case let (liveChild?, elementBody):
                // some live children before and now
                let childBodyType = getElementType(elementBody)
                
                if liveChild.typeConstructorName == typeConstructorName(childBodyType) {
                    // new child has the same type as the existing child
                    updateChild(liveChild)
                    liveChild.update(inReconciler: self)
                }
                else {
                    // new child is a different type.
                    // unmount the old child, then mount a new one with the new `childBody`
                    liveChild.unmount(in: self, parentTask: nil)
                    
                    let newMountedChild = mountChild(elementBody)
                    compositeElement.children = [newMountedChild]
                    newMountedChild.mount(beforeSibling: nil,
                                          onParent: nil,
                                          reconciler: self)
                }
        }
    }
    
    private
    var postrenderCallbackQueue = [() -> Void]()
    
    /// Adds the callback to the postrender queue.
    func afterCurrentRender(perform callback: @escaping () -> Void) {
        postrenderCallbackQueue.append(callback)
    }
    
    /// Iterates the `postrenderCallbackQueue`, calling each handler, then empties the queue.
    private
    func performPostrenderCallbacks() {
        postrenderCallbackQueue.forEach { $0() }
        postrenderCallbackQueue.removeAll()
    }
}
