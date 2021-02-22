//
//  TagCollectionViewCell.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 7/29/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

/// Used by the TagCollectionViewController.
@available(*, deprecated, message: "Use ConfigurableCollectionCell with a content configuration instead.")
public
class TagCollectionViewCell: UICollectionViewCell {
	
    public static let reuseID = "TagCell"

    public let titleLabel = UILabel()
	
    public 
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
	}
	
	private func configureViews() {
		// Background
		backgroundView = UIView()
		backgroundView?.backgroundColor = UIColor.secondarySystemBackground
		
		// Selection
		selectedBackgroundView = UIView()
		selectedBackgroundView?.backgroundColor = UIColor.systemGray
		
		// Label
		titleLabel.adjustsFontForContentSizeCategory = true
		titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		titleLabel.textAlignment = .center
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(titleLabel)
		
		// Cosntraints
		NSLayoutConstraint.activate([
			titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 35),
			
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
