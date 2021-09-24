//
//  UIKitModifiedContentRenderer.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

import Foundation

protocol UIKitModifiedContentRenderer {
    func mountModifier(on target: UIKitRenderableContent)
}

extension SModifiedContent: UIKitModifiedContentRenderer
where Content : SContent, Modifier : UIKitRenderableContentModifier {
    
    func mountModifier(on target: UIKitRenderableContent) {
        modifier.applyTo(target)
    }
}
