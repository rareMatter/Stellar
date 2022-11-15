//
//  UIKitRenderable.swift
//  
//
//  Created by Jesse Spencer on 8/5/22.
//

import UIKit

/// A marker protocol used for rendering API primitives into UIKit types.
///
/// This is mostly used in layout containers such as stacks which can accept almost any child content types.
// FIXME: This is temporarily public.
public
protocol UIKitRenderable {
    func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent
}

/// Content which is displayable on UIKit.
// FIXME: Temp public.
public
protocol UIKitContent: AnyObject, PlatformContent {}

// TODO: Move me.
extension UIView {
    
    static
    func applyModifiers(_ modifiers: [UIKitContentModifier], toView view: UIView) {
        modifiers.forEach { modifier in
            switch modifier {
            case let .cornerRadius(radius,
                                   antialiased):
                view.layer.masksToBounds = true
                view.layer.cornerRadius = radius
                view.layer.allowsEdgeAntialiasing = antialiased
            case let .disabled(isDisabled):
                view.isUserInteractionEnabled = !isDisabled
            case let .tapHandler(hashableClosure):
                let tapGesture = TapGestureRecognizer(hashableClosure.handler)
                view.addGestureRecognizer(tapGesture.tapGestureRecognizer)
                //                view.tapGesture = tapGesture
            case let .identifier(id):
                view.tag = id.hashValue
            }
        }
    }
}

enum UIKitRendering {
    
    /// Creates a `UIKitRenderable` from self if possible.
    ///
    /// This function crashes in debug builds and safely fails in non-debug builds.
    static func asUIKitRenderable(_ value: Any) -> UIKitRenderable {
        guard let renderable = value as? UIKitRenderable else {
            print("Type does not conform to `UIKitRenderable`: \(value). It will be substituted with empty content.")
            assertionFailure()
            return SEmptyContent()
        }
        return renderable
    }
    
    /// Creates a `UIKitContent` from self is possible.
    ///
    /// This function crashes in debug builds and safely fails in non-debug builds.
    static func asUIKitContent(_ value: Any, modifiers: [UIKitContentModifier]) -> UIKitContent {
        asUIKitRenderable(value).makeRenderableContent(modifiers: modifiers)
    }
    
    /// Creates a `UIView` from self if possible.
    ///
    /// This function crashes in debug builds and safely fails in non-debug builds.
    static func asUIView(_ value: Any, modifiers: [UIKitContentModifier]) -> UIView {
        guard let view = asUIKitContent(value, modifiers: modifiers) as? UIView else {
            print("Type does not produce a `UIView`: \(value). It will be substituted with empty content.")
            assertionFailure()
            return UIKitEmptyView()
        }
        return view
    }
}

extension UIKitContent {
    func asUIView(modifiers: [UIKitContentModifier]) -> UIView {
        UIKitRendering.asUIView(self, modifiers: modifiers)
    }
}

extension PrimitiveContext {
    
    /// Creates a `UIKitRenderable` from self if possible.
    ///
    /// This function crashes in debug builds and safely fails in non-debug builds.
    func asUIKitRenderable() -> UIKitRenderable {
        UIKitRendering.asUIKitRenderable(value)
    }
    
    /// Creates a `UIKitContent` from self is possible.
    ///
    /// This function crashes in debug builds and safely fails in non-debug builds.
    func asUIKitContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitRendering.asUIKitContent(value, modifiers: modifiers)
    }
    
    /// Creates a `UIView` from self if possible.
    ///
    /// This function crashes in debug builds and safely fails in non-debug builds.
    func asUIView(modifiers: [UIKitContentModifier]) -> UIView {
        UIKitRendering.asUIView(value, modifiers: modifiers)
    }
}

// FIXME: Temp public.
public
enum UIKitContentModifier: Hashable {
    // MARK: appearance
    case cornerRadius(value: CGFloat, antialiased: Bool)
    
    // MARK: user interaction
    case disabled(Bool)
    case tapHandler(SHashableClosure)
    
    // MARK: identity
    case identifier(AnyHashable)
}

extension AnySContentModifier {
    func uiKitModifier() -> UIKitContentModifier? {
        (modifier as? UIKitRenderableModifier)?.makeModifier()
    }
}
extension AnySSceneModifier {
    func uiKitModifier() -> UIKitContentModifier? {
        (modifier as? UIKitRenderableModifier)?.makeModifier()
    }
}
// FIXME: temp public
public
extension Collection
where Element == Modifier {
    func uiKitModifiers() -> [UIKitContentModifier] {
        compactMap { modifier in
            let uiKitModifier: UIKitContentModifier?
            
            switch modifier {
            case .scene(let anySceneModifier):
                uiKitModifier = anySceneModifier.uiKitModifier()
                
            case .content(let anyContentModifier):
                uiKitModifier = anyContentModifier.uiKitModifier()
            }
            guard let uiKitModifier = uiKitModifier else {
                assertionFailure()
                return nil
            }
            return uiKitModifier
        }
    }
}

// FIXME: Temp public.
public
protocol UIKitRenderableModifier {
    func makeModifier() -> UIKitContentModifier
}

extension SDisabledContentModifier: UIKitRenderableModifier {
    func makeModifier() -> UIKitContentModifier {
        .disabled(isDisabled)
    }
}

extension SCornerRadiusModifier: UIKitRenderableModifier {
    func makeModifier() -> UIKitContentModifier {
        .cornerRadius(value: cornerRadius, antialiased: antialiased)
    }
}

extension STapHandlerModifier: UIKitRenderableModifier {
    func makeModifier() -> UIKitContentModifier {
        .tapHandler(.init(tapHandler))
    }
}

extension SIdentifiableContent: UIKitRenderableModifier {
    func makeModifier() -> UIKitContentModifier {
        .identifier(.init(id))
    }
}
