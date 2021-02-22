//
//  DynamicSizeUpdating.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 11/10/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

/// A contract between cell-displaying views and the cells they display which allows for cells to report when their height has dynamically changed to the containing view.
///
/// This contract allows a view which is being currently displayed to request height updates without the need to entirely reload the containing view. This is most useful for cells which contain text entry views that dynamically display multiple lines or cells which allow expansion/collapse behavior. A layout will be performed by the containing view whenever the request is made by the dynamic cell, therefore it is best for performance to only make requests when height has actually changed.
protocol DynamicSizeUpdating {
	/// Called by the dynamic view just after changes which have caused height to change.
	var sizeDidChange: () -> Void { get set }
}
