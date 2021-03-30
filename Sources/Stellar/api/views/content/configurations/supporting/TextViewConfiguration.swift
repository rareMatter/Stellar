//
//  TextViewConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 11/6/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

struct TextViewConfiguration: Equatable {
    var delegate: TextViewDelegateConfiguration = .init()
    var isEditable: Bool = true
    var isScrollable: Bool = true
    var inputAccessoryView: UIView?
}
