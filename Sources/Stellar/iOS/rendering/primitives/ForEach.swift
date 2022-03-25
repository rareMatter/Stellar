//
//  ForEach.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SForEach: UIKitPrimitive
where Content : _AnySection {
    var renderedBody: AnySContent {
        // TODO:
        fatalError("TODO")
    }
}
struct UIKitSectionCollectionPrimitive: SContent, AnyUIKitPrimitive {
    let sections: [(id: AnyHashable, section: _AnySection)]
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        // TODO:
        fatalError("TODO")
    }
}
extension UIKitViewCollection: _SContentContainer {
    var children: [AnySContent] {
        // TODO:
        fatalError("TODO")
    }
}
