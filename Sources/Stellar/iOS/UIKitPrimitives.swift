//
//  UIKitPrimitives.swift
//  
//
//  Created by Jesse Spencer on 10/26/21.
//

// TODO: WIP

import UIKit
import SwiftUI

// MARK: modified content
extension SModifiedContent: UIKitPrimitive
where Content : SContent, Modifier : UIKitModifier {
    
    var renderedBody: AnySContent {
        AnySContent(UIKitViewModifier(attributes: [modifier.renderableAttribute]))
    }
}

// MARK: modifiers
extension STapHandlerModifier: UIKitModifier {
    var renderableAttribute: UIKitViewAttribute {
        .tapHandler(.init(tapHandler))
    }
}

extension SCornerRadiusModifier: UIKitModifier {
    var renderableAttribute: UIKitViewAttribute {
        .cornerRadius(value: cornerRadius,
                      antialiased: antialiased)
    }
}

extension SDisabledContentModifier: UIKitModifier {
    var renderableAttribute: UIKitViewAttribute {
        .disabled(isDisabled)
    }
}

extension SEditingSelectableContentModifier: UIKitModifier {
    var renderableAttribute: UIKitViewAttribute {
        .editingSelectable(isSelectable)
    }
}

// MARK: buttons
extension SButton: UIKitPrimitive {
    
    var renderedBody: AnySContent {
        .init(UIKitViewPrimitive(viewType: .button,
                                attributes: []))
    }
}

// MARK: containers
extension SHStack: UIKitPrimitive {
    
    var renderedBody: AnySContent {
        AnySContent(UIKitViewPrimitive(viewType: .hStack) {
            content
        })
    }
}

// MARK: - background
extension BackgroundModifierContainer: UIKitPrimitive {
    
    var renderedBody: AnySContent {
        .init(UIKitViewPrimitive(viewType: .zStack,
                                 attributes: [.alignment(alignment)],
                                 content: {
            background
            content
        }))
    }
}

// MARK: - swipe actions
extension SSwipeActionsModifierContainer: UIKitPrimitive {
    
    var renderedBody: AnySContent {
        .init(UIKitViewPrimitive(viewType: .swipeActions(edge: edge,
                                                         allowsFullSwipe: allowsFullSwipe),
                                 attributes: [],
                                 content: { actions }))
    }
}

