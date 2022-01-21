//
//  UIKitPrimitives.swift
//  
//
//  Created by Jesse Spencer on 10/26/21.
//

// TODO: WIP

import UIKit
import SwiftUI

// TODO: Create a type-erased UIKit modifier layer, or simply use one modifier content type?
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

// TODO: FIX - The child content here should end up added to the modifier's parent content but will lose context as to where it came from. This means when its added to the parent content, it may simply be added immediately as a child rather than being treated as a special case, such as is needed here for swipe actions. This could likely be fixed by taking the approach the primitive List does: by decomposing the content manually and augmenting/recognizing it before allowing the framework to take over. Otherwise, a wrapper type may be needed to maintain context during addition to the parent, where likely an intermediate target/view would be created to maintain normal tree operations. This view would never be visible but would be used only as a configuration by the parent. This scenario was being avoided when trying to render the modifier as primitive, where it was necessary to convert the modifier to SContent in order to pass the child content down; now it is necessary in order to recognize the child content once it is passed down.
extension SSwipeActionsModifier: UIKitComposableModifier {
    var renderableAttribute: UIKitViewAttribute {
        .swipeActions(edge: edge,
                      allowsFullSwipe: allowsFullSwipe)
    }
    var content: some SContent { actions }
}

// MARK: buttons
extension SButton: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitButtonPrimitive(actionHandler: actionHandler,
                                   content: AnySContent(content)))
    }
}
struct UIKitButtonPrimitive: SContent, AnyUIKitPrimitive2 {
    
    let actionHandler: SIdentifiableContainer<() -> Void>
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitContextMenuPrimitive: SContent, AnyUIKitPrimitive2 {
    
    let label: AnySContent
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitContextMenuButtonContentPrimitive: SContent, AnyUIKitPrimitive2 {
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitContextMenuButtonLabelPrimitive: SContent, AnyUIKitPrimitive2 {
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitSearchBarPrimitive: SContent, AnyUIKitPrimitive2 {
    let text: String
    let placeholderText: String
    
    let onSearch: SIdentifiableContainer<(String) -> Void>
    let onSearchEnded: SIdentifiableContainer<() -> Void>
    
    let style: UISearchBar.Style
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitTextPrimitive: SContent, AnyUIKitPrimitive2 {
    
    let string: String
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitTextEditorPrimitive: SContent, AnyUIKitPrimitive2 {
    
    let text: String
    let placeholderText: String
    
    let onTextChange: SIdentifiableContainer<(String) -> Void>
    let inputAccessoryView: UIView?
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitHStackPrimitive: SContent, AnyUIKitPrimitive2 {
    let alignment: SVerticalAlignment
    let spacing: CGFloat
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitVStackPrimitive: SContent, AnyUIKitPrimitive2 {
    
    let alignment: SHorizontalAlignment
    let spacing: CFloat
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitZStackPrimitive: SContent, AnyUIKitPrimitive2 {
    
    let alignment: SAlignment
    let spacing: Float?
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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
struct UIKitColorPrimitive: SContent, AnyUIKitPrimitive2 {
    
    let red: Double
    let green: Double
    let blue: Double
    
    let opacity: Double
    
    let colorSpace: SColorSpace
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
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

// MARK: - swipe actions
// TODO: This modifier is now being treated as primitive and passing its content down through an SContent type. Remove this.
/*
extension SSwipeActionsModifierContainer: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitSwipeActionsPrimitive(edge: edge,
                                         allowsFullSwipe: allowsFullSwipe,
                                         actions: AnySContent(actions)))
    }
}
struct UIKitSwipeActionsPrimitive: SContent, AnyUIKitPrimitive2 {
    
    let edge: SHorizontalEdge
    let allowsFullSwipe: Bool
    let actions: AnySContent
    
    var body: Never { fatalError() }
    
    func makeUIView() -> UIKitTargetView {
        UIKitSwipeActionsView()
    }
}
extension UIKitSwipeActionsPrimitive: _SContentContainer {
    var children: [AnySContent] { [actions] }
}
 */

// MARK: empty content
/* TODO: Needed?
extension SEmptyContent: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(<#T##content: SContent##SContent#>)
    }
}
*/
