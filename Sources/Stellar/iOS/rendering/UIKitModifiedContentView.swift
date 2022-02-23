//
//  UIKitViewAttributesConfiguration.swift
//  
//
//  Created by Jesse Spencer on 2/14/22.
//

import Foundation
import UIKit

/// A view which applies attributes to its contents.
final
class UIKitModifiedContentView: UIView, UIKitTargetRenderableContent {
    
    private(set)
    var attributes: [UIKitViewAttribute] {
        willSet {
            let diff = attributes.difference(from: newValue)
            // process removals
            removeAttributes(diff.removals.compactMap {
                if case let .remove(_, element, _) = $0 {
                    return element
                }
                else { return nil }
            })
            applyAttributes(newValue)
        }
    }
    
    private(set)
    var swipeActionsConfiguration: UIKitSwipeActionsConfiguration?
    
    private(set)
    var id: AnyHashable?
    
    private(set)
    var tapGesture: TapGestureRecognizer?
    
    init(attributes: [UIKitViewAttribute]) {
        self.attributes = attributes
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        guard let modifiedContent = primitive as? UIKitModifiedContentPrimitive else { return }
        self.attributes = modifiedContent.attributes
    }
    
    func addChild(_ view: UIKitTargetRenderableContent, before siblingView: UIKitTargetRenderableContent?) {
        if let swipeActions = view as? UIKitSwipeActionsConfiguration {
            self.swipeActionsConfiguration = swipeActions
        }
        else {
            UIView.addChild(toView: self,
                            childView: view,
                            before: siblingView)
        }
    }
    func removeChild(_ view: UIKitTargetRenderableContent) {
        if let _ = view as? UIKitSwipeActionsConfiguration {
            self.swipeActionsConfiguration = nil
        }
        else {
            UIView.removeChild(fromView: self,
                               childView: view)
        }
    }
}
// helpers
private
extension UIKitModifiedContentView {
    
    /// Applies the attributes.
    ///
    /// This will update existing attributes or apply new attributes.
    func applyAttributes(_ attributes: [UIKitViewAttribute]) {
        attributes.forEach { attribute in
            switch attribute {
            case let .cornerRadius(radius,
                                   antialiased):
                layer.masksToBounds = true
                layer.cornerRadius = radius
                layer.allowsEdgeAntialiasing = antialiased
            case let .disabled(isDisabled):
                isUserInteractionEnabled = !isDisabled
            case let .tapHandler(hashableClosure):
                let tapGesture = TapGestureRecognizer(hashableClosure.handler)
                addGestureRecognizer(tapGesture.tapGestureRecognizer)
                self.tapGesture = tapGesture
            case let .identifier(id):
                self.id = id
            }
        }
    }
    /// Removes the attributes.
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        attributes.forEach { attribute in
            switch attribute {
            case .cornerRadius:
                layer.cornerRadius = 0
                layer.allowsEdgeAntialiasing = false
            case .disabled:
                isUserInteractionEnabled = true
            case .tapHandler:
                if let tapGesture = self.tapGesture {
                    removeGestureRecognizer(tapGesture.tapGestureRecognizer)
                }
                self.tapGesture = nil
            case .identifier:
                self.id = nil
            }
        }
    }
}
