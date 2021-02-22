//
//  NLPresentationData.swift
//  life-tool-1-iOS
//
//  Created by Jesse Spencer on 2/16/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation

public
struct NLPresentationData {
    var viewController: ViewController
    var presentationContext: NLPresentationContext
    var presentationStyle: PresentationStyle
    
    public init(viewController: ViewController, presentationContext: NLPresentationContext = .primary, presentationStyle: PresentationStyle = .modal()) {
        self.viewController = viewController
        self.presentationContext = presentationContext
        self.presentationStyle = presentationStyle
    }
}
extension NLPresentationData {
    static func defaultPresentationData() -> Self {
        // TODO: replace with something went wrong view controller.
        .init(viewController: NLViewController(), presentationContext: .content, presentationStyle: .root)
    }
}
