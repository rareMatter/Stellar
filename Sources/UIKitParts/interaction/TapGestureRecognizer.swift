//
//  TapGestureRecognizer.swift
//  
//
//  Created by Jesse Spencer on 11/18/21.
//

import UIKit

/// A closure-based wrapper of `UITapGestureRecognizer.`
public
final
class TapGestureRecognizer {
    
    public private(set)
    var tapGestureRecognizer: UITapGestureRecognizer!
    public
    var handler: () -> Void
    
    public
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
