//
//  TreeReconciler.swift
//  
//
//  Created by Jesse Spencer on 10/22/21.
//

import Combine
import SwiftUI

/// The `TreeReconciler` handles updating of the "Live Tree" (such as `PrimitiveViewHost`) when state changes are seen in the dynamic properties declared by the "Descriptive Tree" (such as `SContent` values), or other changes occur which require updates, such as user interactions or environment properties.
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
class TreeReconciler<R: Renderer> {
    
    struct Render: Hashable {
        let element: CompositeElementHost<R>
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
    
    /// The root target provided at creation of this renderer which hosts the platform-specific `Descriptive Tree`.
    ///
    /// Use this from your platform renderer to access the rendered content hierarchy, generally when installing the rendered content into your user-visible window or viewport.
    let rootTarget: R.TargetType
    
    /// The root of the `Live Tree` of hosted elements.
    ///
    /// This host hierarchy is used by the framework to update rendered content after state changes occur.
    let rootElementHost: ElementHost<R>
    
    /// The provided renderer which will be used to create renderable primitives.
    ///
    /// - Note: The renderer stores a strong reference to this reconciler object.
    private(set)
    unowned
    var renderer: R
    
    /// A platform-specific event loop scheduler.
    ///
    /// Often, rendering updates are queued due to user interactions.
    /// To make updates non-blocking of the current cycle,
    /// reconciliation should be performed on the event loop following the one which received user interaction.
    private
    let scheduler: (@escaping () -> Void) -> Void
    
    init<Content>(content: Content,
                  target: R.TargetType,
                  renderer: R,
                  scheduler: @escaping (@escaping () -> Void) -> Void)
    where Content : SContent {
        self.renderer = renderer
        self.scheduler = scheduler
        self.rootTarget = target
        
        rootElementHost = AnySContent(content).makeElementHost(with: renderer,
                                                               parentTarget: rootTarget,
                                                               parentHost: nil)
        
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
    func queueStorageUpdate(for elementHost: CompositeElementHost<R>,
                              id: Int,
                              updateHandler: (inout Any) -> Void) {
        updateHandler(&elementHost.storage[id])
        queueUpdate(for: elementHost)
    }
    
    /// Adds the host to the render queue.
    ///
    /// If a rendering has already been scheduled within this event loop, the host is simply added to the existing queue.
    private
    func queueUpdate(for elementHost: CompositeElementHost<R>) {
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
                     of compositeElement: CompositeElementHost<R>,
                     bodyKeyPath: ReferenceWritableKeyPath<CompositeElementHost<R>, Any>) {

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
                                   of compositeElement: CompositeElementHost<R>,
                                   bodyKeyPath: ReferenceWritableKeyPath<CompositeElementHost<R>, Any>) {
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
    
    /// Updates the host's environment and inspects the hosted element at the key path to set up the host's value storage and transient subscriptions.
    func processBody(of compositeElementHost: CompositeElementHost<R>,
                     hostedElement: ReferenceWritableKeyPath<CompositeElementHost<R>, Any>) {
        
        compositeElementHost.updateEnvironment()
        
        guard let typeInfo = typeInfo(of: compositeElementHost.hostedElementType)
        else {
            // TODO: If type info cannot be determined, it's likely that a class type was provided and the client should be informed in some way.
            fatalError()
        }
        
        var stateIdx = 0
        let dynamicProperties = typeInfo.dynamicProperties(in: &compositeElementHost[keyPath: hostedElement])
        
        compositeElementHost.transientSubscriptions = []
        
        for property in dynamicProperties {
            // set up state and subscriptions
            if property.type is ValueStorage.Type {
                initStorage(id: stateIdx,
                            for: property,
                            of: compositeElementHost,
                            bodyKeyPath: hostedElement)
                stateIdx += 1
            }
            if property.type is SObservedProperty.Type {
                initTransientSubscription(for: property,
                                          of: compositeElementHost,
                                          bodyKeyPath: hostedElement)
            }
        }
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
    
    /// Reconciles the `CompositeElementHost` children with an updated child element.
    ///
    /// Compares the existing composite host's child elements to the updated child element and either adds, replaces, or updates them in-place.
    func reconcileChildren<Element>(_ compositeElementHost: CompositeElementHost<R>,
                            with childElement: Element,
                            getElementType: (Element) -> Any.Type,
                            updateChildHost: (ElementHost<R>) -> Void,
                            mountChildElement: (Element) -> ElementHost<R>) {
        
        // FIXME: for now without properly handling `Group` and `TupleView` mounted composite views
        // have only a single element in `mountedChildren`, but this will change when
        // fragments are implemented and this switch should be rewritten to compare
        // all elements in `mountedChildren`
        switch (compositeElementHost.children.last, childElement) {
        case let (nil, childElement):
            // a child was added.
            // use the mounting closure to create a child host,
            // and add it to the parent then tell it to mount.
            let childHost = mountChildElement(childElement)
            compositeElementHost.children = [childHost]
            childHost.mount(beforeSibling: nil,
                            onParent: nil,
                            reconciler: self)
            
        case let (liveChild?, childElement):
            // there is already children, reconcile the differences.
            let childBodyType = getElementType(childElement)
            
            // new child has the same type as the existing child
            if liveChild.typeConstructorName == typeConstructorName(childBodyType) {
                updateChildHost(liveChild)
                liveChild.update(inReconciler: self)
            }
            else {
                // new child is a different type.
                // unmount the old child, then mount a new one with the new `childBody`
                liveChild.unmount(in: self, parentTask: nil)
                
                let newChildHost = mountChildElement(childElement)
                compositeElementHost.children = [newChildHost]
                newChildHost.mount(beforeSibling: nil,
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
