//
//  ListViewController+Types.swift
//  
//
//  Created by Jesse Spencer on 4/20/21.
//

import UIKit

extension ListViewController {
    
    struct DragItems {
        var sections: [SectionID] = []
        var items: [ItemID] = []
        
        var containsSection: Bool {
            !sections.isEmpty
        }
    }
    
    /// A data container for tracking a single multiselection session.
    struct MultiselectTransaction {
        /// A property used to track the initial multiselection button selection state change during a single pan gesture. This allows the gesture to set the following buttons to the same selection state.
        let isSelecting: Bool
        var updatedItems = Set<ItemID>()
    }
    
    /// A proxy class to delegate for gesture recognizers.
    final
    class GestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
        
        var panGesture: UIPanGestureRecognizer?
        var tapGesture: UITapGestureRecognizer?
        var touchGesture: TouchGestureRecognizer?
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer === touchGesture && otherGestureRecognizer === tapGesture {
                return true
            }
            return false
        }
    }
}
