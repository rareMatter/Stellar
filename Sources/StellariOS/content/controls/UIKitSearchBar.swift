//
//  UISearchBar.swift
//  
//
//  Created by Jesse Spencer on 2/24/22.
//

import Foundation
import UIKit

final
class UIKitSearchBar: _UIKitSearchTextField, UIKitContent {
    
    init(primitive: SSearchBar, modifiers: [UIKitContentModifier]) {
        super.init(frame: .zero)
        updateState(with: primitive)
        applyModifiers(modifiers)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard case .searchBar(let primitive) = primitiveContent.type else { fatalError() }
        updateState(with: primitive)
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    private
    func updateState(with primitive: SSearchBar) {
        self.text = primitive.text
        self.placeholder = primitive.placeholderText
        self.textDidChange = primitive.onSearch
        self.onReturn = { _ in
            primitive.onSearchEnded()
        }
    }
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        fatalError()
    }
    
    func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        fatalError()
    }
}
extension UIKitSearchBar {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        UIView.applyModifiers(modifiers, toView: self)
    }
}

extension SSearchBar: UIKitRenderable {
    public func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitSearchBar(primitive: self, modifiers: modifiers)
    }
}
