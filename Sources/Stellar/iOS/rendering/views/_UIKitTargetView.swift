//
//  _UIKitTargetView.swift
//  
//
//  Created by Jesse Spencer on 1/16/22.
//

import Foundation
import UIKit

final
class _UIKitTargetView: UIView, UIKitTargetView {
    // TODO: This may be necessary to mirror the compositional nature of StellarUI. For example, if a UIButton descendant is used it would limit composition by expecting certain properties to be used. This does not correspond appropriately the the compositional nature of the SButton body Label. By avoiding the specific nature of UIView descendants, generalized composition can be achieved by having this view respond as needed to general messages, while allowing the client to override general behaviors.
    // Additonally, the only reason SwiftUI includes specific, named views such as Button is to provide quick default styling options and easily understood code which can be universally reasoned about. Button requires an action handler up front as well, making it slighly more steamlined than adding one as a modifier on some arbitrary view type.
}
