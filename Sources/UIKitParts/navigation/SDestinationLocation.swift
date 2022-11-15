//
//  SDestinationLocation.swift
//  
//
//  Created by Jesse Spencer on 2/25/21.
//

import Foundation

/// Options for how a view will be added to the hierarchy when shown.
public
enum SDestinationLocation: Hashable {
    /// Used for placing a view at the bottom of the hierarchy, such as for persistent or important views.
    case root
    /// Used for continuous or related stacks of content.
    case stack
    /// Used for temporary or standalone content.
    case modal
}
