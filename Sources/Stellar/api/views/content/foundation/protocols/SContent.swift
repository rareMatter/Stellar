//
//  SContent.swift
//  
//
//  Created by Jesse Spencer on 3/12/21.
//

import Foundation

/// A description of content used to create some Stellar views.
public
protocol SContent {
    /// The body content type provided by this content.
    associatedtype Body: SContent
    
    /// The body content produced by this content.
    @SContentBuilder var body: Self.Body { get }
}
