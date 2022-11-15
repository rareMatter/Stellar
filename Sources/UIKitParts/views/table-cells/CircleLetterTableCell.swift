//
//  CircleLetterTableCell.swift
//  Stellar
//
//  Created by Jesse Spencer on 6/4/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SwiftUI
import SnapKit

@available(*, deprecated, message: "Instead use CircleLetterView embedded in a cell of your choice.")
public
class CircleLetterTableCell: UITableViewCell {
	
    public
	class var reuseID: String { "circleLetterCell" }
	
	// -- data
	public var title: String = " " {
		didSet {
			titleLabel.text = title
			letterLabel.text = String(circleLetter)
		}
	}
	private var circleLetter: Character { title.first ?? "p" }
	
	public var trailingView: UIView? {
		willSet {
			if newValue == nil {
				trailingView?.removeFromSuperview()
				contentView.setNeedsUpdateConstraints()
			}
		}
		didSet {
			if let trailingView = trailingView {
				contentView.addSubview(trailingView)
				trailingView.translatesAutoresizingMaskIntoConstraints = false
				contentView.setNeedsUpdateConstraints()
			}
		}
	}
	
	// -- views
	private var titleLabel: UILabel!
	private var circleImageView: UIImageView!
	private var letterLabel: UILabel!
	
	// MARK: - init
	
    public
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureHierarchy()
	}
	
	private func configureHierarchy() {
		// circle image view
		guard let circle = UIImage(systemName: "circle.fill") else {
			fatalError("Could not load image.")
		}
		circleImageView = UIImageView(image: circle)
		circleImageView.translatesAutoresizingMaskIntoConstraints = false
		let symbolConfig = UIImage.SymbolConfiguration(textStyle: .title1)
		circleImageView.preferredSymbolConfiguration = symbolConfig
		
		// letter label
		letterLabel = UILabel(frame: .zero)
		letterLabel.translatesAutoresizingMaskIntoConstraints = false
		letterLabel.textColor = .white
		letterLabel.textAlignment = .center
		letterLabel.font = .preferredFont(forTextStyle: .callout)
		
		// title label
		titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textColor = .label
		titleLabel.font = .preferredFont(forTextStyle: .body)
		titleLabel.adjustsFontForContentSizeCategory = true
		
		contentView.addSubview(circleImageView)
		contentView.addSubview(letterLabel)
		contentView.addSubview(titleLabel)
		
		if let trailingView = trailingView {
			trailingView.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(trailingView)
		}
		
		contentView.setNeedsUpdateConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - view lifecycle
	
	private var needsSetupConstraints = true
	
    public override func updateConstraints() {
		
		if needsSetupConstraints {
			circleImageView.snp.makeConstraints { (make) in
				make.centerY.equalToSuperview()
				make.leading.equalTo(contentView.snp.leadingMargin)
			}
			letterLabel.snp.makeConstraints { (make) in
				make.center.equalTo(circleImageView)
				make.directionalEdges.equalTo(circleImageView)
			}
			titleLabel.snp.makeConstraints { (make) in
				make.leading.equalTo(circleImageView.snp.trailingMargin).offset(16)
				make.top.bottom.equalToSuperview()
				make.height.greaterThanOrEqualTo(44)
				make.trailing.equalTo(contentView.snp.trailingMargin)
			}
			
			needsSetupConstraints = false
		}
		
		if let trailingView = trailingView {
			trailingView.snp.makeConstraints { (make) in
				make.centerY.equalToSuperview()
				make.trailing.equalTo(contentView.snp.trailingMargin)
			}
			
			titleLabel.snp.remakeConstraints { (make) in
				make.leading.equalTo(circleImageView.snp.trailingMargin).offset(16)
				make.top.bottom.equalToSuperview()
				make.height.greaterThanOrEqualTo(44)
				make.trailing.equalTo(trailingView.snp.leading)
			}
		}
		else {
			titleLabel.snp.remakeConstraints { (make) in
				make.leading.equalTo(circleImageView.snp.trailingMargin).offset(16)
				make.top.bottom.equalToSuperview()
				make.height.greaterThanOrEqualTo(44)
				make.trailing.equalTo(contentView.snp.trailingMargin)
			}
		}
		
		super.updateConstraints()
	}
}

#if DEBUG
public
struct CircleLetterTableCellViewRepresentable: UIViewRepresentable {
	public
	typealias UIViewType = CircleLetterTableCell
	
	public let title: String
	public let trailingView: UIView?
	
    public
    init(title: String, trailingView: UIView? = nil) {
        self.title = title
        self.trailingView = trailingView
    }
    
    public func makeUIView(context: Context) -> CircleLetterTableCell {
		let cell = CircleLetterTableCell()
		
		cell.title = title
		cell.trailingView = trailingView
		
		return cell
	}
	
    public func updateUIView(_ uiView: CircleLetterTableCell, context: Context) {}
}

#endif
