//
//  Comparable+Extensions.swift
//  
//
//  Created by Jesse Spencer on 9/14/21.
//

import Foundation

extension Comparable {
    
    /// "Clamps" (restricts by min or max) self to the closed range such that the number will not fall outside the clamping bounds.
    @discardableResult
    public
    func clamp(to bound: ClosedRange<Self>) -> Self {
        if self < bound.lowerBound {
            return bound.lowerBound
        }
        else if self > bound.upperBound {
            return bound.upperBound
        }
        else {
            return self
        }
    }
}
