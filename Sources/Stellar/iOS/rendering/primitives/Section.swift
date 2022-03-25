//
//  Section.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

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
