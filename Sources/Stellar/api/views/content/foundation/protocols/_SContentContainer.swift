//
//  _SContentContainer.swift
//  
//
//  Created by Jesse Spencer on 5/16/21.
//

import Foundation

/// A content container which renders with children. These children will be added to the hierarchy during rendering.
///
/// - Note: When content instances are type-erased with `AnySContent`, it will notice conforming types.
protocol _SContentContainer {
    var children: [AnySContent] { get }
}

/// A content container which provides children but has no appearance of its own and will be skipped during rendering.
protocol GroupedContent: _SContentContainer {}
