//
//  UIKitPrimitives.swift
//  
//
//  Created by Jesse Spencer on 10/26/21.
//

// TODO: WIP

import UIKit
import SwiftUI

// MARK: modified content
extension SModifiedContent: UIKitPrimitive
where Content : SContent, Modifier : SContentModifier {
    
    var renderedBody: AnySContent {
        // recognized modifiers
        if let uiKitModifier = modifier as? UIKitModifier {
            // flatten modifiers when content is UIKit modified content
            if let modifiedContent = content as? AnyUIKitModifiedContent {
                return .init(UIKitModifiedContentPrimitive(attributes: modifiedContent.uiKitModifier.renderableAttributes + uiKitModifier.renderableAttributes,
                                                           content: modifiedContent.anyContent))
            }
            else {
                return AnySContent(UIKitModifiedContentPrimitive(attributes: uiKitModifier.renderableAttributes,
                                                                 content: content))
            }
        }
        // recognized non-collapsible modifiers
        else if let uiKitComposableModifier = modifier as? UIKitComposableModifier {
            return .init(UIKitComposedModifiedContentPrimitive(content: content,
                                                               modifierContent: uiKitComposableModifier.content))
        }
        // unrecognized primitive modifier
        else if Modifier.Body.self == Never.self {
            // Pass the content on without calling the modifier - it's primitive and unsupported on UIKit.
            return AnySContent(content)
        }
        // non-primitive modifier
        else {
            // call the modifier to continue the rendering chain
            return AnySContent(modifier.body(content: .init(modifier: modifier, content: .init(content))))
        }
    }
}
// chained modifiers
extension SModifiedContent: UIKitModifier
where Content : UIKitModifier, Modifier : UIKitModifier {
    
    var renderableAttributes: [UIKitViewAttribute] {
        // combine attributes to flatten the live tree
        content.renderableAttributes + modifier.renderableAttributes
    }
}
extension SModifiedContent: AnyUIKitModifiedContent
where Content : SContent, Modifier : UIKitModifier {
    
    var uiKitModifier: UIKitModifier {
        modifier
    }
    
    var anyContent: AnySContent {
        .init(content)
    }
}

// MARK: - modifiers

extension STapHandlerModifier: UIKitModifier {
    var renderableAttributes: [UIKitViewAttribute] {
        [.tapHandler(.init(tapHandler))]
    }
}

extension SCornerRadiusModifier: UIKitModifier {
    var renderableAttributes: [UIKitViewAttribute] {
        [.cornerRadius(value: cornerRadius,
                      antialiased: antialiased)]
    }
}

extension SDisabledContentModifier: UIKitModifier {
    var renderableAttributes: [UIKitViewAttribute] {
        [.disabled(isDisabled)]
    }
}

extension SEditingSelectableContentModifier: UIKitModifier {
    var renderableAttributes: [UIKitViewAttribute] {
        [.editingSelectable(isSelectable)]
    }
}

// MARK: - swipe actions
extension SSwipeActionsModifier: UIKitComposableModifier {
    var content: AnySContent { .init(UIKitSwipeActionsPrimitive(content: .init(actions), edge: edge, allowsFullSwipe: allowsFullSwipe)) }
}
struct UIKitSwipeActionsPrimitive: SContent, AnyUIKitPrimitive {
    
    let content: AnySContent
    let edge: SHorizontalEdge
    let allowsFullSwipe: Bool
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitSwipeActionsConfiguration(primitive: self)
    }
}
extension UIKitSwipeActionsPrimitive: _SContentContainer {
    var children: [AnySContent] {
        [content]
    }
}

// MARK: buttons
extension SButton: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitButtonPrimitive(actionHandler: actionHandler,
                                   content: AnySContent(content)))
    }
}
struct UIKitButtonPrimitive: SContent, AnyUIKitPrimitive {
    
    let actionHandler: SIdentifiableContainer<() -> Void>
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitButton()
    }
}
extension UIKitButtonPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}

// MARK: - Context Menu
extension SContextMenuButton: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitContextMenuPrimitive(label: .init(label),
                                        content: .init(content)))
    }
}
struct UIKitContextMenuPrimitive: SContent, AnyUIKitPrimitive {
    
    let label: AnySContent
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitContextMenu()
    }
}
extension UIKitContextMenuPrimitive: _SContentContainer {
    var children: [AnySContent] { [label, content] }
}

extension _SContextMenuButtonContent: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitContextMenuButtonContentPrimitive(content: AnySContent(content)))
    }
}
struct UIKitContextMenuButtonContentPrimitive: SContent, AnyUIKitPrimitive {
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitContextMenuContent()
    }
}
extension UIKitContextMenuButtonContentPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}

// MARK: - search bar
extension SSearchBar: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitSearchBarPrimitive(text: text,
                                      placeholderText: placeholderText,
                                      onSearch: .init(onSearch),
                                      onSearchEnded: .init(onSearchEnded),
                                      style: style))
    }
}
struct UIKitSearchBarPrimitive: SContent, AnyUIKitPrimitive {
    let text: String
    let placeholderText: String
    
    let onSearch: SIdentifiableContainer<(String) -> Void>
    let onSearchEnded: SIdentifiableContainer<() -> Void>
    
    let style: UISearchBar.Style
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        // TODO:
        fatalError("TODO")
    }
}

// MARK: text
extension SText: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitTextPrimitive(string: string))
    }
}
struct UIKitTextPrimitive: SContent, AnyUIKitPrimitive {
    
    let string: String
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitText()
    }
}

// MARK: text editor
extension STextEditor: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitTextEditorPrimitive(text: text,
                                       placeholderText: placeholderText,
                                       onTextChange: .init(onTextChange),
                                       inputAccessoryView: inputAccessoryView))
    }
}
struct UIKitTextEditorPrimitive: SContent, AnyUIKitPrimitive {
    
    let text: String
    let placeholderText: String
    
    let onTextChange: SIdentifiableContainer<(String) -> Void>
    let inputAccessoryView: UIView?
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitTextEditor(primitive: self)
    }
}


// MARK: containers
extension SHStack: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitHStackPrimitive(alignment: alignment,
                                   spacing: spacing,
                                   content: AnySContent(content)))
    }
}
struct UIKitHStackPrimitive: SContent, AnyUIKitPrimitive {
    let alignment: SVerticalAlignment
    let spacing: CGFloat
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitHStack()
    }
}
extension UIKitHStackPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}

extension SVStack: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitVStackPrimitive(alignment: alignment,
                                   spacing: spacing,
                                   content: AnySContent(content)))
    }
}
struct UIKitVStackPrimitive: SContent, AnyUIKitPrimitive {
    
    let alignment: SHorizontalAlignment
    let spacing: CFloat
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitVStack()
    }
}
extension UIKitVStackPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}

extension SZStack: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitZStackPrimitive(alignment: alignment,
                                   spacing: spacing,
                                   content: AnySContent(content)))
    }
}
struct UIKitZStackPrimitive: SContent, AnyUIKitPrimitive {
    
    let alignment: SAlignment
    let spacing: Float?
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitZStack()
    }
}
extension UIKitZStackPrimitive {
    
    init<C: SContent>(alignment: SAlignment = .center,
                      spacing: Float? = nil,
                      @SContentBuilder content: () -> C) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = AnySContent(content())
    }
}
extension UIKitZStackPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}

// MARK: - colors
extension SColor: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitColorPrimitive(red: red,
                                  green: green,
                                  blue: blue,
                                  opacity: opacity,
                                  colorSpace: colorSpace))
    }
}
struct UIKitColorPrimitive: SContent, AnyUIKitPrimitive {
    
    let red: Double
    let green: Double
    let blue: Double
    
    let opacity: Double
    
    let colorSpace: SColorSpace
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitColor()
    }
}

extension SDynamicColor: UIKitPrimitive {
    var renderedBody: AnySContent {
        fatalError()
    }
}

// MARK: - background
extension BackgroundModifierContainer: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitZStackPrimitive(alignment: alignment,
                                   spacing: nil,
                                   content: {
            background
            content
        }))
    }
}
