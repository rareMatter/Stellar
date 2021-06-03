//
//  SelectableView.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/7/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation

/// A view which updates its appearance with changes to selection state.
public protocol SelectableView {
    func setSelection(to state: Bool)
}
