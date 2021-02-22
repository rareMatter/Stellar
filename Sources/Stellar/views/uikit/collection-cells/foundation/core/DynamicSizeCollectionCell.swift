//
//  DynamicSizeCollectionCell.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 11/10/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// A cell which responds to dynamic height changes by informing it's containing view.
public
class DynamicSizeCollectionCell: UICollectionViewListCell, DynamicSizeUpdating {
	/// Call this closure from height-modifying code. This closure is set by the containing view and used to update for size changes.
	/// - Warning: Only call this closure from the main thread - it is UI updating
	public var sizeDidChange: () -> Void = {}
}
