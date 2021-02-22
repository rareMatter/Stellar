//
//  SearchTableCell.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 6/4/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

/// A cell which embeds a UISearchBar.
@available(*, deprecated, message: "Use SearchBarContentConfiguration with SearchCollectionCell instead.")
public
class SearchTableCell: UITableViewCell {
	
    public
	class var reuseID: String { "searchCell" }
	
	public var searchBar: UISearchBar!
	
	public var searchDelegate: UISearchBarDelegate? {
		get { searchBar.delegate }
		set { searchBar.delegate = newValue }
	}
	
	// MARK: - init
	
    public
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureHierarchy()
	}
	
	private func configureHierarchy() {
		searchBar = UISearchBar()
		searchBar.placeholder = NSLocalizedString("Create or find a list...", comment: "")
		searchBar.searchBarStyle = .minimal
		
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(searchBar)
		searchBar.snp.makeConstraints { (make) in
			make.directionalEdges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
