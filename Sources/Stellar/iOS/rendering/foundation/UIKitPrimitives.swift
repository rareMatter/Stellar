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
where Content : SContent, Modifier : UIKitModifier {
    
    var renderedBody: AnySContent {
        AnySContent(UIKitViewModifier(attributes: [modifier.renderableAttribute]))
    }
}
// TODO: Will Swift correctly see this overload as conformance to UIKitPrimitive?
extension SModifiedContent
where Content : SContent, Modifier : UIKitComposableModifier {
    
    var renderedBody: AnySContent {
        AnySContent(UIKitComposedViewModifier(attributes: [modifier.renderableAttribute],
                                              content: modifier.content))
    }
}

// MARK: modifiers
extension STapHandlerModifier: UIKitModifier {
    var renderableAttribute: UIKitViewAttribute {
        .tapHandler(.init(tapHandler))
    }
}

extension SCornerRadiusModifier: UIKitModifier {
    var renderableAttribute: UIKitViewAttribute {
        .cornerRadius(value: cornerRadius,
                      antialiased: antialiased)
    }
}

extension SDisabledContentModifier: UIKitModifier {
    var renderableAttribute: UIKitViewAttribute {
        .disabled(isDisabled)
    }
}

extension SEditingSelectableContentModifier: UIKitModifier {
    var renderableAttribute: UIKitViewAttribute {
        .editingSelectable(isSelectable)
    }
}

extension SSwipeActionsModifier: UIKitComposableModifier {
    
    var renderableAttribute: UIKitViewAttribute {
        .swipeActions(edge: edge,
                      allowsFullSwipe: allowsFullSwipe)
    }
    
    var content: some SContent { UIKitSwipeActionsPrimitive(actions) }
}

struct UIKitSwipeActionsPrimitive: SContent, AnyUIKitPrimitive {
    
    let content: AnySContent
    
    init<C: SContent>(_ content: C) {
        self.content = .init(content)
    }
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetView {
        UIKitSwipeActionsConfiguration()
    }
}
extension UIKitSwipeActionsPrimitive: GroupedContent {
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
    
    func makeRenderableContent() -> UIKitTargetView {
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
    
    func makeRenderableContent() -> UIKitTargetView {
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
    
    func makeRenderableContent() -> UIKitTargetView {
        UIKitContextMenuContent()
    }
}
extension UIKitContextMenuButtonContentPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}

extension _SContextMenuButtonLabel: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitContextMenuButtonLabelPrimitive(content: AnySContent(content)))
    }
}
struct UIKitContextMenuButtonLabelPrimitive: SContent, AnyUIKitPrimitive {
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetView {
        UIKitContextMenuLabel()
    }
}
extension UIKitContextMenuButtonLabelPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}

// MARK: search bar
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
    
    func makeRenderableContent() -> UIKitTargetView {
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
    
    func makeRenderableContent() -> UIKitTargetView {
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
    
    func makeRenderableContent() -> UIKitTargetView {
        UIKitTextEditor()
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
    
    func makeRenderableContent() -> UIKitTargetView {
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
    
    func makeRenderableContent() -> UIKitTargetView {
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
    
    func makeRenderableContent() -> UIKitTargetView {
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
    
    func makeRenderableContent() -> UIKitTargetView {
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
