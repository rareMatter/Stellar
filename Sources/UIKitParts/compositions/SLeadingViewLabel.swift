//
//  SLeadingViewLabel.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit
import StellarFoundation

@available(*, deprecated, message: "Create compositions using primitive content types instead.")
public
struct SLeadingViewLabel: SPrimitiveContent {
    
    var text: String
    var leadingView: UIView
    var horizontalAlignment: SHorizontalAlignment
    
    public
    init(text: String,
         leadingView: UIView,
         horizontalAlignment: SHorizontalAlignment = .leading) {
        self.text = text
        self.leadingView = leadingView
        self.horizontalAlignment = horizontalAlignment
    }
}
