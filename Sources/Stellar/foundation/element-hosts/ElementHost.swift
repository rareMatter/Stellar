//
//  ElementHost.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

// TODO: Revise host design. Attempt to replace inheritance tree with composition where it makes sense. This would allow removal of the implicit awareness of subclasses by the ancestor classes (there is at least one instance of this). This also avoids unnecessary overriding and dynamic dispatch.
/// The base host for live elements, including the various types of `Descriptive Tree` content.
///
/// Other host types inherit and specialize upon this one, depending on the type of `Descriptive Tree` element.
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
    
    convenience
    init(content: AnySContent,
         parent: ElementHost?) {
        self.init(hostedElement: .content(content),
                  parent: parent)
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

// MARK: AnySContent factory method
extension AnySContent {
    
    /// Creates an element host type depending on the wrapped type.
    ///
    /// - Parameters:
    ///     - parentPlatformContent: The parent platform content or nil if it's the root platform content.
    ///     - parentHost: The parent of the returned host or nil if it's the root host.
    func makeHost(parentPlatformContent: PlatformContent?,
                  parentHost: ElementHost?) -> ElementHost {
        if type == SEmptyContent.self {
            return EmptyElementHost(content: self,
                                    parent: parentHost)
        }
        else if bodyType == Never.self {
            return PrimitiveViewHost(content: self,
                                     parentPlatformContent: parentPlatformContent,
                                     parent: parentHost)
        }
        else {
            return CompositeViewHost(content: self,
                                     parentPlatformContent: parentPlatformContent,
                                     parent: parentHost)
        }
    }
    
    func makeRootHost<C>(platformContentProvider: @escaping (C) -> PlatformContent) -> ElementHost
    where C : SContent {
        // TODO: As of right now, the root content provided to the TreeReconciler could be a composite. Eventually, it will probably be required that it is an App.
        guard bodyType == Never.self else {
            fatalError("Expected a primitive content type for the root of the hierarchy.")
        }
        guard let typedContent = self.content as? C else {
            fatalError("Type of generic parameter C must match the wrapped type of this instance.")
        }
        return PrimitiveViewHost(content: typedContent,
                                 platformContentProvider: platformContentProvider,
                                 parent: nil)
    }
}
