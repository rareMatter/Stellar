//
//  Button.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

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
