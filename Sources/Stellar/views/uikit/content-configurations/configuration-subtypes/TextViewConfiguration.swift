//
//  TextViewConfiguration.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 11/6/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

public
struct TextViewConfiguration: Equatable {
    public var inputAccessoryView: UIView?
    public var delegate: TextViewDelegateConfiguration
    public var isEditable: Bool
    public var isScrollable: Bool
    
    public
    init(inputAccessoryView: UIView? = nil, delegate: TextViewDelegateConfiguration = .init(), isEditable: Bool = true, isScrollable: Bool = true) {
        self.inputAccessoryView = inputAccessoryView
        self.delegate = delegate
        self.isEditable = isEditable
        self.isScrollable = isScrollable
    }
}
