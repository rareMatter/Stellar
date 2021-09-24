//
//  SEditingSelectableContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/7/21.
//

import Foundation

struct SEditingSelectableContentModifier: SContentModifier {
    typealias Body = Never
    let isSelectable: Bool
}

public
extension SContent {
    /// Designates that the content can be selected during editing modes.
    ///
    /// This is most often used for rows of lists or cells of grids.
    func editingSelectable(_ isSelectable: Bool = true) -> some SContent {
        modifier(SEditingSelectableContentModifier(isSelectable: isSelectable))
    }
}
