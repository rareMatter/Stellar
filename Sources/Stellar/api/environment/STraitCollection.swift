//
//  STraitCollection.swift
//  
//
//  Created by Jesse Spencer on 9/12/21.
//
// This is a temporary method to access the current trait collection provided by the system. This will be removed when proper Environment API is implemented in Stellar.

// MARK: TODO: Replace this with proper Environment access api.

#if canImport(UIKit)

import UIKit

public
struct STraitCollection {
    public
    static
    var currentUITraitCollection: UITraitCollection { .current }
}

#endif
