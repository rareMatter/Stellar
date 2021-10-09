//
//  _SContentContainer.swift
//  
//
//  Created by Jesse Spencer on 5/16/21.
//

import Foundation

/// Content which acts only as a container of other content and has no appearance of its own.
protocol _SContentContainer {
    var children: [AnySContent] { get }
}
