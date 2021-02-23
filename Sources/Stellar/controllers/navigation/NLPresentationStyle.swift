//
//  NLPresentationStyle.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/16/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

/// The range of styles for view presentation.
public enum PresentationStyle {
    /// Presents the view modally, as a discrete and separate space.
    case modal(presentationStyle: UIModalPresentationStyle = UIModalPresentationStyle.automatic, transitionStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical)
    /// Presents the view by adding to a navigation stack.
    case stack
    /// Presents the view by embedding it as the root of the space, replacing an existing view, if needed.
    case root
}
extension PresentationStyle: Equatable {}
