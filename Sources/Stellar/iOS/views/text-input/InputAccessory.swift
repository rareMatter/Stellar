//
//  InputAccessory.swift
//  Stellar
//
//  Created by Jesse Spencer on 8/24/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

/// A factory for input accessory views.
@available(*, deprecated, message: "Use NLInputAccessoryFactory instead or the InputAccessoryFactory protocol for clients.")
public
struct InputAccessory {
	
    public
	static func forDismissal(target: Any?, action: Selector?) -> UIToolbar {
		
		let toolbar = UIToolbar()
		
		let items = [
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .done, target: target, action: action)
		]
		
		toolbar.items = items
		toolbar.sizeToFit()
		
		return toolbar
	}
	
    public 
	static func forTaskEditing(target: Any, upArrowTapped: Selector, downArrowTapped: Selector, keyboardDismissHandler: Selector) -> UIToolbar {
		
		let toolbar = UIToolbar()
		
		let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
		fixedSpace.width = 16
		
		let items = [
			UIBarButtonItem(image: UIImage(systemName: "text.insert"), style: .plain, target: target, action: upArrowTapped),
			fixedSpace,
			UIBarButtonItem(image: UIImage(systemName: "text.append"), style: .plain, target: target, action: downArrowTapped),
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .done, target: target, action: keyboardDismissHandler)
		]
		
		toolbar.setItems(items, animated: false)
		toolbar.sizeToFit()
		
		return toolbar
	}
	
}
