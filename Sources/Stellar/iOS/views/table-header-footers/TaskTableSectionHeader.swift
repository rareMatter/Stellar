//
//  TaskTableSectionHeader.swift
//  Stellar
//
//  Created by Jesse Spencer on 9/18/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

class TaskSectionHeader: CollapsibleTableSectionHeader {
	
	override class var reuseID: String {
		return "TaskHeader"
	}
		
	let title = UILabel()
	let image = UIImageView()
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		initViews()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		assertionFailure("init(coder:) has not been implemented")
	}
	
	private func initViews() {
		title.translatesAutoresizingMaskIntoConstraints = false
		image.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(title)
		contentView.addSubview(image)
		
		// Constrain image
		let marginsGuide = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			// Place the image at the leading edge
			image.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
			image.widthAnchor.constraint(equalToConstant: 30),
			image.heightAnchor.constraint(equalToConstant: 30),
			image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			// Center the label vertically and fill the header view.
			title.heightAnchor.constraint(equalToConstant: 30),
			title.leadingAnchor.constraint(equalTo: image.trailingAnchor,
										   constant: 8),
			title.trailingAnchor.constraint(equalTo:
				marginsGuide.trailingAnchor),
			title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}
}
