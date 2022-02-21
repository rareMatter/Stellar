//
//  UIKitColor.swift
//  
//
//  Created by Jesse Spencer on 1/18/22.
//

import Foundation
import UIKit

final
class UIKitColor: UIView, UIKitTargetRenderableContent {
    
    private(set) var primitive: UIKitColorPrimitive {
        didSet {
            backgroundColor = .makeColor(r: primitive.red,
                                         g: primitive.green,
                                         b: primitive.blue,
                                         opacity: primitive.opacity,
                                         colorSpace: primitive.colorSpace)
        }
    }
    
    init(primitive: UIKitColorPrimitive) {
        self.primitive = primitive
        super.init(frame: .zero)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        guard let colorPrimitive = primitive as? UIKitColorPrimitive else { return }
        self.primitive = colorPrimitive
    }
}
