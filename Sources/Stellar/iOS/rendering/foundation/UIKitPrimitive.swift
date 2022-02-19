//
//  UIKitPrimitive.swift
//  
//
//  Created by Jesse Spencer on 10/25/21.
//

// TODO: WIP

import Foundation
import UIKit

/// A type which can be rendered by UIKit.
///
/// For any framework primitives which can be rendered by `UIKit`, make them conform to this protocol where they should be converted into a `UIKit` renderable primitive type, represented by `UIKitPrimitiveType` and type-erased for recognition during render using `AnyUIKitPrimitive`.
protocol UIKitPrimitive {
    var renderedBody: AnySContent { get }
}

/// Requirements for a renderable context within UIKit. The context is a distinct renderable container which responds to necessary messages for updates to its renderable tree of elements or attributes for appearance.
///
/// The protocol is class constrained to allow matching of instances during tree changes and updates.
protocol UIKitTargetRenderableContent: AnyObject {
    
    // State updates
    func update(with primitive: AnyUIKitPrimitive)
    
    // Children
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent?)
    func removeChild(_ view: UIKitTargetRenderableContent)
    
    // Attributes
    func addAttributes(_ attributes: [UIKitViewAttribute])
    func removeAttributes(_ attributes: [UIKitViewAttribute])
    func updateAttributes(_ attributes: [UIKitViewAttribute])
}
extension UIKitTargetRenderableContent
where Self : UIView {

    init() {
        self.init(frame: .zero)
    }
    
    // State updates
    func update(with primitive: AnyUIKitPrimitive) {
        // TODO:
        fatalError("TODO")
    }
    
    // Children
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent?) {
        // TODO:
        fatalError("TODO")
    }
    func removeChild(_ view: UIKitTargetRenderableContent) {
        // TODO:
        fatalError("TODO")
    }
    
    // Attributes
    func addAttributes(_ attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
    func updateAttributes(_ attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
}

protocol AnyUIKitPrimitive {
    /// Creates UIKit renderable content.
    func makeRenderableContent() -> UIKitTargetRenderableContent
}

/// This protocol is used to declare and recognize modifier primitives as supported on `UIKit`.
///
/// Check for conformance to this protocol when converting modified content primitive instances into UIKit renderable instances (generally as a generic constraint).
protocol UIKitModifier {
    /// A renderable description of the modifier primitive.
    /// This is a collection because modifiers may be chained and flattened into one instance.
    var renderableAttributes: [UIKitViewAttribute] { get }
}

/// Apply this protocol to `UIKit` supported primitive modifiers which provide their own child content.
protocol UIKitComposableModifier {
    /// The content provided by the modifier.
    ///
    /// Since modifiers of this type cannot be converted into a `UIKitViewAttribute` like standard `UIKitModifiers` can, generally you should convert the modifier into a content type and return an instance of that type from this property. That content type will own the modifier content as child content. This allows you to recognize the modifier's content during rendering when it's provided to your modifier content type as child content.
    var content: AnySContent { get }
}


/// This protocol is used to recognize modified content primitives which meet the requirements in order to flatten modifiers.
protocol AnyUIKitModifiedContent {
    
    var uiKitModifier: UIKitModifier { get }

    /// Content to which the modifier was applied.
    var anyContent: AnySContent { get }
}

/// A content type which is used to 'render' modified content primitive instances.
///
/// Modified content primitives will be converted into this type during the render process.
struct UIKitModifiedContentPrimitive<Content>: SContent, AnyUIKitPrimitive
where Content : SContent {
    
    let attributes: [UIKitViewAttribute]
    let content: Content
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitModifiedContentView(attributes: attributes)
    }
}
// content container conformance
extension UIKitModifiedContentPrimitive: _SContentContainer {
    
    var children: [AnySContent] {
        [.init(content)]
    }
}

// TODO: Document.
struct UIKitComposedModifiedContentPrimitive<Content, ModifierContent>: SContent, AnyUIKitPrimitive
where Content : SContent, ModifierContent : SContent {
    
    let content: Content
    let modifierContent: ModifierContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitModifiedContentView(attributes: [])
    }
}
// content container
extension UIKitComposedModifiedContentPrimitive: _SContentContainer {
    
    var children: [AnySContent] {
        [.init(content),
         .init(modifierContent)]
    }
}

/// The rendering modifiers which can be applied to views.
/// These roughly correspond the modifiers provided by the framework.
/// However, in some cases the framework modifiers may be translated into content instead, which means they will not be applied as attributes.
enum UIKitViewAttribute: Hashable {
    
    // MARK: appearance
    case cornerRadius(value: CGFloat, antialiased: Bool)
    
    // MARK: user interaction
    case disabled(Bool)
    case tapHandler(SHashableClosure)
    case editingSelectable(Bool)
    case swipeActions(edge: SHorizontalEdge,
                      allowsFullSwipe: Bool)
    
    // MARK: identity
    case identifier(AnyHashable)
}
