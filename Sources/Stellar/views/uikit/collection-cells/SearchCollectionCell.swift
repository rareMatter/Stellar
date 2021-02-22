//
//  SearchCollectionCell.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 10/14/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "Use ConfigurableCollectionCell with a content configuration instead.")
public
final class SearchCollectionCell: UICollectionViewCell {
    
    public func defaultSearchContentConfiguration() -> SearchBarContentConfiguration {
		.init(placeholderText: "Find something...")
	}
    public var searchBarContentConfiguration: SearchBarContentConfiguration {
		get { searchContentView.configuration as! SearchBarContentConfiguration }
		set { searchContentView.configuration = newValue }
	}
	
	private var searchContentView: (UIView & UIContentView)!
	
    public 
	override init(frame: CGRect) {
		super.init(frame: frame)
		searchContentView =
			defaultSearchContentConfiguration()
			.makeContentView()
		contentView.addSubview(searchContentView)
		searchContentView.snp.makeConstraints { (make) in
			make.directionalEdges.equalToSuperview()
			make.top.bottom.equalToSuperview()
		}
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
