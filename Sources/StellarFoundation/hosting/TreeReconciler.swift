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
public
struct TreeReconciler {
    
    struct Update: Hashable {
        let host: _CompositeElementHost
        // TODO:
        // let transaction: Transaction
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(host.state)
        }
        static
        func == (lhs: Self, rhs: Self) -> Bool {
            lhs.host.state == rhs.host.state
        }
    }
    
    // TODO: Investigate uniquing this collection for efficiency.
    /// A stack of `Render` values which need reconciliation.
    ///
    private
    var updateQueue = [Update]()
    
    typealias HostTreeNode = TreeNode<_Host>
    private
    let hostTreeRoot: HostTreeNode
    
    /// A platform-specific event loop scheduler.
    ///
    /// Often, rendering updates are queued due to user interactions.
    /// To make updates non-blocking of the current cycle,
    /// reconciliation should be performed on the event loop following the one which received user interaction.
    private
    let scheduler: (@escaping () -> Void) -> Void
    
    public
    init(app: any SApp,
         rootPlatformContent: PlatformContent,
         scheduler: @escaping (@escaping () -> Void) -> Void) {
        self.scheduler = scheduler
        
        let appHost = _AppHost(anyApp: app, state: .init())
        hostTreeRoot = .init(host: appHost)
        
        performMount()
        // TODO: publishing of scene phase, color scheme to app host.
    }
    
    public
    init(content: any SContent,
         rootPlatformContent: PlatformContent,
         platformExecutionScheduler: @escaping (@escaping () -> Void) -> Void) {
        self.scheduler = platformExecutionScheduler
        
        let contentHost = content.makeHost(parentPlatformContent: rootPlatformContent, parentHost: nil)
        hostTreeRoot = .init(host: contentHost)
        
        performMount()
    }
    
    /// Performs a recursive mounting process of the descriptive tree onto a host tree. During the process the platform is allowed to create renderable elements.
    private
    mutating
    func performMount() {
        // TODO: This will now perform mounting for the entire tree, as the reconciler takes ownership of the host tree.
        recursiveMount(node: hostTreeRoot,
                       beforeSibling: nil)
        performPostrenderCallbacks()
    }
    
    private
    mutating
    func recursiveMount(node: HostTreeNode, beforeSibling sibling: PlatformContent?) {
        
        if var mutableCompositeElementHost = node.value as? _MutableCompositeElementHost {
            processBody(of: &mutableCompositeElementHost)
        }
        
        let elementBody = node.value.elementBody
        // TODO: This may be an appropriate spot to tell the host to mount, if hosts need to perform their own mounting behaviors.
        node.value.mount()
        let childHost = makeHost(for: elementBody)
        let childNode = HostTreeNode(value: childHost, children: [])
        if let sibling {
            // TODO: Insert the new host before the sibling.
        }
        else {
            node.children.append(childNode)
        }
        
        recursiveMount(node: childNode, beforeSibling: nil)
    }
    
    /// Creates a host appropriate for the type of element.
    func makeHost(for element: Any) -> _Host {
        // empties
        if let emptyContent = element as? SEmptyContent {
            return _EmptyElementHost(element: .content(emptyContent))
        }
        // primitives
        else if let primitiveContent = element as? any SContent,
                primitiveContent.body.self is Never {
            
        }
        else if let primitiveScene = element as? any SScene,
                primitiveScene.body.self is Never {
            
        }
        // composites
        else if let app = element as? any SApp {
            return _AppHost(anyApp: app, state: .init())
        }
        else if let scene = element as? any SScene {
            return _CompositeSceneHost(anyScene: scene, state: .init())
        }
        else if let content = element as? any SContent {
            return _CompositeContentHost(anyContent: content, state: .init())
        }
        else { fatalError() }
    }
    
    // MARK: - enqueuing updates
    
    /// Enqueues an update for the host.
    ///
    /// If a rendering has already been scheduled within this event loop, the host is simply added to the existing queue.
    private
    func enqueueUpdate(for host: _CompositeElementHost) {
        let shouldSchedule = updateQueue.isEmpty
        updateQueue.append(.init(host: host))
        
        guard shouldSchedule else { return }
        scheduler { [weak self] in self?.updateStateAndReconcile() }
    }
    
    /// Performs enqueued updates.
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
                     element: inout Any,
                     mutableState: MutableReference<CompositeElementState>,
                     enqueueStorageUpdate: (Any) -> Void) {

        var storage = property.get(from: element) as! ValueStorage
        
        if mutableState.storage.count == id {
            mutableState.storage.append(storage.anyInitialValue)
        }
        
        if storage.getter == nil {
            storage.getter = { mutableState.storage[id] }
            
            guard var writableStorage = storage as? WritableValueStorage else {
                return property.set(value: storage, on: &element)
            }
            
            // TODO: Need Transaction param.
            writableStorage.setter = { enqueueStorageUpdate($0) }
            
            property.set(value: writableStorage, on: &element)
        }
    }
    
    /// ...
    private
    func initTransientSubscription(for property: PropertyInfo,
                                   of host: inout _MutableCompositeElementHost) {
        (property.get(from: host.hostedElement) as! SObservedProperty)
            .objectWillChange
            .sink { [weak self] _ in
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
    
    // MARK: - composite processing
    
    /// Updates the host's environment and inspects the hosted element at the key path to set up the host's value storage and transient subscriptions.
    func processBody(of host: inout _MutableCompositeElementHost) {
        
        host.updateEnvironment()
        
        guard let typeInfo = typeInfo(of: getType(host.hostedElement))
        else {
            // TODO: If type info cannot be determined, it's likely that a class type was provided and the client should be informed in some way.
            fatalError()
        }
        
        var stateIdx = 0
        let dynamicProperties = typeInfo.dynamicProperties(in: &host.hostedElement)
        
        host.transientSubscriptions = []
        
        for property in dynamicProperties {
            // set up state and subscriptions
            if property.type is ValueStorage.Type {
                initStorage(id: stateIdx,
                            for: property,
                            element: &host.hostedElement,
                            mutableState: host.mutableState) { newValue in
                    host.storage[stateIdx] = newValue
                    enqueueUpdate(for: host)
                }
                stateIdx += 1
            }
            if property.type is SObservedProperty.Type {
                initTransientSubscription(for: property,
                                          of: &host)
            }
        }
    }
    
    // MARK: tree reconciliation
    
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
