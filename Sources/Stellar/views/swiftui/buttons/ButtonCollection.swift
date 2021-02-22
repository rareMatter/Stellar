//
//  ButtonCollection.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 12/2/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

// MARK: - Button Collection
/// A flowing collection of buttons with a leading image and title.
public
struct ButtonCollection<Datum: Identifiable, Label: View>: View {
	
	let data: [Datum]
	let label: (Datum) -> Label
	let onTap: (Datum) -> Void
	
    public
	init(data: [Datum], @ViewBuilder label: @escaping (Datum) -> Label, onTap: @escaping (Datum) -> Void) {
		self.data = data
		self.label = label
		self.onTap = onTap
	}
	
    public var body: some View {
		// TODO: Use ASCollectionView.
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(data) { (datum: Datum) in
					Button(action: {
						self.onTap(datum)
					}) {
						self.label(datum)
					}
				}
			}
		}
	}
}

