//
//  CollapsibleTableSectionHeader.swift
//  Stellar
//
//  Created by Jesse Spencer on 9/18/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

class CollapsibleTableSectionHeader: UITableViewHeaderFooterView {
	
	class var reuseID: String {
		return "CollapsibleSectionHeader"
	}
	
	var section = 0
	
	let arrowLabel = UILabel()
	
	// -- Callbacks
	var onTap: (() -> Void)?
	// --
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		
		// Init arrow label
		arrowLabel.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(arrowLabel)
		
		arrowLabel.textColor = .white
		arrowLabel.text = ">"
		
		NSLayoutConstraint.activate([
			arrowLabel.widthAnchor.constraint(equalToConstant: 12),
			arrowLabel.heightAnchor.constraint(equalToConstant: 12),
			arrowLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			arrowLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
		
		// Add tap gesture
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:))))
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		assertionFailure("init(coder:) has not been implemented")
	}
	
	@objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
		guard let _ = gestureRecognizer.view as? CollapsibleTableSectionHeader else {
			return
		}
		
		self.onTap?()
	}
	
	func setCollapsed(_ collapsed: Bool) {
		// Animate the arrow rotation
		arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
	}
	
}
// MARK: View Rotation
extension UIView {
	func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
		let animation = CABasicAnimation(keyPath: "transform.rotation")
		
		animation.toValue = toValue
		animation.duration = duration
		animation.isRemovedOnCompletion = false
		animation.fillMode = CAMediaTimingFillMode.forwards
		
		self.layer.add(animation, forKey: nil)
	}
}
