//
//  _SContentContainer.swift
//  
//
//  Created by Jesse Spencer on 5/16/21.
//

import utilities

/// A content container which renders with children. These children will be added to the hierarchy during rendering.
///
/// 
protocol _SContentContainer: CollectionBox where Object == any SContent {}

// TODO: Probably the group protocols should be replaced with a standalone protocol which designates that a primitive is skipped during rendering, which more directly names the purpose.
/// A content container which provides children but has no appearance of its own and will be skipped during rendering.
protocol GroupedContent: _SContentContainer {}
