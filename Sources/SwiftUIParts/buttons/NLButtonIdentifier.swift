//
//  NLButtonIdentifier.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/12/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation

/// An encapsulation of button identity.
public
struct NLButtonIdentifier: Identifiable, Hashable {
    public let id: String
    public init(id: String) {
        self.id = id
    }
}
// MARK: - standard identifiers
public
extension NLButtonIdentifier {
    static var done: NLButtonIdentifier { .init(id: "done") }
}
