//
//  UIKitRootViewPrimitive.swift
//  
//
//  Created by Jesse Spencer on 1/14/22.
//

import Foundation

struct UIKitRootViewPrimitive: SContent, AnyUIKitPrimitive2 {
    
    var body: some SContent { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetView {
        // TODO:
        fatalError("TODO")
    }
}
