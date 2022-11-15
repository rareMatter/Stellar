//
//  SLeadingCheckboxLabel.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit
import StellarFoundation

@available(*, deprecated, message: "Create compositions using primitive content types instead.")
public
struct SLeadingCheckboxLabel: SPrimitiveContent {
    
    var title: String
    var subtitle: String
    
    var subtitleLeadingView: UIView
    
    var checkboxActionHandler: () -> Void
    var checkboxImage: UIImage?
    
    var checkboxBackgroundColor: UIColor?
    
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
