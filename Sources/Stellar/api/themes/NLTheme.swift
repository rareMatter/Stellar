//
//  NLTheme.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/9/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation

/// A collection of colors applied to surfaces throughout NebuList.
public struct NLTheme: Codable {
    /// Colors for all non-special surfaces.
    public var basicColors: NLColors
    
    // -- standard lists
    public var scheduleColors: NLColors
    public var historyColors: NLColors
    public var unsortedColors: NLColors
    public var labelsColors: NLColors
}

// MARK: - defaults
public
extension NLTheme {
    static var standard: NLTheme {
        .init(basicColors: .standard,
              scheduleColors: .schedule,
              historyColors: .history,
              unsortedColors: .unsorted,
              labelsColors: .labels)
    }
}
