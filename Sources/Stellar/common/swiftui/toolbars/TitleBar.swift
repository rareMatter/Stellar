//
//  TitleBar.swift
//  Stellar
//
//  Created by Jesse Spencer on 12/14/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

public
struct TitleBar<Leading: View, Trailing: View>: View {
	
	public let title: String
	private var titleImage: Image?
	
	private var leadingView: () -> Leading
	private var trailingView: () -> Trailing
	
    public
	init(title: String, titleImage: Image? = nil, @ViewBuilder leading: @escaping () -> Leading, @ViewBuilder trailing: @escaping () -> Trailing) {
		self.title = title
		self.titleImage = titleImage
		self.leadingView = leading
		self.trailingView = trailing
	}
	
    public var body: some View {
		ZStack(alignment: .center) {
			HStack {
				titleImage
				Text(title)
			}
			HStack {
				leadingView()
				Spacer()
				trailingView()
			}
		}
	}
}
