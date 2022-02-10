//
//  UIKitButton.swift
//  
//
//  Created by Jesse Spencer on 1/16/22.
//

import Foundation
import UIKit

final
class UIKitButton: UIControl, UIKitTargetRenderableContent {
    
    private(set)
    var tapHandlerContainer: SIdentifiableContainer<() -> Void>? = nil
    
    private(set)
    var tapGesture: TapGestureRecognizer
    
    private(set)
    var title: String = ""
    
    init(buttonPrimitive: UIKitButtonPrimitive) {
        self.tapHandlerContainer = buttonPrimitive.actionHandler
        self.tapGesture = .init(buttonPrimitive.actionHandler.t)
        
        super.init(frame: .zero)

        installTapGesture()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        if let button = primitive as? UIKitButtonPrimitive {
            if button.actionHandler != tapHandlerContainer {
                tapGesture.handler = button.actionHandler.t
            }
        }
    }
    
    private
    func installTapGesture() {
        addGestureRecognizer(tapGesture.tapGestureRecognizer)
    }
    
    func addChild(_ view: UIKitTargetRenderableContent, before siblingView: UIKitTargetRenderableContent?) {
        if let text = view as? UIKitText {
            title = text.text
            UIView.addChild(toView: self, childView: view, before: siblingView)
        }
        // TODO: Need support for UIKitImage.
    }
}
