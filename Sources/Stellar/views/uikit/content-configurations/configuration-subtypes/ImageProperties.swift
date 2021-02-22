//
//  ImageProperties.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 10/19/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

public
struct ImageProperties: Hashable {
	public var preferredSymbolConfiguration: UIImage.SymbolConfiguration
    public
    init(preferredSymbolConfiguration: UIImage.SymbolConfiguration) {
        self.preferredSymbolConfiguration = preferredSymbolConfiguration
    }
}
