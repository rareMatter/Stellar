//
//  UIKitSection.swift
//  
//
//  Created by Jesse Spencer on 3/8/22.
//

import Foundation

final
class UIKitSection: UIKitTargetRenderableContent, Hashable {
    
    static
    func == (lhs: UIKitSection, rhs: UIKitSection) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    private(set)
    var id: AnyHashable
    
    private
    var headerProvider: () -> AnySContent
    
    private
    var contentProvider: () -> AnySContent
    
    private
    var footerProvider: () -> AnySContent
    
    init(primitive: UIKitSectionPrimitive) {
        // TODO:
        fatalError("TODO")
    }
    
    func update(with primitive: AnyUIKitPrimitive) {}
    
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent?) {
        // TODO: Check for header, footer, and content.
        // TODO: Check content as foreach? probably not.
    }
    func removeChild(_ view: UIKitTargetRenderableContent) {
        
    }
}
