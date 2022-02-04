//
//  UIKitButton.swift
//  
//
//  Created by Jesse Spencer on 1/16/22.
//

import Foundation
import UIKit

final
class UIKitButton: UIView, UIKitTargetRenderableContent {
    
    private
    var tapHandlerContainer: SIdentifiableContainer<() -> Void>? = nil
    
    private
    var tapGesture: TapGestureRecognizer
    
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
}
