//
//  UIKitPrimitive.swift
//  
//
//  Created by Jesse Spencer on 10/25/21.
//

// TODO: WIP

import Foundation
import UIKit

// TODO: All supported framework primitives should conform to this.
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
    func addChild(_ view: UIKitTargetRenderableContent)
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent)
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
    func addChild(_ view: UIKitTargetRenderableContent) {
        // TODO:
        fatalError("TODO")
    }
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent) {
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

/// A `UIKit` view attribute which can be applied to the primitive for rendering modifications.
protocol AnyUIKitModifiedContent {
    var attributes: [UIKitViewAttribute] { get }
}

protocol UIKitModifier {
    var renderableAttribute: UIKitViewAttribute { get }
}
protocol UIKitComposableModifier: UIKitModifier {
    associatedtype Content : SContent
    var content: Content { get }
}

struct UIKitViewModifier: SContent, AnyUIKitModifiedContent {
    
    var attributes = [UIKitViewAttribute]()

    var body: Never { fatalError() }
}

struct UIKitComposedViewModifier<C>: SContent, AnyUIKitModifiedContent {
    
    var attributes = [UIKitViewAttribute]()
    let content: C

    var body: Never { fatalError() }
}
extension UIKitComposedViewModifier: _SContentContainer
where C : SContent {
    
    var children: [AnySContent] {
        [.init(content)]
    }
}

/// The rendering modifiers which can be applied to views.
/// These roughly correspond the modifiers provided by the framework.
/// However, in some cases the framework modifiers may be translated into views instead, which means they will not be applied as attributes.
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
