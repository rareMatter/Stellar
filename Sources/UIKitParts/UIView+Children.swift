//
//  UIView+Children.swift
//  
//
//  Created by Jesse Spencer on 7/30/22.
//

import UIKit

// MARK: - Standard UIView rendering functions for any general cases
public
extension UIView {
    
    // Children
    static
    func addChild(toView destinationView: UIView,
                  childView: UIView,
                  before siblingView: UIView?) {
        if let siblingView = siblingView {
            destinationView.insertSubview(childView,
                                          belowSubview: siblingView)
        }
        else {
            destinationView.addSubview(childView)
        }

        childView.translatesAutoresizingMaskIntoConstraints = true
        childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    static
    func removeChild(fromView targetView: UIView,
                     childView: UIView) {
        childView.removeFromSuperview()
    }
}
