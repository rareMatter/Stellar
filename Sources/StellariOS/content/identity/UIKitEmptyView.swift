//
//  UIKitEmptyView.swift
//  
//
//  Created by Jesse Spencer on 9/30/22.
//

import StellarFoundation
import UIKit

final
class UIKitEmptyView: UIView, UIKitContent {
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) {}
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        assertionFailure()
        return nil
    }
    func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        assertionFailure()
    }
}

extension SEmptyContent: UIKitRenderable {
    func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitEmptyView()
    }
}
