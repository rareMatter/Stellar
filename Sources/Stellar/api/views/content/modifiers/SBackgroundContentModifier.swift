//
//  SBackgroundContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/7/21.
//

import Foundation
import SwiftUI

struct SBackgroundContentModifier: SContentModifier {
    typealias Body = Never
    let backgroundColor: Color
}

public
extension SContent {
    func background(_ color: Color) -> some SContent {
        modifier(SBackgroundContentModifier(backgroundColor: color))
    }
}
