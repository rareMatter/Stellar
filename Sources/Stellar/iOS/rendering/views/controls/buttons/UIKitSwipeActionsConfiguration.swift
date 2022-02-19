//
//  UIKitSwipeActionsConfiguration.swift
//  
//
//  Created by Jesse Spencer on 1/20/22.
//

import Foundation
import UIKit

final
class UIKitSwipeActionsConfiguration: UIKitTargetRenderableContent {
    
    /// Computed from current state.
    var uiConfiguration: UISwipeActionsConfiguration {
        let actions = buttons.map { button in
            UIContextualAction(style: .normal,
                               title: button.title,
                               handler: { action, originView, completion in
                button.tapHandlerContainer?.t()
                completion(true)
            })
        }
        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = allowsFullSwipe
        return config
    }
    /// The edge to install the swipe actions.
    private(set) var edge: SHorizontalEdge
    
    /// Apply this property to the swipe actions configuration before providing it to clients.
    private var allowsFullSwipe: Bool
    /// Buttons added as children. Use these to create the swipe actions.
    private var buttons: [UIKitButton] = []
    
    init(primitive: UIKitSwipeActionsPrimitive) {
        self.edge = primitive.edge
        self.allowsFullSwipe = primitive.allowsFullSwipe
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        guard let primitive = primitive as? UIKitSwipeActionsPrimitive else { return }
        edge = primitive.edge
        allowsFullSwipe = primitive.allowsFullSwipe
    }
    
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent?) {
        if let button = view as? UIKitButton {
            buttons.append(button)
        }
    }
    func removeChild(_ view: UIKitTargetRenderableContent) {
        if let button = view as? UIKitButton {
            buttons.removeAll { $0 == button }
        }
    }
    
    func addAttributes(_ attributes: [UIKitViewAttribute]) {
        debugPrint("\(self): Attribute applied to content which does not respond to attributes. \(attributes)")
    }
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        debugPrint("\(self): Attribute applied to content which does not respond to attributes. \(attributes)")
    }
    func updateAttributes(_ attributes: [UIKitViewAttribute]) {
        debugPrint("\(self): Attribute applied to content which does not respond to attributes. \(attributes)")
    }
}
