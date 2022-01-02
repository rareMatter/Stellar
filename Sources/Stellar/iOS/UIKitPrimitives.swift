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
        .init(UIKitViewPrimitive(viewType: .button, content: { content }))
    }
}
//extension SContextMenuButton: UIKitPrimitive {
//    var renderedBody: AnySContent {
//        .init(UIKitViewPrimitive(viewType: .menu, content: {
//            body
//        }))
//    }
//}
extension _SContextMenuButtonContent: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitViewPrimitive(viewType: .menuContent, content: {
            content
        }))
    }
}
extension _SContextMenuButtonLabel: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitViewPrimitive(viewType: .menuLabel, content: {
            content
        }))
    }
}

// MARK: search bar
extension SSearchBar: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitViewPrimitive(viewType: .searchBar))
    }
}

// MARK: text editor
extension STextEditor: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitViewPrimitive(viewType: .textEditor))
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
extension SVStack: UIKitPrimitive {
    var renderedBody: AnySContent {
        AnySContent(UIKitViewPrimitive(viewType: .vStack, content: {
            content
        }))
    }
}

// MARK: - colors
extension SColor: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitViewPrimitive(viewType: .color(r: red, g: green, b: blue, opacity: opacity)))
    }
}
extension SDynamicColor: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitViewPrimitive(viewType: .dynamicColor(colorResolverContainer: colorResolverContainer)))
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

// MARK: empty content
/* TODO: Needed?
extension SEmptyContent: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(<#T##content: SContent##SContent#>)
    }
}
*/
