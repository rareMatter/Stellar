//
//  TreeReconciler.swift
//  
//
//  Created by Jesse Spencer on 10/22/21.
//

import Combine

/// The `Tree Reconciler` handles updating of the "Live Tree" (such as `PrimitiveViewHost`) when state changes are observed in the "Descriptive Tree" (`SContent` values), or other changes occur which require updates, such as user interactions or environment properties.
///
/// Any updates in the Descriptive Tree are reflected in the Live Tree.
///
/// How does the Tree Reconciler understand user-created types?
///
/// The reconciler uses Swift's reflection capabilities in order to inspect and understand Content types that flow through it. While this happens, the reconciler retrieves the properties of types that it's interested in, such as dynamic properties, which will cause updates to the Live Tree.
///
/// The Tree Reconciler will delegate to a platform-specific Renderer which needs to provide a rendered (or renderable) translation that the platform can display on-screen. The platform content instances will be requested or updated whenever changes occur and the Live Tree needs to be reconciled with the Descriptive Tree's state in order to update the rendered hierarchy.
///
// TODO: Investigate concurrent content updating.
// FIXME: Temp public.
public final
class TreeReconciler {
    
    struct Update: Hashable {
        let host: CompositeElementHost
        // TODO:
        // let transaction: Transaction
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(host)
        }
        static
        func == (lhs: Self, rhs: Self) -> Bool {
            lhs.host == rhs.host
        }
    }
    
    // TODO: Investigate uniquing this collection for efficiency.
    /// A stack of `Render` values which need reconciliation.
    ///
    private
    var updateQueue = [Update]()
    
    /// The root of the `Host Tree`.
    let rootHost: ElementHost
    
    /// A platform-specific event loop scheduler.
    ///
    /// Often, rendering updates are queued due to user interactions.
    /// To make updates non-blocking of the current cycle,
    /// reconciliation should be performed on the event loop following the one which received user interaction.
    private
    let scheduler: (@escaping () -> Void) -> Void
    
    init<A>(app: A,
            rootPlatformContent: PlatformContent,
            scheduler: @escaping (@escaping () -> Void) -> Void)
    where A : SApp {
        self.scheduler = scheduler
        
        self.rootHost = AppHost(element: .app(.init(app)), parentPlatformContent: rootPlatformContent, parent: nil)
        
        performInitialMount()
        // TODO: publishing of scene phase, color scheme to app host.
    }
    
    // FIXME: Temp public.
    public
    init<Content>(content: Content,
                  rootPlatformContent: PlatformContent,
                  platformExecutionScheduler: @escaping (@escaping () -> Void) -> Void)
    where Content : SContent {
        self.scheduler = platformExecutionScheduler
        
        rootHost = content.makeHost(parentPlatformContent: rootPlatformContent, parentHost: nil)
        
        performInitialMount()
    }
    
    private
    func performInitialMount() {
        rootHost.mount(beforeSibling: nil,
                              onParent: nil,
                              reconciler: self)
        performPostrenderCallbacks()
    }
    
    // MARK: - enqueuing updates and reconciling
    
    /// Updates the host's storage and schedules a render update.
    private
    func enqueueStorageUpdate(for host: CompositeElementHost,
                              id: Int,
                              updateHandler: (inout Any) -> Void) {
        updateHandler(&host.storage[id])
        enqueueUpdate(for: host)
    }
    
    /// Adds the host to the render queue.
    ///
    /// If a rendering has already been scheduled within this event loop, the host is simply added to the existing queue.
    private
    func enqueueUpdate(for host: CompositeElementHost) {
        let shouldSchedule = updateQueue.isEmpty
        updateQueue.append(.init(host: host))
        
        guard shouldSchedule else { return }
        scheduler { [weak self] in self?.updateStateAndReconcile() }
    }
    
    /// Traverses the render queue and performs updates.
    private
    func updateStateAndReconcile() {
        let queue = updateQueue
        updateQueue.removeAll()
        
        for render in queue {
            render.host.update(inReconciler: self)
        }
        
        performPostrenderCallbacks()
    }
    
    // MARK: - storage and subscriptions
    
    private
    func initStorage(id: Int,
                     for property: PropertyInfo,
                     of host: CompositeElementHost,
                     bodyKeyPath: ReferenceWritableKeyPath<CompositeElementHost, Any>) {

        var storage = property.get(from: host[keyPath: bodyKeyPath]) as! ValueStorage
        
        if host.storage.count == id {
            host.storage.append(storage.anyInitialValue)
        }
        
        if storage.getter == nil {
            storage.getter = { host.storage[id] }
            
            guard var writableStorage = storage as? WritableValueStorage else {
                return property.set(value: storage, on: &host[keyPath: bodyKeyPath])
            }
            
            // TODO: Need Transaction param.
            writableStorage.setter = { [weak self, weak host] newValue in
                guard let host = host else { return }
                self?.enqueueStorageUpdate(for: host, id: id, updateHandler: { $0 = newValue })
            }
            
            property.set(value: writableStorage, on: &host[keyPath: bodyKeyPath])
        }
    }
    
    /// ...
    private
    func initTransientSubscription(for property: PropertyInfo,
                                   of host: CompositeElementHost,
                                   bodyKeyPath: ReferenceWritableKeyPath<CompositeElementHost, Any>) {
        let observed = property.get(from: host[keyPath: bodyKeyPath]) as! SObservedProperty
        
        observed
            .objectWillChange
            .sink { [weak self, weak host] _ in
                guard let host = host else { return }
                self?.enqueueUpdate(for: host)
            }
            .store(in: &host.transientSubscriptions)
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
    func processBody(of host: CompositeElementHost,
                     hostedElement: ReferenceWritableKeyPath<CompositeElementHost, Any>) {
        
        host.updateEnvironment()
        
        guard let typeInfo = typeInfo(of: host.hostedElementType)
        else {
            // TODO: If type info cannot be determined, it's likely that a class type was provided and the client should be informed in some way.
            fatalError()
        }
        
        var stateIdx = 0
        let dynamicProperties = typeInfo.dynamicProperties(in: &host[keyPath: hostedElement])
        
        host.transientSubscriptions = []
        
        for property in dynamicProperties {
            // set up state and subscriptions
            if property.type is ValueStorage.Type {
                initStorage(id: stateIdx,
                            for: property,
                            of: host,
                            bodyKeyPath: hostedElement)
                stateIdx += 1
            }
            if property.type is SObservedProperty.Type {
                initTransientSubscription(for: property,
                                          of: host,
                                          bodyKeyPath: hostedElement)
            }
        }
    }
    
    /// Reconciles the host's children with an updated child element.
    ///
    /// Compares the existing composite host's child elements to the updated child element and either adds, replaces, or updates them in-place.
    func reconcileChildren<Element>(for host: CompositeElementHost,
                            withChild childElement: Element,
                            elementType: (Element) -> Any.Type,
                            updateChildHost: (ElementHost) -> Void,
                            mountChildElement: (Element) -> ElementHost) {
        
        // FIXME: for now without properly handling `Group` and `TupleView` mounted composite views
        // have only a single element in `mountedChildren`, but this will change when
        // fragments are implemented and this switch should be rewritten to compare
        // all elements in `mountedChildren`
        switch (host.children.last, childElement) {
        case let (nil, childElement):
            // a child was added.
            // use the mounting closure to create a child host,
            // and add it to the parent then tell it to mount.
            let childHost = mountChildElement(childElement)
            host.children = [childHost]
            childHost.mount(beforeSibling: nil,
                            onParent: nil,
                            reconciler: self)
            
        case let (liveChild?, childElement):
            // there is already children, reconcile the differences.
            let childBodyType = elementType(childElement)
            
            // new child has the same type as the existing child
            if liveChild.hostedElement.typeConstructorName == typeConstructorName(childBodyType) {
                updateChildHost(liveChild)
                liveChild.update(inReconciler: self)
            }
            else {
                // new child is a different type.
                // unmount the old child, then mount a new one with the new `childBody`
                liveChild.unmount(in: self, parentTask: nil)
                
                let newChildHost = mountChildElement(childElement)
                host.children = [newChildHost]
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
