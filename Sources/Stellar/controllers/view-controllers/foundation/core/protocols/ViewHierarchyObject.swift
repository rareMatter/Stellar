//
//  ViewHierarchyObject.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/15/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

public typealias ViewController = ViewHierarchyObject

/// Describes an object which performs notices when it has dismissed.
public
protocol ViewHierarchyObject: UIViewController {
    /// A publisher which posts after the view controller has dismissed itself or been dismissed externally.
    var dismissalPublisher: AnyPublisher<UIViewController, Never> { get }
    var rootController: RootController { get set }
}
extension ViewHierarchyObject {
    
    var isPresenting: Bool {
        isBeingPresented || isMovingToParent
    }
    var containerIsPresenting: Bool {
        if let parent = parent {
            return parent.isBeingPresented ||
                parent.isMovingToParent
        }
        return false
    }
    
    var isDismissing: Bool {
        isBeingDismissed || isMovingFromParent
    }
    var containerIsDismissing: Bool {
        if let parent = parent {
            return parent.isBeingDismissed ||
                parent.isMovingFromParent
        }
        return false
    }
}
