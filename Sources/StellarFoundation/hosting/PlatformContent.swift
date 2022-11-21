//
//  PlatformContent.swift
//  
//
//  Created by Jesse Spencer on 4/22/22.
//

/// Content which can be displayed by a specific platform.
///
/// A conforming type forms a hierarchy of content which can be used to render on a platform. Generally, these types are created by mapping a primitive `Content` type into a platform-specific conforming type.
public
protocol PlatformContent {
    
    /// TODO
    /// - returns The content which was added to the rendered hierarchy or `nil` if none was added.
    func addChild(for primitiveContent: PrimitiveContext,
                  preceedingSibling sibling: PlatformContent?,
                  modifiers: [Modifier],
                  context: HostMountingContext) -> PlatformContent?
    
    /// Updates rendered state using the primitive content.
    func update(withPrimitive primitiveContent: PrimitiveContext,
                modifiers: [Modifier])
    
    /// Removes the child using the unmount task.
    func removeChild(_ child: PlatformContent,
                     for task: UnmountHostTask)
}

public
enum PrimitiveKind {

    case text(SText)
    
    case color(AnyColor)
    
    case button(AnyButton)
    
    case vStack(AnyVStack)
    case hStack(AnyHStack)
    case zStack(AnyZStack)
    
    case list(AnyList)
    case section(_AnySection)
    case sectionPart(AnySectionPart)

    case menu(AnyContextMenuButton)
    case menuContent(AnyContextMenuButtonContent)
    
    case searchBar(SSearchBar)
    
    case windowGroup(AnySWindowGroup)
    
    init(_ value: Any) {
        if let text = value as? SText {
            self = .text(text)
        }
        else if let anyColor = value as? AnyColor {
            self = .color(anyColor)
        }
        else if let anyButton = value as? AnyButton {
            self = .button(anyButton)
        }
        else if let anyVStack = value as? AnyVStack {
            self = .vStack(anyVStack)
        }
        else if let anyHStack = value as? AnyHStack {
            self = .hStack(anyHStack)
        }
        else if let anyZStack = value as? AnyZStack {
            self = .zStack(anyZStack)
        }
        else if let anyList = value as? AnyList {
            self = .list(anyList)
        }
        else if let anySection = value as? _AnySection {
            self = .section(anySection)
        }
        else if let anyContextMenuButton = value as? AnyContextMenuButton {
            self = .menu(anyContextMenuButton)
        }
        else if let anyContextMenuButtonContent = value as? AnyContextMenuButtonContent {
            self = .menuContent(anyContextMenuButtonContent)
        }
        else if let searchBar = value as? SSearchBar {
            self = .searchBar(searchBar)
        }
        else if let anyWindowGroup = value as? AnySWindowGroup {
            self = .windowGroup(anyWindowGroup)
        }
        else { fatalError() }
    }
}

public
struct PrimitiveContext {
    
    public
    var type: PrimitiveKind { .init(value) }
    
    public
    let value: Any
    
    init(value: Any) {
        self.value = value
    }
}
