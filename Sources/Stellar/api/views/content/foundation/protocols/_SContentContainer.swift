//
//  _SContentContainer.swift
//  
//
//  Created by Jesse Spencer on 5/16/21.
//

import Foundation

/// A content container which renders with children.
protocol _SContentContainer {
    var children: [AnySContent] { get }
}

/// A content container which renders its children but has no appearance of its own.
protocol GroupedContent: _SContentContainer {}
