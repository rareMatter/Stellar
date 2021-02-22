//
//  NLColors.swift
//  life-tool-1-iOS
//
//  Created by Jesse Spencer on 2/9/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation

/// A set of semantic color categories.
public struct NLColors: Codable {
    /// Use to accentuate important surfaces.
    public var accent: NLColor
    /// Use to provide focused, direct feedback during interactions.
    public var highlight: NLColor
    /// Use to provide indication that a surface has been selected or deselected.
    public var selection: NLColor
    /// For background surfaces.
    public var backgrounds: NLBackgroundColors
}
/// A set of semantic colors for background surfaces. Higher numbers are closer-to-top surfaces.
public
struct NLBackgroundColors: Codable {
    /// The lowest background surface.
    public var base: NLColor
    /// The second-to-lowest background surface.
    public var secondLowest: NLColor
    /// The third-to-lowest background surface.
    public var thirdLowest: NLColor
}

// MARK: - defaults
public
extension NLColors {
    static var standard: NLColors {
        .init(accent: .blue,
              highlight: NLColor.blue.withAlpha(0.7),
              selection: .blue,
              backgrounds: .standard)
    }
    static var schedule: NLColors {
        .init(accent: NLStandardListColors.scheduleAccent,
              highlight: NLStandardListColors.scheduleAccent
                .withAlpha(0.7),
              selection: NLStandardListColors.scheduleAccent,
              backgrounds: .standard)
    }
    static var history: NLColors {
        .init(accent: NLStandardListColors.historyAccent,
              highlight: NLStandardListColors.historyAccent
                .withAlpha(0.7),
              selection: NLStandardListColors.historyAccent,
              backgrounds: .standard)
    }
    static var unsorted: NLColors {
        .init(accent: NLStandardListColors.unsortedAccent,
              highlight: NLStandardListColors.unsortedAccent
                .withAlpha(0.7),
              selection: NLStandardListColors.unsortedAccent,
              backgrounds: .standard)
    }
    static var labels: NLColors {
        .init(accent: NLStandardListColors.labelsAccent,
              highlight: NLStandardListColors.labelsAccent
                .withAlpha(0.7),
              selection: NLStandardListColors.labelsAccent,
              backgrounds: .standard)
    }
}
public 
extension NLBackgroundColors {
    static var standard: NLBackgroundColors {
        .init(base: .fromUIColor(.systemBackground),
              secondLowest: .fromUIColor(.secondarySystemBackground),
              thirdLowest: .fromUIColor(.tertiarySystemBackground))
    }
}
