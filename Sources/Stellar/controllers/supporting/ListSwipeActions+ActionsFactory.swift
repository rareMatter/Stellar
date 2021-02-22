//
//  ListSwipeActions+ActionsFactory.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 9/8/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation
import UIKit

public
extension ListSwipeAction {
	
	/// Creates an action for choosing a date.
	static func makeChooseDateAction(withHandler handler: @escaping ListSwipeAction.Handler) -> ListSwipeAction {
		.init(
			style: .normal,
			completionAction: .none,
			title: NSLocalizedString("Choose date", comment: ""),
			backgroundColor: nil,
			image: UIImage(systemName: "calendar"),
			handler: handler)
	}
}
