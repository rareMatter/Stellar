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
    
    private
    let makeHostFor: (_ element: CompositeElement) -> _Host
    
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
         makeHost: @escaping (_ element: CompositeElement) -> _Host = HostUtility.makeHost(for:),
         scheduler: @escaping (@escaping @autoclosure () -> Void) -> Void) {
        self.makeHostFor = makeHost
        self.scheduler = scheduler
        
        let host = makeHost(app)
        let hostingContainer = HostingContainer(
            host: host,
            inheritedModifiers: .init(.init()),
            parentRenderedElement: .init(rootPlatformContent))
        hostTreeRoot = .init(value: hostingContainer)
        
        performMount()
        // TODO: publishing of scene phase, color scheme to app host.
    }
    
    public
    init(content: any SContent,
         rootPlatformContent: PlatformContent,
         makeHost: @escaping (_ element: CompositeElement) -> _Host = HostUtility.makeHost(for:),
         platformExecutionScheduler: @escaping (@escaping @autoclosure () -> Void) -> Void) {
        self.makeHostFor = makeHost
        self.scheduler = platformExecutionScheduler
        
        let host = makeHost(content)
        let hostingContainer = HostingContainer(
            host: host,
            inheritedModifiers: .init(.init()),
            parentRenderedElement: .init(rootPlatformContent))
        hostTreeRoot = .init(value: hostingContainer)
        
        performMount()
    }
    
    /// Performs a recursive mounting process of the descriptive tree onto a host tree. During the process the platform is allowed to create renderable elements.
    private
    func performMount() {
        recursiveRender(hostTreeRoot)
        performPostrenderCallbacks()
    }
    
    private
    func recursiveRender(_ node: HostTreeNode) {
        // TODO: Set transition phase.
        // TODO: Update environment.
//        childNode.value.host.updateEnvironment()
        // render
        let context = RenderContext(parentRenderedElement: node.value.parentRenderedElement, modifiers: node.value.inheritedModifiers.value)
        let output = node.value.host.update(with: context) { [weak self] in
            guard let self else { return }
            self.enqueueUpdate(for: node)
        }
        
        guard let output else { return }
        reconcileChildrenOf(node, using: output)
    }
    
    /// Recursively dismantles the tree.
    ///
    /// - Important: Does not prune the tree. It is up to the caller to prune the dismantled subtree at the root.
    private
    func recursiveDismantle(_ node: HostTreeNode, dismantleContext: DismantleContext) {
        node.value.host.dismantle(with: dismantleContext)
        
        let childDismantleContext = DismantleContext()
        node.children.forEach { childNode in
            recursiveDismantle(childNode, dismantleContext: childDismantleContext)
        }
    }
    
    /// Reconciles the existing children of the node with the new, provided collection of children produced from a new rendering.
    /// - Parameters:
    ///   - node: The node whose children need to be reconciled after a re-render.
    ///   - childRenderContext: A render context produced by the re-render of `node`, to be provided to children, as needed, during reconciliation.
    ///   - newChildElements: The new collection of children produced from a re-render of `node`.
    private
    func reconcileChildrenOf(_ node: HostTreeNode, using renderOutput: RenderOutput) {
        
        let inheritedModifiers = renderOutput.modifiers != nil ? Reference(renderOutput.modifiers!) : node.value.inheritedModifiers
        let parentRenderedElement = renderOutput.renderedElement != nil ? Reference(renderOutput.renderedElement!) : node.value.parentRenderedElement
        
        switch (node.children.isEmpty, renderOutput.children.isEmpty) {
        case (false, true):
            // all existing children were removed
            node.children.forEach { childNode in
                recursiveDismantle(childNode, dismantleContext: .init())
            }
            node.children = []
            
        case (true, false):
            // children were added
            node.children = renderOutput.children.map {
                let host = makeHostFor($0)
                let hostingContainer = HostingContainer(
                    host: host,
                    inheritedModifiers: inheritedModifiers,
                    parentRenderedElement: parentRenderedElement)
                return HostTreeNode(parent: node, value: hostingContainer)
            }
            node.children.forEach { child in
                recursiveRender(child)
            }
            
        case (true, true):
            // children were changed, reconcile differences
            var newChildElements = renderOutput.children
            var newChildren = [_Host]()
            
            // compare each existing and new child.
            // replace if types differ, otherwise update.
            while let childNode = node.children.first,
                  let childElement = newChildElements.first {
                let newChildHost: _Host
                
                // same types - update existing node using render output
                if typeConstructorName(getType(childNode.value.host.element)) == typeConstructorName(getType(childElement)) {
                    // TODO: update child host environment
                    // replace existing element
                    childNode.value.host.element = childElement
                    
                    if let updatedModifiers = renderOutput.modifiers {
                        childNode.value.inheritedModifiers.value = updatedModifiers
                    }
                    if let updatedParentRenderedElement = renderOutput.renderedElement {
                        childNode.value.parentRenderedElement.value = updatedParentRenderedElement
                    }
                    
                    recursiveRender(childNode)
                    newChildHost = childNode.value.host
                }
                // differing types,
                // create a new element host, render, then dismantle the old child.
                else {
                    newChildHost = makeHostFor(childElement)
                    /* TODO: Mount with sibling?
                     newChild.mount(beforeSibling: childHost.firstPrimitivePlatformContent(),
                     onParent: self,
                     reconciler: reconciler)
                     */
                    let hostingContainer = HostingContainer(host: newChildHost, inheritedModifiers: inheritedModifiers, parentRenderedElement: parentRenderedElement)
                    let newChildNode = HostTreeNode(parent: node, value: hostingContainer)
                    recursiveRender(newChildNode)
                    recursiveDismantle(childNode, dismantleContext: .init())
                }
                
                newChildren.append(newChildHost)
                node.children.removeFirst()
                newChildElements.removeFirst()
            }
            
            if !node.children.isEmpty {
                // more existing host children than new children, dismantle them
                node.children.forEach { childNode in
                    recursiveDismantle(childNode, dismantleContext: .init())
                }
            }
            else {
                // render any remaining children
                newChildElements.forEach { childElement in
                    let newChildHost = makeHostFor(childElement)
                    let hostingContainer = HostingContainer(
                        host: newChildHost,
                        inheritedModifiers: inheritedModifiers,
                        parentRenderedElement: parentRenderedElement)
                    let newChildNode = HostTreeNode(parent: node, value: hostingContainer)
                    recursiveRender(newChildNode)
                    newChildren.append(newChildHost)
                }
            }
            
            node.children = newChildren.map { child in
                let hostingContainer = HostingContainer(
                    host: child,
                    inheritedModifiers: inheritedModifiers,
                    parentRenderedElement: parentRenderedElement)
                return HostTreeNode(parent: node, value: hostingContainer)
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
        
        queue.forEach { update in
            recursiveRender(update.node)
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
