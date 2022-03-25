//
//  TextEditor.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation
import UIKit

extension STextEditor: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitTextEditorPrimitive(text: text,
                                       placeholderText: placeholderText,
                                       onTextChange: .init(onTextChange),
                                       inputAccessoryView: inputAccessoryView))
    }
}
struct UIKitTextEditorPrimitive: SContent, AnyUIKitPrimitive {
    
    let text: String
    let placeholderText: String
    
    let onTextChange: SIdentifiableContainer<(String) -> Void>
    let inputAccessoryView: UIView?
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitTextEditor(primitive: self)
    }
}
