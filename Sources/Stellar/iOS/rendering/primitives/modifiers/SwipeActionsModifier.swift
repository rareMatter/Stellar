//
//  SwipeActions.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SSwipeActionsModifier: UIKitComposableModifier {
    var content: AnySContent { .init(UIKitSwipeActionsPrimitive(content: .init(actions), edge: edge, allowsFullSwipe: allowsFullSwipe)) }
}
