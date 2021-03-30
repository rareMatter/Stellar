//
//  SectionHeaderTableCell.swift
//  Stellar
//
//  Created by Jesse Spencer on 8/13/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "Use ConfigurableCollectionCell with an appropriate content configuration instead.")
final class SectionHeaderTableCell: UITableViewCell {
	
	class var reuseID: String { "SectionHeaderTableCell" }
	
	// -- views
	private lazy var hStack: UIStackView = {
		let hStack = UIStackView(frame: .zero)
		hStack.translatesAutoresizingMaskIntoConstraints = false
		hStack.axis = .horizontal
		hStack.distribution = .fill
		hStack.alignment = .center
		hStack.spacing = 8.0
		return hStack
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .preferredFont(forTextStyle: .title2)
		label.textColor = .label
		return label
	}()
	
	private let shrinkImage = UIImage(systemName: "minus.square")!
	private let expandImage = UIImage(systemName: "chevron.down.square.fill")!
	private lazy var minimizeImageView: UIImageView = {
		let imageView = UIImageView(image: shrinkImage)
		imageView.tintColor = UIColor.secondaryLabel
		return imageView
	}()
	
	private lazy var optionsButton: UIButton = {
		let optionsButton = UIButton()
		optionsButton.addTarget(self, action: #selector(self.optionsTapped), for: .touchUpInside)
		optionsButton.setBackgroundImage(optionsImage!, for: .normal)
		optionsButton.setPreferredSymbolConfiguration(.init(textStyle: .title2), forImageIn: .normal)
		return optionsButton
	}()
	private let optionsImage = UIImage(systemName: "ellipsis.circle.fill")
	
	// MARK: - init
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureHierarchy()
	}
	
	private func configureHierarchy() {
		titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
		minimizeImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
		minimizeImageView.setContentHuggingPriority(.required, for: .horizontal)
		optionsButton.setContentCompressionResistancePriority(.required, for: .horizontal)
		optionsButton.setContentHuggingPriority(.required, for: .horizontal)
		
		hStack.addArrangedSubview(titleLabel)
		hStack.addArrangedSubview(minimizeImageView)
		hStack.addArrangedSubview(optionsButton)
		
		contentView.addSubview(hStack)
		
		createConstraints()
	}
	
	private func createConstraints() {
		hStack.snp.makeConstraints { (make) in
			make.directionalEdges.equalTo(contentView.snp.directionalMargins)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - action methods
	
	@objc private
	func optionsTapped() {
		onOptionsTap()
	}
	
	// MARK: - api
	
	var title: String? {
		get { titleLabel.text }
		set {
			titleLabel.text = newValue
		}
	}
	
	var color: UIColor {
		get { optionsButton.tintColor }
		set {
			optionsButton.tintColor = newValue
		}
	}
	
	var isMinimized: Bool {
		get { minimizeImageView.image == expandImage }
		set {
			if newValue {
				minimizeImageView.image = expandImage
			}
			else {
				minimizeImageView.image = shrinkImage
			}
		}
	}
	
	// -- callbacks
	var onOptionsTap: (() -> Void) = {
		assertionFailure("Callback not set")
	}
}
extension SectionHeaderTableCell: ListCellUpdating {
	func updateForState(_ configurationState: CellConfigurationState) {}
}

