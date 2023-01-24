//
//  Reconciler.swift
//  
//
//  Created by Jesse Spencer on 12/8/22.
//

import Combine
import OrderedCollections

public
protocol Reconciler: AnyObject {
    
    // TODO: How can a platform associate a scene instance provided by its system with a scene description provided by the app?
    // system says: a scene is requested by the user. How should it be configured?
    // reconciler: what kind of scene? which scene description should be used to configure it?
    // - scene kind
    // - identifier
    // - type structure
    // These different levels of identity allow different levels of association. If only scene kind association is possible on a platform (seemingly iOS), then multiple scenes of the same primitive type (i.e. WindowGroup) will not be possible because association can only be made at the "kind" (type-erasure due to different types; i.e. Apple provides the scene type) and not type-level. If a stronger association (type structure, identifier) is possible on the platform (i.e. scene type can be declared or an identifier can be specified) then variadic same-type primitive scenes can be declared by the app.
    // .. This will be apparent when building support for macOS because Window requires an ID when created.
    
    // TODO: This is needed so the platform can prepare to render scenes when the system provides the rendered instance.
    // This could contain multiple WindowGroups, or other platform-specific scenes like a menu bar or settings.
    var scenes: [SceneContext] { get }
    
    // TODO: When a scene is added or removed, the reconciler should traverse the scene hosts until a matching type is found. When found, create a new host for the scene and append it to the children of the parent host.
    /// Creates a new scene with its own state and content hierarchy using the specified type as a template.
    func addNewSceneInstance(_ scene: SceneContext, platformContent: PlatformContent)
    func replaceExistingScene(_ scene: SceneContext, platformContent: PlatformContent)
    func removeSceneInstance(_ scene: SceneContext)
}

// Scenes which produce content.
protocol ContentScene: PrimitiveScene {
    var content: [any SContent] { get }
}

// TODO: A host which manages a scene that provides a content hierarchy.
// This host is the bridge from a scene to a content hierarchy. This host performs lazy rendering like other primitive scene hosts, however, it mounts a content hierarchy as its children. When the platform content instance is provided the content hierarchy is mounted.
// TODO: This host, or a different but similar host, should maintain a collection of content root instances, each of which would be its own distinct hierarchy. This would be done for Windowed scene types, which are probably an extension to Content scene types. WindowedContentScene?
/*
final class ContentSceneHost: ElementHost {
    
    let anyContentScene: any ContentScene
    var content: [any SContent] = []
    
    override
    init(scene: any PrimitiveScene, parentPlatformContent: PlatformContent, parent: ElementHost?) {
        guard let anyContentScene = scene as? any ContentScene else { fatalError() }
        self.anyContentScene = anyContentScene
        
        super.init(scene: scene, parentPlatformContent: parentPlatformContent, parent: parent)
    }
    
    override
    func performLazyMount() {
        // TODO: Mount the content provided by the content scene, appending the root to the collection.
        super.performLazyMount()
    }
}
 */

public
enum SceneKind {
    case windowGroup
    case menuBar
    case settings
}
public
struct SceneContext {
    public
    let sceneKind: SceneKind
    
//    public
//    var sceneValue: any SScene { host.scene }
    
//    internal
//    let host: PrimitiveSceneHost2
}

// -----

protocol _Host {
    var hostedElement: Any { get set }
    var elementBody: Any { get }
    func mount()
}

@dynamicMemberLookup
protocol _CompositeElementHost: _Host {
    func updateEnvironment()
    var state: Reference<CompositeElementState> { get }
}
extension _CompositeElementHost {
    subscript<T>(dynamicMember keypath: ReferenceWritableKeyPath<Reference<CompositeElementState>, T>) -> T {
        get { state[keyPath: keypath] }
    }
}
@dynamicMemberLookup
protocol _MutableCompositeElementHost: _CompositeElementHost {
    var mutableState: MutableReference<CompositeElementState> { get }
}
extension _MutableCompositeElementHost {
    subscript<T>(dynamicMember keypath: ReferenceWritableKeyPath<MutableReference<CompositeElementState>, T>) -> T {
        get { mutableState[keyPath: keypath] }
        set { mutableState[keyPath: keypath] = newValue }
    }
}

// TODO: Move tree awareness to tree reconciler. Hosts will not be aware of tree behaviors.
struct _AppHost: _CompositeElementHost {
    let anyApp: any SApp
    let state: CompositeElementState
    // TODO: Should composites store modifiers to be passed down by the reconciler?
    
    var elementBody: Any { anyApp.body }
    
    func mount() {
        
    }
    func mount(beforeSibling sibling: PlatformContent?, onParent parent: ElementHost?, reconciler: TreeReconciler) {
        // TODO: Need transaction param.
        reconciler.processBody(of: self,
                               hostedElement: \.hostedElementValue)
        
        let childHostedContent = anyApp.body
        let childHost = childHostedContent.makeHost(parentPlatformContent: parentPlatformContent, parentHost: self)
        
        children = [childHost]
        // TODO: Set transaction on child.
        childHost.mount(beforeSibling: sibling,
                        onParent: self,
                        reconciler: reconciler)
        
        // TODO: schedule post-render callbacks to handle appearance actions and update preferences.
        /*
         reconciler.afterCurrentRender { [weak self] in
         guard let self = self else { return }
         
         }
         */
    }
    
    func update(inReconciler reconciler: TreeReconciler) {
        // TODO: Handle transaction.
        // TODO: Update variadic views.
        
        reconciler.processBody(of: self,
                               hostedElement: \.hostedElementValue)
        
        let childHostedContent = anyApp.body
        reconciler.reconcileChildren(for: self,
                                     withChild: childHostedContent,
                                     elementType: { getType($0) }, updateChildHost: {
            // TODO: ...
            //            childHost.environmentValues = environmentValues
            $0.hostedElement = .scene(childHostedContent)
            //            childHost.transaction = transaction
        }, mountChildElement: {
            $0.makeHost(parentPlatformContent: parentPlatformContent, parentHost: self)
        })
    }
    
    func unmount(in reconciler: TreeReconciler, parentTask: UnmountTask?) {
        // TODO: Need Transaction and Parent Task params.
        
        // TODO: Change this bad behavior: Inference about type of self using implicit knowledge of desecendants.
        if !(self is PrimitiveViewHost) {
            unmountTask = parentTask?.appendChild()
        }
        
        if case let .content(content) = hostedElement,
           content is GroupedContent {
            // TODO: set transition phase.
        }
        else {
            // TODO: Set transition phase.
        }
        
        // TODO: ...
        /*
         if parent?.transitionPhase == .normal {
         viewTraits.insert(
         transaction.animation != nil
         || _AnyTransitionProxy(viewTraits.transition)
         .resolve(in: environmentValues)
         .removalAnimation != nil,
         forKey: CanTransitionTraitKey.self
         )
         }
         */
        
        children
            .forEach { childHost in
                childHost.unmount(in: reconciler, parentTask: parentTask)
            }
    }
}
extension _AppHost {
    var hostedElement: Any { anyApp }
    
    func updateEnvironment() {
        <#code#>
    }
}
struct _CompositeSceneHost {
    let anyScene: any SScene
    let state: CompositeElementState
    
    func mount(beforeSibling sibling: PlatformContent?, onParent parent: ElementHost?, reconciler: TreeReconciler) {
        // tell the reconciler to process self's hosted content
        reconciler.processBody(of: self,
                               hostedElement: \.hostedElementValue)
        
        // create a child host for the body of self's hosted content after it has been processed
        let childHostedContent = anyScene.body
        let childHost = childHostedContent
            .makeHost(parentPlatformContent: parentPlatformContent,
                      parentHost: self)
        
        // add child host to self and tell it to mount
        children = [childHost]
        childHost.mount(beforeSibling: sibling,
                        onParent: self,
                        reconciler: reconciler)
        
        // TODO: schedule post-render callbacks to handle appearance actions and update preferences.
        /*
         reconciler.afterCurrentRender { [weak self] in
         guard let self = self else { return }
         
         }
         */
    }
    
    func update(inReconciler reconciler: TreeReconciler) {
        // TODO: Handle transaction.
        // TODO: Update variadic views.
        
        // tell the reconciler to process self's hosted content
        // In tokamak:
        // - when self's element is "renderer primitive", the element returned by the renderer would be added as a child here.
        // - when self's element is NOT "renderer primitive" and has a body, the 'render' function would call the body and that would be used here.
        reconciler.processBody(of: self,
                               hostedElement: \.hostedElementValue)
        
        // TODO: Why is the reconcile function asking this instance to handle child behaviors in closures?
        // reconcile state changes with child content
        let childHostedContent = anyScene.body
        reconciler.reconcileChildren(for: self,
                                     withChild: childHostedContent,
                                     elementType: { getType($0) },
                                     updateChildHost: {
            // TODO: ...
            //            childHost.environmentValues = environmentValues
            $0.hostedElement = .scene(childHostedContent)
            //            childHost.transaction = transaction
        },
                                     mountChildElement: { $0.makeHost(parentPlatformContent: parentPlatformContent,
                                                                      parentHost: self) })
    }
    
    func unmount(in reconciler: TreeReconciler, parentTask: UnmountTask?) {
        // TODO: Need Transaction and Parent Task params.
        
        // TODO: Change this bad behavior: Inference about type of self using implicit knowledge of desecendants.
        if !(self is PrimitiveViewHost) {
            unmountTask = parentTask?.appendChild()
        }
        
        if case let .content(content) = hostedElement,
           content is GroupedContent {
            // TODO: set transition phase.
        }
        else {
            // TODO: Set transition phase.
        }
        
        // TODO: ...
        /*
         if parent?.transitionPhase == .normal {
         viewTraits.insert(
         transaction.animation != nil
         || _AnyTransitionProxy(viewTraits.transition)
         .resolve(in: environmentValues)
         .removalAnimation != nil,
         forKey: CanTransitionTraitKey.self
         )
         }
         */
        
        // TODO: transaction.
        
        // unmount children
        children.forEach { childHost in
            // TODO: view traits.
            //            host.viewTraits = viewTraits
            childHost.unmount(in: reconciler,
                              parentTask: parentTask)
        }
        
        // TODO: Call appearance action.
    }
}
struct _CompositeContentHost {
    let anyContent: any SContent
    let state: CompositeElementState
    
    func mount(beforeSibling sibling: PlatformContent?,
               onParent parent: ElementHost?,
               reconciler: TreeReconciler) {
        // tell the reconciler to process self's hosted content
        reconciler.processBody(of: self,
                               hostedElement: \.hostedElementValue)
        
        // create a child host for the body of self's hosted content after it has been processed
        let childHostedContent = anyContent.body
        let childHost = childHostedContent
            .makeHost(parentPlatformContent: parentPlatformContent,
                      parentHost: self)
        
        // add child host to self and tell it to mount
        children = [childHost]
        childHost.mount(beforeSibling: sibling,
                        onParent: self,
                        reconciler: reconciler)
        
        // TODO: schedule post-render callbacks to handle appearance actions and update preferences.
        /*
         reconciler.afterCurrentRender { [weak self] in
         guard let self = self else { return }
         
         }
         */
    }
    
    func update(inReconciler reconciler: TreeReconciler) {
        // TODO: Handle transaction.
        // TODO: Update variadic views.
        
        // tell the reconciler to process self's hosted content
        // In tokamak:
        // - when self's element is "renderer primitive", the element returned by the renderer would be added as a child here.
        // - when self's element is NOT "renderer primitive" and has a body, the 'render' function would call the body and that would be used here.
        reconciler.processBody(of: self,
                               hostedElement: \.hostedElementValue)
        
        // TODO: Why is the reconcile function asking this instance to handle child behaviors in closures?
        // reconcile state changes with child content
        let childHostedContent = anyContent.body
        reconciler.reconcileChildren(for: self,
                                     withChild: childHostedContent,
                                     elementType: { getType($0) },
                                     updateChildHost: {
            // TODO: ...
            //            childHost.environmentValues = environmentValues
            $0.hostedElement = .content(childHostedContent)
            //            childHost.transaction = transaction
        },
                                     mountChildElement: { $0.makeHost(parentPlatformContent: parentPlatformContent,
                                                                      parentHost: self) })
    }
    
    func unmount(in reconciler: TreeReconciler,
                 parentTask: UnmountTask?) {
        // TODO: Need Transaction and Parent Task params.
        
        // TODO: Change this bad behavior: Inference about type of self using implicit knowledge of desecendants.
        if !(self is PrimitiveViewHost) {
            unmountTask = parentTask?.appendChild()
        }
        
        if case let .content(content) = hostedElement,
           content is GroupedContent {
            // TODO: set transition phase.
        }
        else {
            // TODO: Set transition phase.
        }
        
        // TODO: ...
        /*
         if parent?.transitionPhase == .normal {
         viewTraits.insert(
         transaction.animation != nil
         || _AnyTransitionProxy(viewTraits.transition)
         .resolve(in: environmentValues)
         .removalAnimation != nil,
         forKey: CanTransitionTraitKey.self
         )
         }
         */
        
        // TODO: transaction.
        
        // unmount children
        children.forEach { childHost in
            // TODO: view traits.
            //            host.viewTraits = viewTraits
            childHost.unmount(in: reconciler,
                              parentTask: parentTask)
        }
        
        // TODO: Call appearance action.
    }
}

struct _PrimitiveSceneHost {
    let anyScene: any SScene
    
    // TODO: parentPlatformContent can likely be removed from here and primitive content host.
    let parentPlatformContent: PlatformContent
    var platformContent: PlatformContent? {
        didSet {
            performLazyMount()
        }
    }
    var lazyMountHandler: (() -> Void)?
    
    var modifiedContent: Any? = nil
    private var isModifiedContent: Bool { modifiedContent != nil }
    
    var parentUnmountTask = UnmountTask()
    var unmountTask: UnmountTask?
    
    init(scene: any SScene, parentPlatformContent: PlatformContent) {
        self.anyScene = scene
        self.parentPlatformContent = parentPlatformContent
    }
    
    func mount(beforeSibling sibling: PlatformContent?, onParent parent: ElementHost?, reconciler: TreeReconciler) {
        processModifiedContent()
        
        if let modifiedContent {
            // modified content is not rendered
            self.platformContent = parentPlatformContent
            
            guard let platformContent else {
                fatalError("Platform content was not provided for a primitive host: \(self). Scene: \(anyScene)")
            }
            
            // modified content has already been unraveled using its children, so the resulting content is the child.
            children = [modifiedContent].map {
                $0.makeHost(parentPlatformContent: platformContent, parentHost: self)
            }
            children.forEach { childHost in
                childHost.mount(beforeSibling: nil, onParent: self, reconciler: reconciler)
            }
        }
        else {
            lazyMountHandler = { [unowned self] in
                if anyScene is GroupedContent {
                    self.platformContent = parentPlatformContent
                }
                else {
                    self.platformContent = parentPlatformContent
                        .addChild(for: .init(value: anyScene), preceedingSibling: sibling, modifiers: modifiers.elements, context: .init())
                }
                
                guard let platformContent = platformContent else {
                    fatalError("Platform content was not provided for a primitive host: \(self). Scene: \(anyScene)")
                }
                
                guard let container = anyScene as? ContainerScene else { return }
                let isGroup = container is GroupScene
                
                children = container.children.map {
                    $0.makeHost(parentPlatformContent: platformContent, parentHost: self)
                }
                children.forEach { child in
                    child.mount(beforeSibling: isGroup ? sibling : nil, onParent: self, reconciler: reconciler)
                }
            }
        }
        
        // TODO: Set transition phase.
    }
    
    func performLazyMount() {
        guard let lazyMountHandler else {
            assertionFailure()
            return
        }
        lazyMountHandler()
        self.lazyMountHandler = nil
    }
    
    func update(inReconciler reconciler: TreeReconciler) {
        guard let platformContent = platformContent else {
            return
        }
        
        invalidateUnmount()
        updateEnvironment()
        processModifiedContent()
        
        platformContent.update(withPrimitive: .init(value: modifiedContent ?? anyScene), modifiers: modifiers.elements)
        
        var sceneChildren: [any SScene] = {
            if let modifiedContent {
                return [modifiedContent]
            }
            else if let container = anyScene as? ContainerScene {
                return container.children
            }
            else { return [] }
        }()
        
        // perform updates for children
        switch (children.isEmpty, sceneChildren.isEmpty) {
            
            // there are existing children but now no children.
            // unmount all existing children.
        case (false, true):
            children.forEach { host in
                host.unmount(in: reconciler,
                             parentTask: parentUnmountTask)
            }
            children = []
            
            // there was no existing children but there are now children.
            // Create hosts for the children and mount them.
        case (true, false):
            children = sceneChildren.map { childContent in
                childContent.makeHost(parentPlatformContent: platformContent,
                                      parentHost: self)
            }
            children.forEach { childHost in
                childHost.mount(beforeSibling: nil,
                                onParent: self,
                                reconciler: reconciler)
            }
            
            // there are existing and new children.
            // reconcile the differences.
        case (false, false):
            var newChildren = [ElementHost]()
            
            // compare each existing and new child.
            // remount if types differ,
            // otherwise update.
            while let childHost = children.first,
                  let childScene = sceneChildren.first {
                
                let newChild: ElementHost
                
                // same types
                if childHost.hostedElement.typeConstructorName == childScene.typeConstructorName {
                    //                        childHost.environmentValues = environmentValues
                    childHost.hostedElement = .scene(childScene)
                    childHost.updateEnvironment()
                    childHost.update(inReconciler: reconciler)
                    newChild = childHost
                }
                // differing types
                // create a new element host,
                // mount the new child,
                // then unmount the old child.
                else {
                    newChild = childScene
                        .makeHost(parentPlatformContent: platformContent,
                                  parentHost: self)
                    newChild.mount(beforeSibling: childHost.firstPrimitivePlatformContent(),
                                   onParent: self,
                                   reconciler: reconciler)
                    childHost.unmount(in: reconciler,
                                      parentTask: parentUnmountTask)
                }
                
                newChildren.append(newChild)
                children.removeFirst()
                sceneChildren.removeFirst()
            }
            
            if !children.isEmpty {
                // more existing host children than new children, unmount them
                children.forEach { childHost in
                    childHost.unmount(in: reconciler,
                                      parentTask: parentUnmountTask)
                }
            }
            else {
                // mount any remaining new children.
                sceneChildren.forEach { childScene in
                    let newChild: ElementHost = childScene.makeHost(parentPlatformContent: platformContent,
                                                                    parentHost: self)
                    newChild.mount(beforeSibling: nil,
                                   onParent: self,
                                   reconciler: reconciler)
                    newChildren.append(newChild)
                }
            }
            
            children = newChildren
            
        case (true, true):
            // no children to update.
            break
        }
    }
    
    func unmount(in reconciler: TreeReconciler, parentTask: UnmountTask?) {
        super.unmount(in: reconciler, parentTask: parentTask)
        
        guard let platformContent = platformContent else { return }
        
        let task = UnmountHostTask(self,
                                   in: reconciler) {
            self.children.forEach { childHost in
                childHost.unmount(in: reconciler, parentTask: self.unmountTask)
            }
        }
        
        task.isCancelled = parentTask?.isCancelled ?? false
        unmountTask = task
        parentTask?.childTasks.append(task)
        parentPlatformContent.removeChild(platformContent, for: task)
    }
    
    /// Stop any unfinished unmounts and complete them without transitions.
    private
    mutating
    func invalidateUnmount() {
        parentUnmountTask.cancel()
        parentUnmountTask.completeImmediately()
        parentUnmountTask = .init()
    }
    
    /// Checks if the hosted content is modified content, unwraps the modified content chain and stores the modifiers in self, replacing any inherited modifiers.
    private
    mutating
    func processModifiedContent(inheritedModifiers: OrderedSet<Modifier>) {
        if anyContent is AnyModifiedElement {
            guard anyContent is AnyModifiedContent else { fatalError() }
            // TODO: Relocate static resource location.
            let result = ElementHost.reduceModifiedContent(anyContent)
            modifiedContent = result.modifiedContent
            
            modifiers = inheritedModifiers
            modifiers.replaceAndAppend(contentsOf: result.modifiers.map { Modifier.content($0) })
        }
        else {
            modifiedContent = nil
            modifiers = []
        }
    }
}
struct _PrimitiveContentHost {
    let anyContent: any SContent
    
    let parentPlatformContent: PlatformContent
    var platformContent: PlatformContent? {
        didSet {
            performLazyMount()
        }
    }
    var lazyMountHandler: (() -> Void)?
    
    var modifiedContent: Any? = nil
    private var isModifiedContent: Bool { modifiedContent != nil }
    
    var modifiers: OrderedSet<Modifier> = []
    
    var parentUnmountTask = UnmountTask()
    var unmountTask: UnmountTask?
    
    init(content: any SContent, parentPlatformContent: PlatformContent) {
        self.anyContent = content
        self.parentPlatformContent = parentPlatformContent
        
        updateEnvironment()
    }
    
    func updateEnvironment() {
        // TODO: ...
    }
    
    mutating
    func mount(beforeSibling sibling: PlatformContent?,
               inheritedModifiers: OrderedSet<Modifier>,
               reconciler: TreeReconciler) {
        //        self.transaction = transaction
        processModifiedContent(inheritedModifiers: inheritedModifiers)
        
        // TODO: perhaps modified content should have its own host type.
        if let modifiedContent {
            // modified content is not rendered
            self.platformContent = parentPlatformContent
            
            guard let platformContent else {
                fatalError("Platform content was not provided for a primitive host: \(self). Content: \(anyContent)")
            }
            
            // TODO: move this to the tree reconciler.
            // modified content has already been unraveled using its children, so the resulting content is the child.
            children = [modifiedContent].map {
                $0.makeHost(parentPlatformContent: platformContent,
                            parentHost: self)
            }
            children.forEach { child in
                child.mount(beforeSibling: nil, onParent: self, reconciler: reconciler)
            }
        }
        else {
            if anyContent is GroupedContent {
                // don't give GroupedContent types to the platform renderer
                self.platformContent = parentPlatformContent
            }
            else {
                // create platform content for this host using either the parent platform content or the provider
                self.platformContent = parentPlatformContent
                    .addChild(for: .init(value: anyContent), preceedingSibling: sibling, modifiers: modifiers.elements, context: .init())
            }
            
            // abort if no platform content was provided by the platform for this host
            guard let platformContent else {
                fatalError("Platform content was not provided for a primitive host: \(self). Content: \(anyContent)")
            }
            
            // create and mount children if the content provides any
            guard let container = anyContent as? _SContentContainer else { return }
            let isGroup = container is GroupedContent
            
            children = container.children.map {
                $0.makeHost(parentPlatformContent: platformContent,
                            parentHost: self)
            }
            children.forEach { child in
                child.mount(beforeSibling: isGroup ? sibling : nil,
                            onParent: self,
                            reconciler: reconciler)
            }
        }
    }
    
    func performLazyMount() {
        guard let lazyMountHandler else {
            assertionFailure()
            return
        }
        lazyMountHandler()
        self.lazyMountHandler = nil
    }
    
    mutating
    func update(inReconciler reconciler: TreeReconciler, inheritedModifiers: OrderedSet<Modifier>) {
        guard let platformContent = platformContent else { return }
        
        invalidateUnmount()
        updateEnvironment()
        // TODO: move to modified content host.
        processModifiedContent(inheritedModifiers: inheritedModifiers)
        
        platformContent.update(withPrimitive: .init(value: modifiedContent ?? anyContent), modifiers: modifiers.elements)
        
        // TODO: this won't be needed when modified content host is made.
        var contentChildren = {
            if let modifiedContent {
                return [modifiedContent]
            }
            else if let container = anyContent as? _SContentContainer {
                return container.children
            }
            else { return [] }
        }()
        
        // TODO: Move to tree reconciler.
        // perform updates for children
        switch (children.isEmpty, contentChildren.isEmpty) {
            
            // there are existing children but now no children.
            // unmount all existing children.
        case (false, true):
            children.forEach { host in
                host.unmount(in: reconciler,
                             parentTask: parentUnmountTask)
            }
            children = []
            
            // there was no existing children but there are now children.
            // Create hosts for the children and mount them.
        case (true, false):
            children = contentChildren.map { childContent in
                childContent.makeHost(parentPlatformContent: platformContent,
                                      parentHost: self)
            }
            children.forEach { childHost in
                childHost.mount(beforeSibling: nil,
                                onParent: self,
                                reconciler: reconciler)
            }
            
            // there are existing and new children.
            // reconcile the differences.
        case (false, false):
            var newChildren = [ElementHost]()
            
            // compare each existing and new child.
            // remount if types differ,
            // otherwise update.
            while let childHost = children.first,
                  let childContent = contentChildren.first {
                
                let newChild: ElementHost
                
                // same types
                if childHost.hostedElement.typeConstructorName == childContent.typeConstructorName {
                    //                        childHost.environmentValues = environmentValues
                    childHost.hostedElement = .content(childContent)
                    childHost.updateEnvironment()
                    childHost.update(inReconciler: reconciler)
                    newChild = childHost
                }
                // differing types
                // create a new element host,
                // mount the new child,
                // then unmount the old child.
                else {
                    newChild = childContent
                        .makeHost(parentPlatformContent: platformContent,
                                  parentHost: self)
                    newChild.mount(beforeSibling: childHost.firstPrimitivePlatformContent(),
                                   onParent: self,
                                   reconciler: reconciler)
                    childHost.unmount(in: reconciler,
                                      parentTask: parentUnmountTask)
                }
                
                newChildren.append(newChild)
                children.removeFirst()
                contentChildren.removeFirst()
            }
            
            if !children.isEmpty {
                // more existing host children than new children, unmount them
                children.forEach { childHost in
                    childHost.unmount(in: reconciler,
                                      parentTask: parentUnmountTask)
                }
            }
            else {
                // mount any remaining new children.
                contentChildren.forEach { childContent in
                    let newChild: ElementHost = childContent.makeHost(parentPlatformContent: platformContent,
                                                                      parentHost: self)
                    newChild.mount(beforeSibling: nil,
                                   onParent: self,
                                   reconciler: reconciler)
                    newChildren.append(newChild)
                }
            }
            
            children = newChildren
            
        case (true, true):
            // no children to update.
            break
        }
    }
    
    func unmount(in reconciler: TreeReconciler,
                 task: UnmountTask?) {
        // TODO: Need Transaction and Parent Task params.
        
        // TODO: move to reconciler --
        if !(self is PrimitiveViewHost) {
            unmountTask = parentTask?.appendChild()
        }
        
        if anyContent is GroupedContent {
            // TODO: set transition phase.
        }
        else {
            // TODO: Set transition phase.
        }
        
        // TODO: ...
        /*
         if parent?.transitionPhase == .normal {
         viewTraits.insert(
         transaction.animation != nil
         || _AnyTransitionProxy(viewTraits.transition)
         .resolve(in: environmentValues)
         .removalAnimation != nil,
         forKey: CanTransitionTraitKey.self
         )
         }
         */
        
        guard let platformContent = platformContent else { return }
        
        let task = UnmountHostTask(self,
                                   in: reconciler) {
            self.children.forEach { childHost in
                childHost.unmount(in: reconciler,
                                  parentTask: self.unmountTask)
            }
        }
        
        task.isCancelled = parentTask?.isCancelled ?? false
        unmountTask = task

        parentTask?.childTasks.append(task)
        // --
        
        parentPlatformContent.removeChild(platformContent,
                                          for: task)
    }
    
    /// Stop any unfinished unmounts and complete them without transitions.
    private
    mutating
    func invalidateUnmount() {
        parentUnmountTask.cancel()
        parentUnmountTask.completeImmediately()
        parentUnmountTask = .init()
    }
    
    /// Checks if the hosted content is modified content, unwraps the modified content chain and stores the modifiers in self, replacing any inherited modifiers.
    private
    mutating
    func processModifiedContent(inheritedModifiers: OrderedSet<Modifier>) {
        if anyContent is AnyModifiedElement {
            guard anyContent is AnyModifiedContent else { fatalError() }
            // TODO: Relocate static resource location.
            let result = ElementHost.reduceModifiedContent(anyContent)
            modifiedContent = result.modifiedContent
            
            modifiers = inheritedModifiers
            modifiers.replaceAndAppend(contentsOf: result.modifiers.map { Modifier.content($0) })
        }
        else {
            modifiedContent = nil
            modifiers = []
        }
    }
}
struct _ModifiedContentHost {
    // TODO:
}

struct _EmptyElementHost: _Host {
    
    let element: _ElementKind
    
    var hostedElement: Any { element.value }
    var elementBody: Any {
        switch element {
        case .content(let content):
            return content.body
        case .scene(let scene):
            return scene.body
        }
    }
    
    func mount() {}
}

enum _ElementKind {
    case content(any SContent)
    case scene(any SScene)
    
    var value: Any {
        switch self {
        case .content(let content):
            return content
        case .scene(let scene):
            return scene
        }
    }
}

/// Hosts state storage and management for an element.
struct CompositeElementState {
    
    /// Values taken from state property declarations of the composite element.
    var storage = [Any]()
    
    /// Subscriptions to transient, class-constrained property declarations of the composite element.
    ///
    /// - Important: These subscriptions are not owned by the composite element and therefore may be removed during rendering.
    var transientSubscriptions = [AnyCancellable]()
    
    /// Subscriptions to non-transient, class-constrained, state property declarations of the composite element.
    ///
    /// - Note: These subscriptions are persistent and only removed when the composite element containing them is removed.
    var persistentSubsciptions = [AnyCancellable]()
}
// TODO: This may be a more robust solution to state storage.
@dynamicMemberLookup
class Reference<Value>: Hashable {
    fileprivate(set) var value: Value
    
    init(value: Value) {
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    static
    func ==(lhs: Reference, rhs: Reference) -> Bool {
        lhs == rhs
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
}
final
class MutableReference<Value>: Reference<Value> {
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}

/// An object which provides tree behaviors.
final
class TreeNode<T> {
    var parent: TreeNode<T>?
    var value: T
    var children: [TreeNode<T>]
    
    init(parent: TreeNode<T>? = nil, value: T, children: [TreeNode<T>] = []) {
        self.parent = parent
        self.value = value
        self.children = children
    }
}
