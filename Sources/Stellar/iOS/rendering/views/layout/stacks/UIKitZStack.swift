//
//  UIKitZStack.swift
//  
//
//  Created by Jesse Spencer on 11/4/21.
//

import Foundation
import UIKit

final
class UIKitZStack: UIView, UIKitTargetRenderableContent {
    
    private
    var primitive: UIKitZStackPrimitive {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    init(primitive: UIKitZStackPrimitive) {
        self.primitive = primitive
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        guard let zStack = primitive as? UIKitZStackPrimitive else { return }
        self.primitive = zStack
    }
    
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent?) {
        guard let uiView = view as? UIView else { return }

        // add subview
        if let siblingView = siblingView,
        let siblingUIView = siblingView as? UIView {
            insertSubview(uiView, belowSubview: siblingUIView)
        }
        else {
            addSubview(uiView)
        }
        
        makeConstraints(on: uiView)
    }
    func removeChild(_ view: UIKitTargetRenderableContent) {
        guard let uiView = view as? UIView else { return }
        uiView.removeFromSuperview()
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
        
        switch primitive.alignment {
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
            assertionFailure("\(self), \(#function): Unexpected alignment case: \(primitive.alignment)")
        }
    }
}
