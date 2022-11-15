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
    let antialiased: Bool
}

public
extension SContent {
    func cornerRadius(_ radius: Double,
                      antialiased: Bool = true) -> some SContent {
        modifier(SCornerRadiusModifier(cornerRadius: radius,
                                       antialiased: antialiased))
    }
}
