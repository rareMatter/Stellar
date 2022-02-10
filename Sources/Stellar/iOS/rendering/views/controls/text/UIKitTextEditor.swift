//
//  UIKitTextEditor.swift
//  
//
//  Created by Jesse Spencer on 1/18/22.
//

import Foundation
import UIKit

final
class UIKitTextEditor: _TextView, UIKitTargetRenderableContent {
    
    init(primitive: UIKitTextEditorPrimitive) {
        super.init(frame: .zero, textContainer: nil)
        update(with: primitive)
    }

    func update(with primitive: AnyUIKitPrimitive) {
        guard let primitive = primitive as? UIKitTextEditorPrimitive else { return }
        self.text = primitive.text
        self.placeholder = primitive.placeholderText
        self.didChange = { textView in
            primitive.onTextChange.t(textView.text)
        }
        self.inputAccessoryView = primitive.inputAccessoryView
    }
}
