//
//  HierarchyManager.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 12/2/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// An object which handles presentation and dismissal, if needed, of view controllers provided by clients in a primary-column aside content-column layout, space permitting. This object also tracks the view controller hierarchy as needed to perform presentations as requested.
public protocol HierarchyManager: AnyObject {
	func show(viewController: UIViewController & ViewControllerDismissalNotifier, inContext presentationContext: NLPresentationContext, withStyle presentationStyle: PresentationStyle, withAnimation isAnimated: Bool)
	
	func dismissControllerIfNeeded(_ viewController: UIViewController, withAnimation: Bool)
}
