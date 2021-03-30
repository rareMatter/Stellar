//
//  TouchGestureRecognizer.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/7/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

final class TouchGestureRecognizer: UIGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
    
}
