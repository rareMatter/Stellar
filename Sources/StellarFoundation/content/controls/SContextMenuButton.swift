//
//  SContextMenuButton.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

public
struct SContextMenuButton<Label, Content>: SPrimitiveContent
where Label : SContent, Content : SContent {
    let content: Content
    let label: Label
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}

public
extension SContextMenuButton {
    
    /// Creates a menu with a custom label.
    /// - Parameters:
    ///   - content: A group of menu items.
    ///   - label: A view describing the content of the menu.
    init(@SContentBuilder content: () -> Content,
         @SContentBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
    }
    
    init<S>(_ title: S,
            @SContentBuilder content: () -> Content)
    where Label == SText, S : StringProtocol {
        self.content = content()
        self.label = .init(title)
    }
}

extension SContextMenuButton: _SContentContainer {
    public
    var children: [any SContent] { [_SContextMenuButtonContent(content: content), label] }
}

public
protocol AnyContextMenuButton {}
extension SContextMenuButton: AnyContextMenuButton {}

// MARK: - children wrapper types
/// A wrapper used to specify the content of a context menu button primitive.
public
struct _SContextMenuButtonContent<Content>: SPrimitiveContent
where Content : SContent {
    let content: Content
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
extension _SContextMenuButtonContent: _SContentContainer {
    public
    var children: [any SContent] { [content] }
}

public
protocol AnyContextMenuButtonContent {}
extension _SContextMenuButtonContent: AnyContextMenuButtonContent {}
