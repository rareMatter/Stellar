//
//  UIKitSection.swift
//  
//
//  Created by Jesse Spencer on 3/8/22.
//

import StellarFoundation
import UIKit

final
class UIKitSection: UIKitContent {
    
    var id: AnyHashable?
    
    private(set) var header: UIKitSectionPart?
    private(set) var content: UIKitSectionPart
    private(set) var footer: UIKitSectionPart?
    
    let modifiers: [UIKitContentModifier]
    
    init(modifiers: [UIKitContentModifier]) {
        self.modifiers = modifiers
        content = .init(part: .content, modifiers: modifiers)
    }
    
    func update(with primitiveContent: PrimitiveContext, modifiers: [Modifier]) { fatalError() }
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        
        switch primitiveContent.type {
        case .sectionPart(let anyPart):
            switch anyPart.part {
            case .parent:
                let header = anyPart.makeUIKitContent(modifiers: modifiers.uiKitModifiers())
                self.header = header
                return header
                
            case .content:
                let content = anyPart.makeUIKitContent(modifiers: modifiers.uiKitModifiers())
                self.content = content
                return content
                
            case .footer:
                let footer = anyPart.makeUIKitContent(modifiers: modifiers.uiKitModifiers())
                self.footer = footer
                return footer
            }
        default:
            fatalError()
        }
    }
    
    func removeChild(_ child: PlatformContent) {
        guard let content = child as? UIKitContent else { fatalError() }
        // TODO: Likely the collection view (or similar) which owns this will need to be informed here.
        if content === header {
            header = nil
        }
        else if content === footer {
            footer = nil
        }
        else if content === self.content {
            fatalError()
        }
        else { fatalError() }
    }
}
extension UIKitSection: Hashable {
    static
    func == (lhs: UIKitSection, rhs: UIKitSection) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final
class UIKitSectionPart: UIKitContent {
    
    private(set) var view: UIView!
    let part: SectionPartType
    let modifiers: [UIKitContentModifier]
    
    init(part: SectionPartType, modifiers: [UIKitContentModifier]) {
        self.part = part
        self.modifiers = modifiers
    }
    
    func update(with primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        fatalError()
    }
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        guard let renderable = primitiveContent.value as? UIKitRenderable else { fatalError() }
        let content = renderable.makeRenderableContent(modifiers: modifiers.uiKitModifiers())
        guard let view = content as? UIView else { fatalError() }
        self.view = view
        return content
    }
    
    func removeChild(_ child: PlatformContent) {
        fatalError()
    }
}
extension AnySectionPart {
    func makeUIKitContent(modifiers: [UIKitContentModifier]) -> UIKitSectionPart {
        .init(part: part, modifiers: modifiers)
    }
}

extension _AnySection {
    func makeUIKitSection(modifiers: [UIKitContentModifier]) -> UIKitSection {
        UIKitSection(modifiers: modifiers)
    }
}
