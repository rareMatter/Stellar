//
//  ElementHost.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import OrderedCollections
import utilities

// TODO: Revise host design. Attempt to replace inheritance tree with composition where it makes sense. This would allow removal of the implicit awareness of subclasses by the ancestor classes (there is at least one instance of this). This also avoids unnecessary overriding and dynamic dispatch.
/// The base host for live elements, including the various types of `Descriptive Tree` content.
///
/// Other host types inherit and specialize upon this one, depending on the type of `Descriptive Tree` element.
class ElementHost {
    
    /// The type-erased element being hosted.
    var hostedElement: ElementType
    
    var hostedElementValue: Any {
        get {
            switch hostedElement {
            case .app(let sApp):
                return sApp
            case .scene(let sScene):
                return sScene
            case .content(let sContent):
                return sContent
            }
        }
        set {
            switch hostedElement {
            case .app:
                hostedElement = .app(newValue as! any SApp)
            case .scene:
                hostedElement = .scene(newValue as! any SScene)
            case .content:
                hostedElement = .content(newValue as! any SContent)
            }
        }
    }
    
    /// The type of the hosted element.
    var hostedElementType: Any.Type { hostedElement.type }
    
    var anyApp: any SApp {
        get {
            guard case let .app(app) = hostedElement else { fatalError() }
            return app
        }
        set { hostedElement = .app(newValue) }
    }
    
    var anyScene: any SScene {
        get {
            guard case let .scene(scene) = hostedElement else {
                fatalError()
            }
            return scene
        }
        set { hostedElement = .scene(newValue) }
    }
    
    var anyContent: any SContent {
        get {
            if case let .content(content) = hostedElement {
                return content
            }
            else { fatalError("The `hostedElement` of \(self) is not `SContent` as expected: \(hostedElement).") }
        }
        set { hostedElement = .content(newValue) }
    }
    
    // -- host tree
    
    /// The parent of this host, if it has one.
    weak var parent: ElementHost?
    var children = [ElementHost]()
    
    /// Modifiers applied to `modifiedContent`, if this instance is hosting modified content.
    var modifiers: OrderedSet<Modifier> = []
    
    /// Modifiers inherited from this instances parent `ElementHost`, if any.
    var inheritedModifiers: OrderedSet<Modifier> {
        parent?.modifiers ?? []
    }
    
    // TODO: Need transaction.
    // TODO: Need environment values.
    // TODO: Need preference store.
    // TODO: Need view trait store.
    
    /// The current unmounting task of self.
    var unmountTask: UnmountTask?
    
    // MARK: init
    init(hostedElement: ElementType,
         parent: ElementHost?) {
        self.hostedElement = hostedElement
        self.parent = parent
        
        updateEnvironment()
    }
    
    /// Injects the environment values into the hosted element.
    func updateEnvironment() {
        // TODO: ...
    }
    
    // TODO: Need transaction param.
    /// Prepare for transitions using a transaction.
    func prepareForMount() {
        // TODO: Implement.
    }
    
    // TODO: Need transaction param.
    /// Performs needed work to make the hosted element live.
    ///
    /// - Important: You *must* call super at the *end* of your subclass implementation.
    func mount(beforeSibling sibling: PlatformContent?,
               onParent parent: ElementHost?,
               reconciler: TreeReconciler) {
        // TODO: Set transition phase.
    }
    
    /// Performs needed work to remove the hosted element from the living tree.
    ///
    /// - Important: You *must* call super *before* all other work.
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
    }
    
    // TODO: Need transaction param.
    /// Updates the hosted element with the reconciler and transaction.
    func update(inReconciler reconciler: TreeReconciler) {
        fatalError("\(#function) must be overridden by a subclass.")
    }
}
extension ElementHost {
    
    /// Recursively finds the platform content of a `PrimitiveViewHost`, looking through the hierarchy of first children if needed. If one cannot be found, nil is returned.
    ///
    /// If self is a `PrimitiveViewHost`, the platform content is simply returned. If not, the host hierarchy is recursively checked at each first child until a `PrimitiveViewHost` is found, or nil if a first child does not exist.
    ///
    /// - Note: If a host's content type is `GroupedContent`, it is skipped.
    func firstPrimitivePlatformContent() -> PlatformContent? {
        if let primitiveHost = self as? PrimitiveViewHost,
           !(primitiveHost.anyContent is GroupedContent) {
            return primitiveHost.platformContent
        }
        else {
            return children.first?.firstPrimitivePlatformContent()
        }
    }
}

// MARK: Reducing modified content
extension ElementHost {
    // TODO: Do returned modifiers need to be reversed?
    static func reduceModifiedContent(_ anyContent: any SContent) -> (modifiers: OrderedSet<HashableProxy<any SContentModifier, String>>, modifiedContent: any SContent) {
        var modifiers = OrderedSet<HashableProxy<any SContentModifier, String>>()
        let modifiedContent = Self.reduceModifiedContentRecursively(anyContent: anyContent, collection: &modifiers)
        return (modifiers, modifiedContent)
    }
    
    /// Recursively reduces a modifier chain, stopping when content is encountered which is not a modifier.
    private static func reduceModifiedContentRecursively(anyContent: any SContent, collection: inout OrderedSet<HashableProxy<any SContentModifier, String>>) -> any SContent {
        
        // Recursively unravel modifier chain, accumulating primitive modifiers and calling modifier bodies. End recursion when the modified content is encountered.
        guard let modifiedContent = anyContent as? AnyModifiedContent else {
            return anyContent
        }
        
        // Check for composed modifier bodies
        if !modifiedContent.anySModifier.isPrimitive {
            let content = bodyOfContentModifier(modifiedContent.anySModifier, content: modifiedContent.anyContent)
            return reduceModifiedContentRecursively(anyContent: content, collection: &collection)
        }
        // Accumulate modified content chains
        else if let someModifiedContent = modifiedContent.anyContent as? AnyModifiedElement {
            guard let modifiedContent = someModifiedContent as? AnyModifiedContent else { fatalError() }
            collection.append(.init(value: modifiedContent.anySModifier, hashableValue: typeConstructorName(getType(modifiedContent.anySModifier))))
            return reduceModifiedContentRecursively(anyContent: modifiedContent.anyContent, collection: &collection)
        }
        else {
            // No chaining, primitive modifier.
            collection.append(.init(value: modifiedContent.anySModifier, hashableValue: typeConstructorName(getType(modifiedContent.anySModifier))))
            return modifiedContent.anyContent
        }
    }
    
    private static func bodyOfContentModifier<M>(_ modifier: M, content: any SContent) -> some SContent
    where M: SContentModifier {
        modifier.body(content: .init(modifier: modifier, content: content))
    }
}

// MARK: Reducing modified scenes
extension ElementHost {
    static func reduceModifiedScene(_ anyScene: any SScene) -> (modifiers: OrderedSet<HashableProxy<any SSceneModifier, String>>, modifiedScene: any SScene) {
        var modifiers = OrderedSet<HashableProxy<any SSceneModifier, String>>()
        let modifiedScene = Self.reduceModifiedSceneRecursively(anyScene: anyScene, collection: &modifiers)
        return (modifiers, modifiedScene)
    }
    
    private static func reduceModifiedSceneRecursively(anyScene: any SScene, collection: inout OrderedSet<HashableProxy<any SSceneModifier, String>>) -> any SScene {
        // Recursively unravel modifier chain, accumulating primitive modifiers and calling modifier bodies. End recursion when the modified content is encountered.
        guard let modifiedScene = anyScene as? AnySModifiedScene else {
            return anyScene
        }
        
        // Check for composed modifier bodies
        if !modifiedScene.anySModifier.isPrimitive {
            let scene = modifiedScene.anySModifier.body(content: modifiedScene.anyScene)
            return reduceModifiedSceneRecursively(anyScene: scene, collection: &collection)
        }
        // Accumulate modified content chains
        else if let someModifiedElement = modifiedScene as? AnyModifiedElement {
            guard let modifiedScene = someModifiedElement as? AnySModifiedScene else { fatalError() }
            collection.append(.init(value: modifiedScene.anySModifier, hashableValue: typeConstructorName(getType(modifiedScene.anySModifier))))
            return reduceModifiedSceneRecursively(anyScene: modifiedScene.anyScene, collection: &collection)
        }
        else {
            // No chaining, primitive modifier.
            collection.append(.init(value: modifiedScene.anySModifier, hashableValue: typeConstructorName(getType(modifiedScene.anySModifier))))
            return modifiedScene.anyScene
        }
    }
    
    private static func bodyOfSceneModifier<M>(_ modifier: M, content: any SScene) -> some SScene
    where M: SSceneModifier {
        modifier.body(content: content)
    }
}

fileprivate extension ElementHost {
    /// Creates an element host type depending on the type of this content.
    ///
    /// - Parameters:
    ///     - parentPlatformContent: The parent platform content.
    ///     - parentHost: The parent of the returned host or nil if it's the root host.
    static func makeHost<C>(forContent content: C,
                         parentPlatformContent: PlatformContent,
                         parentHost: ElementHost?) -> ElementHost
    where C: SContent {
        if content is SEmptyContent {
            return EmptyElementHost(hostedElement: .content(content),
                                    parent: parentHost)
        }
        else if C.Body.self is Never.Type {
            return PrimitiveViewHost(content: content,
                                     parentPlatformContent: parentPlatformContent,
                                     parent: parentHost)
        }
        else {
            return CompositeViewHost(element: .content(content),
                                     parentPlatformContent: parentPlatformContent,
                                     parent: parentHost)
        }
    }
}

fileprivate extension ElementHost {
    
    static func makeHost<S>(forScene scene: S,
                         parentPlatformContent: PlatformContent,
                         parentHost: ElementHost?) -> ElementHost
    where S: SScene {
        // TODO: Add EmptyScene.
        if S.Body.self is Never.Type {
            return PrimitiveSceneHost(scene: scene, parentPlatformContent: parentPlatformContent, parent: parentHost)
        }
        else {
            return CompositeSceneHost(element: .scene(scene), parentPlatformContent: parentPlatformContent, parent: parentHost)
        }
    }
}

// MARK: host factory functions
extension SContent {
    
    /// Creates an element host type depending on the type of this content.
    ///
    /// - Parameters:
    ///     - parentPlatformContent: The parent platform content.
    ///     - parentHost: The parent of the returned host or nil if it's the root host.
    func makeHost(parentPlatformContent: PlatformContent,
                  parentHost: ElementHost?) -> ElementHost {
        ElementHost.makeHost(forContent: self,
                             parentPlatformContent: parentPlatformContent,
                             parentHost: parentHost)
    }
}

extension SScene {
    
    func makeHost(parentPlatformContent: PlatformContent,
                  parentHost: ElementHost?) -> ElementHost {
        ElementHost.makeHost(forScene: self, parentPlatformContent: parentPlatformContent, parentHost: parentHost)
    }
}

/// A container of contextual data to be used when mounting `PlatformContent`.
public
struct HostMountingContext {
    // TODO: Environment values.
    // TODO: Transaction data.
    // TODO: View traits.
}

public
enum Modifier: Hashable, Equatable {
    case content(HashableProxy<any SContentModifier, String>)
    case scene(HashableProxy<any SSceneModifier, String>)
}
