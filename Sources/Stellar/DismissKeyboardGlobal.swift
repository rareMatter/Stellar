//
//  DismissKeyboardGlobal.swift
//  life-tool-1-iOS
//
//  Created by Jesse Spencer on 12/11/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

public
func dismissKeyboardGlobal() {
	UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
