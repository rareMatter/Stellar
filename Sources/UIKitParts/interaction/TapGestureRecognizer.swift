//
//  TapGestureRecognizer.swift
//  
//
//  Created by Jesse Spencer on 11/18/21.
//

import UIKit

/// A closure-based wrapper of `UITapGestureRecognizer.`
final
class TapGestureRecognizer {
    
    private(set)
    var tapGestureRecognizer: UITapGestureRecognizer!
    var handler: () -> Void
    
    init(_ handler: @escaping () -> Void) {
        self.handler = handler
        tapGestureRecognizer = .init(target: self, action: #selector(Self.handleTap))
    }
    
    @objc
    private
    func handleTap() {
        handler()
    }
}
