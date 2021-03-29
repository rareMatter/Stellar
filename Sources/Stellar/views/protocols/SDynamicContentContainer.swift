//
//  SDynamicContentContainer.swift
//  
//
//  Created by Jesse Spencer on 3/12/21.
//

import Foundation

/// A content container which can change size dynamically. Containing objects will be informed when container size changes.
///
/// When a size change occurs, the handler closure will be called. Users of this container should set the handler before beginning to display it so that size change updates can be received.
public
protocol SDynamicContentContainer {
    var sizeDidChange: () -> Void { get set }
}
