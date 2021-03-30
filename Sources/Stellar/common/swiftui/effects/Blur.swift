//
//  Blur.swift
//  Stellar
//
//  Created by Jesse Spencer on 6/4/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import SwiftUI

struct Blur: UIViewRepresentable {
	let style: UIBlurEffect.Style
	
	func makeUIView(context: Context) -> UIVisualEffectView {
		return UIVisualEffectView(effect: UIBlurEffect(style: style))
	}
	
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		uiView.effect = UIBlurEffect(style: style)
	}
}
