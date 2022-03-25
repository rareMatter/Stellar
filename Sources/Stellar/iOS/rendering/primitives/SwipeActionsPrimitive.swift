//
//  SwipeActionsPrimitive.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

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
