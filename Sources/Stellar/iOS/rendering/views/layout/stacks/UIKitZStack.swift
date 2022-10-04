//
//  UIKitZStack.swift
//  
//
//  Created by Jesse Spencer on 11/4/21.
//

import Foundation
import UIKit

final
class UIKitZStack: UIView, UIKitContent {
    
    var alignment: SAlignment
    var spacing: Float?
    
    var modifiers: [UIKitContentModifier] = []
    
    init(alignment: SAlignment, spacing: Float?, modifiers: [UIKitContentModifier]) {
        self.alignment = alignment
        self.spacing = spacing
        
        super.init(frame: .zero)
        
        applyModifiers(modifiers)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContentContext, modifiers: [AnySContentModifier]) {
        guard let zStack = primitiveContent.value as? AnyZStack else { return }
        alignment = zStack.alignment
        spacing = zStack.spacing
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    func addChild(for primitiveContent: PrimitiveContentContext,
                  preceedingSibling sibling: PlatformContent?,
                  modifiers: [AnySContentModifier],
                  context: HostMountingContext) -> PlatformContent? {
        guard let uiKitRenderable = primitiveContent.value as? UIKitRenderable else { fatalError() }
        let content = uiKitRenderable.makeRenderableContent(modifiers: modifiers.uiKitModifiers())
        guard let view = content as? UIView else { fatalError() }
        
        // add subview
        if let sibling = sibling {
            guard let siblingUIView = sibling as? UIView else { fatalError() }
            insertSubview(view, belowSubview: siblingUIView)
        }
        else {
            addSubview(view)
        }
        
        makeConstraints(on: view)
        
        return content
    }
    
    func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        guard let view = child as? UIView else { fatalError() }
        view.removeFromSuperview()
    }
    
    /// A helper which checks alignment and creates appropriate constraints for the view.
    private
    func makeConstraints(on view: UIView) {
        
        lazy var top = view.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1)
        lazy var leading = self.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1)
        lazy var bottom = bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 1)
        lazy var trailing = trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 1)
        lazy var centerX = view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        lazy var centerY = view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
        switch alignment {
        case .trailing:
            NSLayoutConstraint.activate([trailing, centerY])
        case .leading:
            NSLayoutConstraint.activate([leading, centerY])
        case .center:
            NSLayoutConstraint.activate([centerX, centerY])
        case .top:
            NSLayoutConstraint.activate([top, centerX])
        case .bottom:
            NSLayoutConstraint.activate([bottom, centerX])
        case .bottomLeading:
            NSLayoutConstraint.activate([bottom, leading])
        case .bottomTrailing:
            NSLayoutConstraint.activate([bottom, trailing])
        case .topLeading:
            NSLayoutConstraint.activate([top, leading])
        case .topTrailing:
            NSLayoutConstraint.activate([top, trailing])
        default:
            assertionFailure("\(self), \(#function): Unexpected alignment case: \(alignment)")
        }
    }
}
extension UIKitZStack {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        UIView.applyModifiers(modifiers, toView: self)
    }
}

extension SZStack: UIKitRenderable {
    public func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitZStack(alignment: alignment, spacing: spacing, modifiers: modifiers)
    }
}
