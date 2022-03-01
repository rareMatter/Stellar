//
//  UIKitModifiedContentRenderer.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

import Foundation

@available(*, deprecated, message: "This has been replaced by a new rendering system equivalent.")
protocol UIKitModifiedContentRenderer {
    func mountModifier(on target: UIKitRenderableContent)
}

extension SModifiedContent: UIKitModifiedContentRenderer
where Content : SContent, Modifier : UIKitRenderableContentModifier {
    
    @available(*, deprecated, message: "This has been replaced by a new rendering system equivalent.")
    func mountModifier(on target: UIKitRenderableContent) {
        modifier.applyTo(target)
    }
}
