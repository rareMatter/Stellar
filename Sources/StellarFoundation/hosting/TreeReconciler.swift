//
//  TreeReconciler.swift
//  
//
//  Created by Jesse Spencer on 10/22/21.
//

import Combine
import OrderedCollections
import utilities

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
// TODO: This might be more aptly named HostTreeManager or such.
#warning("Ensure environment is updated in hosts, hosted elements.")
#warning("Resource Location: HostUtility. Avoids exposing types as public.")
@MainActor
public
final
class TreeReconciler {
    
    struct Update {
        let node: HostTreeNode
        // TODO:
        // let transaction: Transaction
        
        static
        func update(_ node: HostTreeNode) -> Self {
            .init(node: node)
        }
    }
    
    // TODO: Investigate uniquing this collection for efficiency.
    /// A stack of `Render` values which need reconciliation.
    ///
    private
    var updateQueue = [Update]()
    
    private
    let hostTreeRoot: HostTreeNode
    
    /// A platform-specific event loop scheduler.
    ///
    /// Often, rendering updates are queued due to user interactions.
    /// To make updates non-blocking of the current cycle,
    /// reconciliation should be performed on the event loop following the one which received user interaction.
    private
    let scheduler: (@escaping @autoclosure () -> Void) -> Void
    
    public
    init(app: any SApp,
         rootPlatformContent: PlatformContent,
         scheduler: @escaping (@escaping @autoclosure () -> Void) -> Void) {
        self.scheduler = scheduler
        hostTreeRoot = HostTreeNode(value: HostingContainer(host: HostUtility.makeHost(for: app, parentRenderedElement: rootPlatformContent), renderedElement: nil, renderContext: RenderContext(modifiers: OrderedSet())))
        performMount()
        // TODO: publishing of scene phase, color scheme to app host.
    }
    
    public
    init(content: any SContent,
         rootPlatformContent: PlatformContent,
         platformExecutionScheduler: @escaping (@escaping @autoclosure () -> Void) -> Void) {
        self.scheduler = platformExecutionScheduler
        hostTreeRoot = HostTreeNode(value: HostingContainer(host: HostUtility.makeHost(for: content, parentRenderedElement: rootPlatformContent), renderContext: RenderContext(modifiers: OrderedSet())))
        performMount()
    }
    
    /// Performs a recursive mounting process of the descriptive tree onto a host tree. During the process the platform is allowed to create renderable elements.
    private
    func performMount() {
        recursiveMount(node: hostTreeRoot)
        performPostrenderCallbacks()
    }
    
    private
    func recursiveMount(node: HostTreeNode) {
        // render
        let renderOutput = node.value.host.render(with: node.value.renderContext) { [weak self] in
            guard let self else { return }
            self.enqueueUpdate(for: node)
        }
        
        // store properties of render output need by children and render children.
        node.value.renderedElement = renderOutput.renderedElement
        node.value.renderContext = .init(modifiers: renderOutput.modifiers)
        
        node.children = renderOutput.children.map {
            return HostTreeNode(parent: node, value: .init(host: HostUtility.makeHost(for: $0, parentRenderedElement: node.value.renderedElement), renderContext: RenderContext(modifiers: renderOutput.modifiers)))
        }
        node.children.forEach { child in
            recursiveMount(node: child)
        }
    }
    
    private
    func recursiveUpdate(_ node: HostTreeNode) {
        // TODO: Update environment.
//        childNode.value.host.updateEnvironment()
        // update host
        let output = node.value.host.update(with: node.value.renderContext) { [weak self] in
            guard let self else { return }
            self.enqueueUpdate(for: node)
        }
        
        // TODO: Is this necessary?
        node.value.renderedElement = output.renderedElement
        node.value.renderContext = .init(modifiers: output.modifiers)
        
        reconcileHostChildren(node, newChildElements: output.children)
    }
    
    /// Recursively dismantles the tree.
    ///
    /// - Important: Does not prune the tree. It is up to the caller to prune the dismantled subtree at the root.
    private
    func recursiveDismantle(_ node: HostTreeNode) {
        node.value.host.dismantle(with: node.value.renderContext)
        node.children.forEach { childNode in
            recursiveDismantle(childNode)
        }
    }
    
    private
    func reconcileHostChildren(_ node: HostTreeNode, newChildElements: [CompositeElement]) {
        
        var newChildElements = newChildElements
        
        switch (node.children.isEmpty, newChildElements.isEmpty) {
        case (false, true):
            // all existing children were removed
            node.children.forEach { childNode in
                recursiveDismantle(childNode)
            }
            node.children = []
            
        case (true, false):
            // children were added
            node.children = newChildElements.map { element in
                HostTreeNode(parent: node, value: HostingContainer(host: HostUtility.makeHost(for: element, parentRenderedElement: node.value.renderedElement), renderContext: node.value.renderContext))
            }
            node.children.forEach { node in
                recursiveMount(node: node)
            }
            
        case (true, true):
            // children were changed, reconcile differences
            var newChildren = [_Host]()
            
            // compare each existing and new child.
            // replace if types differ, otherwise update.
            while let childNode = node.children.first,
                  let childElement = newChildElements.first {
                let newChildHost: _Host
                
                // same types
                if typeConstructorName(getType(childNode.value.host.element)) == typeConstructorName(getType(childElement)) {
                    // TODO: update child host environment
                    // replace existing element
                    childNode.value.host.element = childElement
                    recursiveUpdate(childNode)
                    newChildHost = childNode.value.host
                }
                // differing types,
                // create a new element host, render, then dismantle the old child.
                else {
                    newChildHost = HostUtility.makeHost(for: childElement, parentRenderedElement: node.value.renderedElement)
                    /* TODO: Mount with sibling?
                     newChild.mount(beforeSibling: childHost.firstPrimitivePlatformContent(),
                     onParent: self,
                     reconciler: reconciler)
                     */
                    recursiveMount(node: HostTreeNode(parent: node, value: HostingContainer(host: newChildHost, renderContext: node.value.renderContext)))
                    recursiveDismantle(childNode)
                }
                
                newChildren.append(newChildHost)
                node.children.removeFirst()
                newChildElements.removeFirst()
            }
            
            if !node.children.isEmpty {
                // more existing host children than new children, dismantle them
                node.children.forEach { childNode in
                    recursiveDismantle(childNode)
                }
            }
            else {
                // render any remaining children
                newChildElements.forEach { childElement in
                    let newChild: _Host = HostUtility.makeHost(for: childElement, parentRenderedElement: node.value.renderedElement)
                    recursiveMount(node: HostTreeNode(parent: node, value: HostingContainer(host: newChild, renderContext: node.value.renderContext)))
                    newChildren.append(newChild)
                }
            }
            
            node.children = newChildren.map { child in
                HostTreeNode(parent: node, value: HostingContainer(host: child, renderContext: node.value.renderContext))
            }
            
        case (false, false):
            // no children to update
            break
        }
    }
    
    // MARK: - enqueuing updates
    
    /// Enqueues an update for the host.
    ///
    /// If a rendering has already been scheduled within this event loop, the host is simply added to the existing queue.
    private
    func enqueueUpdate(for node: HostTreeNode) {
        updateQueue.append(.update(node))
        
        guard updateQueue.isEmpty else { return }
        
        let weakRef = Weak(self)
        scheduler(weakRef.value!.updateStateAndReconcile())
    }
    
    /// Performs queued updates.
    private
    func updateStateAndReconcile() {
        let queue = updateQueue
        updateQueue.removeAll()
        
        // TODO: This needs to reconcile child nodes, which will no longer be handled by the hosts. Pass render context down.
        queue.forEach { update in
            recursiveUpdate(update.node)
        }
        
        performPostrenderCallbacks()
    }
        
    /* TODO: Need EnvironmentValues and AppHost.
    private
    func initPersistentSubscription<T: Equatable>(for publisher: AnyPublisher<T, Never>,
                                                  to keyPath: WritableKeyPath<SEnvironmentValues, T>,
                                                  of appHost: AppHost) {
        // TODO: ...
        
    }
     */
    
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
