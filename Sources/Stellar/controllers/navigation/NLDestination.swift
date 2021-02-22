//
//  Destination.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 11/29/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

/// A type which conforms to Destination and can be used to wrap any destination type.
///
/// This type is used with a Navigator conforming type in order to perform navigation to the destination wrapped by this type.
public
struct NLDestination: Destination {
	var presentationDataProvider: () -> NLPresentationData
	
    public
    init(presentationDataProvider: @escaping () -> NLPresentationData) {
        self.presentationDataProvider = presentationDataProvider
    }
    
    public
	func makePresentationData() -> NLPresentationData {
		presentationDataProvider()
	}
}
