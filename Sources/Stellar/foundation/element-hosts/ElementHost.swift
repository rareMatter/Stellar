//
//  ElementHost.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation
import OrderedCollections

// TODO: Revise host design. Attempt to replace inheritance tree with composition where it makes sense. This would allow removal of the implicit awareness of subclasses by the ancestor classes (there is at least one instance of this). This also avoids unnecessary overriding and dynamic dispatch.
/// The base host for live elements, including the various types of `Descriptive Tree` content.
///
/// Other host types inherit and specialize upon this one, depending on the type of `Descriptive Tree` element.
// FIXME: Temp public.
public
class ElementHost {
    
    /// The type-erased element being hosted.
    private
    var hostedElement: ElementType
    /// The type of the hosted element.
    var hostedElementType: Any.Type { hostedElement.type }
    
    // -- type-casted element accessors
    // TODO: Need other element types.
    
    var content: AnySContent {
        get {
            if case let .content(content) = hostedElement {
                return content
            }
            else { fatalError("The `hostedElement` of \(self) is not `SContent` as expected: \(hostedElement).") }
        }
        set { hostedElement = .content(newValue) }
    }
    
    /// Convenient access to the type-erased content instance wrapped by `AnySContent` in the `content` property.
    // FIXME: Temp public.
    public
    var wrappedContent: Any {
        get { content.content }
        set { content.content = newValue }
    }
    
    /// The type constructor name, which excludes generic parameters, of the hosted element.
    var typeConstructorName: String {
        switch hostedElement {
            case .content(let anySContent):
                return anySContent.typeConstructorName
        }
    }
    
    // -- host tree
    
    /// The parent of this host, if it has one.
    weak var parent: ElementHost?
    var children = [ElementHost]()
    
    /// Modifiers applied to `modifiedContent`, if this instance is hosting modified content.
    var modifiers: OrderedSet<AnySContentModifier> = []
    
    /// Modifiers inherited from this instances parent `ElementHost`, if any.
    var inheritedModifiers: OrderedSet<AnySContentModifier> {
        parent?.modifiers ?? []
    }
    
    // TODO: Need transaction.
    // TODO: Need environment values.
    // TODO: Need preference store.
    // TODO: Need view trait store.
    
    /// The current unmounting task of self.
    var unmountTask: UnmountTask?
    
    // MARK: init
    
    // TODO: Need init for other element types.
    
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
           content.type is GroupedContent.Type {
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
           !(primitiveHost.content.type is GroupedContent.Type) {
            return primitiveHost.platformContent
        }
        else {
            return children.first?.firstPrimitivePlatformContent()
        }
    }
}

extension ElementHost {
    // TODO: Do returned modifiers need to be reversed?
    static func reduceModifiedContent(_ anyContent: AnySContent) -> (modifiers: OrderedSet<AnySContentModifier>, modifiedContent: AnySContent) {
        var modifiers = OrderedSet<AnySContentModifier>()
        let modifiedContent = Self.reduceModifiedContentRecursively(anyContent: anyContent, collection: &modifiers)
        return (modifiers, modifiedContent)
    }
    
    /// Recursively reduces a modifier chain, stopping when content is encountered which is not a modifier.
    private static func reduceModifiedContentRecursively(anyContent: AnySContent, collection: inout OrderedSet<AnySContentModifier>) -> AnySContent {
        
        // Recursively unravel modifier chain, accumulating primitive modifiers and calling modifier bodies. End recursion when the modified content is encountered.
        guard let modifiedContent = anyContent.content as? AnySModifiedContent else {
            return anyContent
        }
        
        // Check for composed modifier bodies
        if modifiedContent.anySModifier.bodyType != Never.self {
            let content = modifiedContent.anySModifier.body(content: .init(modifier: modifiedContent.anySModifier, content: modifiedContent.anyContent))
            return reduceModifiedContentRecursively(anyContent: content, collection: &collection)
        }
        // Accumulate modified content chains
        else if let someModifiedContent = modifiedContent.anyContent.content as? SomeModifiedContent {
            guard let modifiedContent = someModifiedContent as? AnySModifiedContent else { fatalError() }
            collection.append(modifiedContent.anySModifier)
            return reduceModifiedContentRecursively(anyContent: modifiedContent.anyContent, collection: &collection)
        }
        else {
            // No chaining, primitive modifier.
            collection.append(modifiedContent.anySModifier)
            return modifiedContent.anyContent
        }
    }
}

fileprivate extension ElementHost {
    /// Creates an element host type depending on the type of this content.
    ///
    /// - Parameters:
    ///     - parentPlatformContent: The parent platform content.
    ///     - parentHost: The parent of the returned host or nil if it's the root host.
    static func makeHost(forContent content: AnySContent,
                         parentPlatformContent: PlatformContent,
                         parentHost: ElementHost?) -> ElementHost {
        if content.content is SEmptyContent {
            return EmptyElementHost(hostedElement: .content(content),
                                    parent: parentHost)
        }
        else if content.bodyType is Never.Type {
            return PrimitiveViewHost(content: content,
                                     parentPlatformContent: parentPlatformContent,
                                     parent: parentHost)
        }
        else {
            return CompositeViewHost(content: content,
                                     parentPlatformContent: parentPlatformContent,
                                     parent: parentHost)
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
        ElementHost.makeHost(forContent: .init(self),
                             parentPlatformContent: parentPlatformContent,
                             parentHost: parentHost)
    }
}

extension AnySContent {
    
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

// FIXME: Temp public.
/// A container of contextual data to be used when mounting `PlatformContent`.
public
struct HostMountingContext {
    // TODO: Environment values.
    // TODO: Transaction data.
    // TODO: View traits.
}
