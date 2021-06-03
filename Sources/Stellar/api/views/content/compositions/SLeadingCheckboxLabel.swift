//
//  SLeadingCheckboxLabel.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SLeadingCheckboxLabel: SPrimitiveContent {
    
    var title: String
    var subtitle: String
    
    var subtitleLeadingView: UIView
    
    var checkboxActionHandler: () -> Void
    var checkboxImage: UIImage?
    
    var checkboxBackgroundColor: UIColor?
    
    var isChecked = false
    var isDisabled = false
    
    var trailingViews: [UIView] = []
    
    public
    init(title: String,
         checkboxImage: UIImage? = nil,
         checkboxBackgroundColor: UIColor? = nil,
         subtitle: String = "",
         subtitleLeadingView: UIView,
         trailingViews: [UIView] = [],
         checkboxAction: @escaping () -> Void) {
        self.title = title
        self.checkboxImage = checkboxImage
        self.checkboxBackgroundColor = checkboxBackgroundColor
        self.subtitle = subtitle
        self.subtitleLeadingView = subtitleLeadingView
        self.trailingViews = trailingViews
        self.checkboxActionHandler = checkboxAction
    }
}

// MARK: - modifiers
public
extension SLeadingCheckboxLabel {
    
    func selected(_ state: Bool) -> Self {
        var modified = self
        modified.isChecked = state
        return modified
    }
    
    func disabled(_ state: Bool) -> Self {
        var modified = self
        modified.isDisabled = state
        return modified
    }
}
