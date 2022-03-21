//
//  UIKitPrimitives.swift
//  
//
//  Created by Jesse Spencer on 10/26/21.
//

// TODO: WIP

import UIKit

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
                                                                 content: .init(content)))
            }
        }
        // recognized non-collapsible modifiers
        else if let uiKitComposableModifier = modifier as? UIKitComposableModifier {
            return .init(UIKitComposedModifiedContentPrimitive(content: .init(content),
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
        UIKitButton(buttonPrimitive: self)
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
                                      onSearchEnded: .init(onSearchEnded)))
    }
}
struct UIKitSearchBarPrimitive: SContent, AnyUIKitPrimitive {
    let text: String
    let placeholderText: String
    
    let onSearch: SIdentifiableContainer<(String) -> Void>
    let onSearchEnded: SIdentifiableContainer<() -> Void>
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitSearchBar(primitive: self)
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
        UIKitText(primitive: self)
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


// MARK: containers and layout
extension SHStack: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitHStackPrimitive(alignment: alignment,
                                   spacing: spacing,
                                   content: AnySContent(content)))
    }
}
struct UIKitHStackPrimitive: SContent, AnyUIKitPrimitive {
    let alignment: SVerticalAlignment
    let spacing: Float
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitHStack(primitive: self)
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
    let spacing: Float
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitVStack(primitive: self)
    }
}
extension UIKitVStackPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}

extension SZStack: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitZStackPrimitive(alignment: alignment,
                                   content: AnySContent(content)))
    }
}
struct UIKitZStackPrimitive: SContent, AnyUIKitPrimitive {
    
    let alignment: SAlignment
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitZStack(primitive: self)
    }
}
extension UIKitZStackPrimitive {
    
    init<C: SContent>(alignment: SAlignment = .center,
                      @SContentBuilder content: () -> C) {
        self.alignment = alignment
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
        UIKitColor(primitive: self)
    }
}

// MARK: - background
extension BackgroundModifierContainer: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitZStackPrimitive(alignment: alignment,
                                   content: {
            background
            content
        }))
    }
}

// MARK: - list
extension SListView: UIKitPrimitive {
    var renderedBody: AnySContent {
        let selections: Set<AnyHashable>? = {
            if let selection = self.selection {
                switch selection {
                case let .one(binding):
                    return .init(arrayLiteral: .init(binding.wrappedValue))
                case let .many(binding):
                    return binding.wrappedValue
                }
            }
            else { return nil }
        }()
        return .init(UIKitListPrimitive(selectionValue: selections,
                                 content: .init(body)))
    }
}
struct UIKitListPrimitive: SContent, AnyUIKitPrimitive {
    let selectionValue: Set<AnyHashable>?
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitCollectionView(primitive: self)
    }
}
extension UIKitListPrimitive: _SContentContainer {
    var children: [AnySContent] {
        [content]
    }
}

// MARK: - ForEach
extension SForEach: UIKitPrimitive
where Content : _AnySection {
    var renderedBody: AnySContent {
        // TODO:
        fatalError("TODO")
    }
}
struct UIKitSectionCollectionPrimitive: SContent, AnyUIKitPrimitive {
    let sections: [(id: AnyHashable, section: _AnySection)]
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        // TODO:
        fatalError("TODO")
    }
}
extension UIKitViewCollection: _SContentContainer {
    var children: [AnySContent] {
        // TODO:
        fatalError("TODO")
    }
}

// MARK: SSection
extension SSection: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitSectionPrimitive())
    }
}
struct UIKitSectionPrimitive: SContent, AnyUIKitPrimitive {

    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitSection(primitive: self)
    }
}
