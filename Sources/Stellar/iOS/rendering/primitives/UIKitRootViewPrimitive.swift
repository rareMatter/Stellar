//
//  UIKitRootViewPrimitive.swift
//  
//
//  Created by Jesse Spencer on 1/14/22.
//

import Foundation

struct UIKitRootViewPrimitive: SContent, AnyUIKitPrimitive {
    
    var body: some SContent { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        // TODO:
        fatalError("TODO")
    }
}
