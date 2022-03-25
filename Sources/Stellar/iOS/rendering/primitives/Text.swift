//
//  Text.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

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
