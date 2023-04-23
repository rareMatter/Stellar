//
//  SCornerRadiusContentModifier.swift
//  
//
//  Created by Jesse Spencer on 9/23/21.
//

public
struct SCornerRadiusModifier: PrimitiveContentModifier {
    public typealias Body = Never
    public let cornerRadius: Double
    public let antialiased: Bool
}

public
extension SContent {
    func cornerRadius(_ radius: Double,
                      antialiased: Bool = true) -> some SContent {
        modifier(SCornerRadiusModifier(cornerRadius: radius,
                                       antialiased: antialiased))
    }
}
