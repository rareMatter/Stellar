//
//  UIKitText.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

import Foundation
import UIKit

final
class UIKitText: UILabel, UIKitTargetRenderableContent {
    
    private
    var primitive: UIKitTextPrimitive {
        didSet {
            text = primitive.string
        }
    }
    
    init(primitive: UIKitTextPrimitive) {
        self.primitive = primitive
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        guard let textView = primitive as? UIKitTextPrimitive else { return }
        self.primitive = textView
    }
}
extension UIKitText {

    /// The string being displayed.
    var string: String {
        text ?? ""
    }
}
