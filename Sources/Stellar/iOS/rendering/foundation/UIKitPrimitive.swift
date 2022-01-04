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

/// A UIView which can update itself from `AnyUIKitPrimitive`.
protocol UIViewPrimitiveProtocol: UIView {
    
    // State updates
    func update(using primitive: AnyUIKitPrimitive)
    
    // Children
    func addChild(_ view: UIViewPrimitiveProtocol)
    func addChild(_ view: UIViewPrimitiveProtocol,
                  before sibling: UIViewPrimitiveProtocol)
    func removeChild(_ view: UIViewPrimitiveProtocol)
    
    // Attributes
    var attributes: [UIKitViewAttribute] { get }
    func addAttributes(_ attributes: [UIKitViewAttribute])
    func removeAttributes(_ attributes: [UIKitViewAttribute])
    func updateAttributes(_ attributes: [UIKitViewAttribute])
}
// Default implementations. Specialized UIViews should overload these as needed.
extension UIViewPrimitiveProtocol {
    
    func addChild(_ view: UIViewPrimitiveProtocol) {
        addSubview(view)
    }
    func addChild(_ view: UIViewPrimitiveProtocol,
                  before sibling: UIViewPrimitiveProtocol) {
        insertSubview(view,
                      belowSubview: view)
    }
    func removeChild(_ view: UIViewPrimitiveProtocol) {
        view.removeFromSuperview()
    }
    
    func addAttributes(_ attributes: [UIKitViewAttribute]) {
        for attribute in attributes {
            switch attribute {
            case .alignment(let alignment):
                assertionFailure("TODO")
            case .cornerRadius(let value, let antialiased):
                layer.masksToBounds = true
                layer.cornerRadius = value
                layer.allowsEdgeAntialiasing = antialiased
            case .disabled(let bool):
                isUserInteractionEnabled = bool
            case .tapHandler(let sHashableClosure):
                // TODO: Need closure-based gesture recognizers.
                let tapGesture = TapGestureRecognizer(sHashableClosure)
                addGestureRecognizer(tapGesture.tapGestureRecognizer)
            case .editingSelectable(_):
                assertionFailure("Unsupported default attribute implementation. This should be handled by a conforming view.")
            case .identifier(let anyHashable):
                tag = anyHashable.hashValue
            }
        }
    }
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        for attribute in attributes {
            switch attribute {
            case .alignment(_):
                assertionFailure("TODO")
            case .cornerRadius( _, _):
                layer.cornerRadius = 0
                layer.allowsEdgeAntialiasing = false
            case .disabled(_):
                isUserInteractionEnabled = true
            case .tapHandler(let sHashableClosure):
                // TODO: Fix: It is likely this will never resolve equal and tap gestures will be left installed. It might be necessary to reinstall all tap handlers.
                guard let tapGesture = gestureRecognizers?
                    .first(where: { recognizer in
                        if let recognizer = recognizer as? TapGestureRecognizer {
                            return recognizer.handler == sHashableClosure ? true : false
                        }
                        return false
                    }) else { break }
                removeGestureRecognizer(tapGesture)
            case .editingSelectable(_):
                assertionFailure("Unsupported default attribute implementation. This should be handled by a conforming view.")
            case .identifier(_):
                // default value
                tag = 0
            }
        }
    }
    func updateAttributes(_ attributes: [UIKitViewAttribute]) {
        for attribute in attributes {
            switch attribute {
            case .alignment(let alignment):
                assertionFailure("TODO")
            case .cornerRadius(let value, let antialiased):
                layer.masksToBounds = true
                layer.cornerRadius = value
                layer.allowsEdgeAntialiasing = antialiased
            case .disabled(let bool):
                isUserInteractionEnabled = bool
            case .tapHandler(let sHashableClosure):
                for gesture in gestureRecognizers ?? [] {
                    if let tapGesture = gesture as? TapGestureRecognizer,
                       tapGesture.handler == sHashableClosure {
                        tapGesture.handler = sHashableClosure
                    }
                }
            case .editingSelectable(_):
                assertionFailure("Unsupported default attribute implementation. This should be handled by a conforming view.")
            case .identifier(let anyHashable):
                tag = anyHashable.hashValue
            }
        }
    }
}

// TODO: All UIKit primitives should conform to this.
/// A `UIKit` primitive type which can be rendered on the platform.
///
/// Types which conform to this are expected to produce a renderable view.
protocol AnyUIKitPrimitive {
    var viewType: UIKitPrimitiveViewType { get }
    var attributes: [UIKitViewAttribute] { get }
}

/// A `UIKit` view attribute which can be applied to the primitive for rendering modifications.
protocol AnyUIKitModifiedContent {
    var attributes: [UIKitViewAttribute] { get }
}
// TODO: All framework modifiers should conform to this.
protocol UIKitModifier {
    var renderableAttribute: UIKitViewAttribute { get }
}

// TODO: Use these types to transform SContent primitives. These types will be used to replace the SContent primitives in the Descriptive Tree. When implementing conformance to `UIKitPrimitive`, provide these types as the rendered equivalents.

struct UIKitViewPrimitive<Content>: SContent, AnyUIKitPrimitive {
    
    let viewType: UIKitPrimitiveViewType
    let attributes: [UIKitViewAttribute]
    /// Nested content. This may be empty content if this primitive is not a container type.
    private
    let content: Content
    
    var body: Never { fatalError() }
}
// MARK: parent content conformance
extension UIKitViewPrimitive: _SContentContainer
where Content : SContent {
    
    init(viewType: UIKitPrimitiveViewType,
         attributes: [UIKitViewAttribute] = [],
         @SContentBuilder content: () -> Content) {
        self.viewType = viewType
        self.attributes = attributes
        self.content = content()
    }
    
    var children: [AnySContent] {
        [.init(content)]
    }
}
// MARK: empty content
extension UIKitViewPrimitive
where Content == SEmptyContent {
    
    init(viewType: UIKitPrimitiveViewType,
         attributes: [UIKitViewAttribute] = []) {
        self.viewType = viewType
        self.attributes = attributes
        self.content = SEmptyContent()
    }
}

struct UIKitViewModifier: SContent, AnyUIKitModifiedContent {
    
    var attributes = [UIKitViewAttribute]()

    var body: Never { fatalError() }
}

/// The rendering modifiers which can be applied to views.
/// These roughly correspond the modifiers provided by the framework.
/// However, in some cases the framework modifiers may be translated into views instead, which means they will not be applied as attributes.
enum UIKitViewAttribute: Hashable {
    
    // MARK: alignment
    case alignment(SAlignment)
    
    // MARK: appearance
    case cornerRadius(value: CGFloat, antialiased: Bool)
    
    // MARK: user interaction
    case disabled(Bool)
//    case editing(Bool)
    case tapHandler(SHashableClosure)
    case editingSelectable(Bool)
    
    // MARK: identity
    case identifier(AnyHashable)
}

enum UIKitPrimitiveViewType: Hashable {
    
    // MARK: hierarchy
    /// The root of the view tree. Generally, there should be only one. To mark new branches of the tree, use `branch`.
    case root(UIView)
    
    // MARK: text
    case text
    case textField
    case textEditor
    
    // MARK: images
    case image
    
    // MARK: colors
    case color(r: Double,
               g: Double,
               b: Double,
               opacity: Double)
    case dynamicColor(colorResolverContainer: SIdentifiableContainer<SDynamicColor.ColorResolver>)
    
    // MARK: buttons
    case button
    case menu
    case menuContent
    case menuLabel
    
    // MARK: stacks
    case hStack
    case vStack
    case zStack
    
    // MARK: lists
    case list
    case outlineGroup
    case disclosureGroup
    
    // MARK: actions
    case swipeActions(edge: SHorizontalEdge,
                      allowsFullSwipe: Bool)
    
    // MARK: search
    case searchBar
    
    // MARK: identity
    case empty
}
