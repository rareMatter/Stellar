//
//  DateTableCell.swift
//  Stellar
//
//  Created by Jesse Spencer on 9/18/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "Use ConfigurableCollectionCell with an appropriate content configuration instead.")
public
class DateTableCell: UITableViewCell {
    public static let reuseID = "Date"
    public static let nibName = "DateTableCell"
	
	// MARK: View Lifecycle
    public 
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
