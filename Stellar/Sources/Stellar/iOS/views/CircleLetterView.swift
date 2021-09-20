//
//  CircleLetterView.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/14/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

public
class CircleLetterView: UIView {
	
	// -- subviews
	private let letterLabel: UILabel
	private let circleImageView: UIImageView
	
    public
	init(text: String, color: UIColor) {
		// circle image view
		guard let circle = UIImage(systemName: "circle.fill") else {
			fatalError("Could not load image.")
		}
		circleImageView = UIImageView(image: circle)
		circleImageView.translatesAutoresizingMaskIntoConstraints = false
		let symbolConfig = UIImage.SymbolConfiguration(textStyle: .title1)
		circleImageView.preferredSymbolConfiguration = symbolConfig
		circleImageView.tintColor = color
		circleImageView.contentMode = .center
		
		// letter label
		letterLabel = UILabel(frame: .zero)
		letterLabel.translatesAutoresizingMaskIntoConstraints = false
		letterLabel.textColor = .white
		letterLabel.textAlignment = .center
		letterLabel.font = .preferredFont(forTextStyle: .callout)
		letterLabel.text = String(text.first ?? " ")
		
		super.init(frame: .zero)
		
		addSubview(circleImageView)
		addSubview(letterLabel)
		
		setNeedsUpdateConstraints()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: first baseline
	
    public override var firstBaselineAnchor: NSLayoutYAxisAnchor {
		circleImageView.firstBaselineAnchor
	}
	
	// MARK: content size
	
    public override var intrinsicContentSize: CGSize {
		circleImageView.intrinsicContentSize
	}
	
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
		circleImageView.intrinsicContentSize
	}
	
	// MARK: view lifecycle
	
	private var needsSetupConstraints = true
	
    public override func updateConstraints() {
		if needsSetupConstraints {
			
			circleImageView.snp.makeConstraints { (make) in
				make.centerY.equalToSuperview()
				make.edges.equalToSuperview()
			}
			letterLabel.snp.makeConstraints { (make) in
				make.center.equalTo(circleImageView)
				make.directionalEdges.lessThanOrEqualTo(circleImageView)
			}
			
			needsSetupConstraints = false
		}
		
		super.updateConstraints()
	}
}

#if DEBUG
import SwiftUI

struct CircleLetterViewRepresentable: UIViewRepresentable {
	typealias UIViewType = CircleLetterView
	
	func makeUIView(context: Context) -> CircleLetterView {
		let view = CircleLetterView(text: "title", color: .blue)
		return view
	}
	
	func updateUIView(_ uiView: CircleLetterView, context: Context) {}
}
struct CircleLetterView_Previews: PreviewProvider {
	static var previews: some View {
		CircleLetterViewRepresentable()
			.previewLayout(.sizeThatFits)
	}
}

#endif
