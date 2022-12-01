//
//  SContent.swift
//  
//
//  Created by Jesse Spencer on 3/12/21.
//

import Foundation

// TODO: body property needs @MainActor.
/// A description of content used to create some Stellar views.
///
/// - Important: Only use `struct` when making your content.
public
protocol SContent {
    /// The body content type provided by this content.
    associatedtype Body: SContent
    
    /// The body content produced by this content.
    @SContentBuilder var body: Self.Body { get }
}

extension SContent {
    var typeConstructorName: String {
        StellarFoundation.typeConstructorName(getType(self))
    }
}
