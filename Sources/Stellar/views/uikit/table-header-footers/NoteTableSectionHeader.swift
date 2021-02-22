//
//  NoteTableSectionHeader.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 9/18/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

class NoteSectionHeader: CollapsibleTableSectionHeader {
	
	override class var reuseID: String {
		return "NotesHeader"
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
		NSLayoutConstraint.activate([
			image.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			image.widthAnchor.constraint(equalToConstant: 30),
			image.heightAnchor.constraint(equalToConstant: 30),
			image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			// Center the label vertically, and use it to fill the remaining
			// space in the header view.
			title.heightAnchor.constraint(equalToConstant: 30),
			title.leadingAnchor.constraint(equalTo: image.trailingAnchor,
										   constant: 8),
			title.trailingAnchor.constraint(equalTo:
				contentView.layoutMarginsGuide.trailingAnchor),
			title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}
}
