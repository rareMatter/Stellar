//
//  TapGestureRecognizer.swift
//  
//
//  Created by Jesse Spencer on 11/18/21.
//

import UIKit

/// An identifiable, closure-based wrapper of `UITapGestureRecognizer.`
final
class TapGestureRecognizer {
    
    private(set)
    var tapGestureRecognizer: UITapGestureRecognizer!
    var handler: SHashableClosure
    
    init(_ handler: SHashableClosure) {
        self.handler = handler
        tapGestureRecognizer = .init(target: self, action: #selector(Self.handleTap))
    }
    
    @objc
    private
    func handleTap() {
        handler()
    }
}
extension TapGestureRecognizer {
    
    static
    func ==(lhs: TapGestureRecognizer,
            rhs: TapGestureRecognizer) -> Bool {
        lhs.handler == rhs.handler
    }
}
