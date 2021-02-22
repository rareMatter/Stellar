//
//  RecurrenceTableCell.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 4/1/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "Use ConfigurableCollectionCell with an appropriate content configuration instead.")
public
class RecurrenceTableCell: UITableViewCell {

    public static let reuseID = "RecurrenceCell"
    public static let nibName = "RecurrenceTableCell"
	
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
