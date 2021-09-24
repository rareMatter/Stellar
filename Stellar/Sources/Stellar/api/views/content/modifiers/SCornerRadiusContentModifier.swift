//
//  SCornerRadiusContentModifier.swift
//  
//
//  Created by Jesse Spencer on 9/23/21.
//

import Foundation

struct SCornerRadiusModifier: SContentModifier {
    typealias Body = Never
    let cornerRadius: Double
}

public
extension SContent {
    func cornerRadius(_ radius: Double) -> some SContent {
        modifier(SCornerRadiusModifier(cornerRadius: radius))
    }
}
