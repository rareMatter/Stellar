//
//  _SContentContainer.swift
//  
//
//  Created by Jesse Spencer on 5/16/21.
//

/// A content container which renders with children. These children will be added to the hierarchy during rendering.
///
/// 
protocol _SContentContainer {
    var children: [any SContent] { get }
}

/// A content container which provides children but has no appearance of its own and will be skipped during rendering.
protocol GroupedContent: _SContentContainer {}
