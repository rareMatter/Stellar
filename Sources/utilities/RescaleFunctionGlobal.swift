//
//  RescaleFunctionGlobal.swift
//  
//
//  Created by Jesse Spencer on 2/21/22.
//

import Foundation

/// Rescales `value` from `currentRange` to `newRange`. It is assumed `0` is the minimum value.
public
func rescale(value: Double, currentMax: Double, newMax: Double) -> Double {
    (newMax/currentMax) * value
}
