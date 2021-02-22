//
//  TextProperties.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 10/19/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

public
struct TextProperties: Hashable {
	var font: UIFont
    
    public
    init(font: UIFont) {
        self.font = font
    }
}
