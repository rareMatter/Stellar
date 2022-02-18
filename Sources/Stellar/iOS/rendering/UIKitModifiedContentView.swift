//
//  UIKitViewAttributesConfiguration.swift
//  
//
//  Created by Jesse Spencer on 2/14/22.
//

import Foundation
import UIKit

final
class UIKitModifiedContentView: UIView, UIKitTargetRenderableContent {
    
    var attributes: [UIKitViewAttribute]
    
    init(attributes: [UIKitViewAttribute]) {
        self.attributes = attributes
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        // TODO:
        fatalError("TODO")
    }
    
    func addChild(_ view: UIKitTargetRenderableContent, before siblingView: UIKitTargetRenderableContent?) {
        // TODO:
        fatalError("TODO")
    }
    
    func removeChild(_ view: UIKitTargetRenderableContent) {
        // TODO:
        fatalError("TODO")
    }
    
    func addAttributes(_ attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
    
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
    
    func updateAttributes(_ attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
}
