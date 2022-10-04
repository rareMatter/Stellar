//
//  PlatformContent.swift
//  
//
//  Created by Jesse Spencer on 4/22/22.
//

import Foundation

/// Content which can be displayed by a specific platform.
///
/// A conforming type forms a hierarchy of content which can be used to render on a platform. Generally, these types are created by mapping a primitive `Content` type into a platform-specific conforming type.
// FIXME: Temp public.
public
protocol PlatformContent {
    
    /// TODO
    /// - returns The content which was added to the rendered hierarchy or `nil` if none was added.
    func addChild(for primitiveContent: PrimitiveContentContext,
                  preceedingSibling sibling: PlatformContent?,
                  modifiers: [AnySContentModifier],
                  context: HostMountingContext) -> PlatformContent?
    
    /// Updates rendered state using the primitive content.
    func update(withPrimitive primitiveContent: PrimitiveContentContext,
                modifiers: [AnySContentModifier])
    
    /// Removes the child using the unmount task.
    func removeChild(_ child: PlatformContent,
                     for task: UnmountHostTask)
}

public
enum PrimitiveContentType {

    case text(SText)
    
    case color(SColor)
    
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
}

public
struct PrimitiveContentContext {
    
    public
    var type: PrimitiveContentType {
        if let text = value as? SText {
            return .text(text)
        }
        else if let anyButton = value as? AnyButton {
            return .button(anyButton)
        }
        else if let anyVStack = value as? AnyVStack {
            return .vStack(anyVStack)
        }
        else if let anyHStack = value as? AnyHStack {
            return .hStack(anyHStack)
        }
        else if let anyZStack = value as? AnyZStack {
            return .zStack(anyZStack)
        }
        else { fatalError() }
    }
    
    public
    let value: Any
    
    init(value: Any) {
        self.value = value
    }
}
