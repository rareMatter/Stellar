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
    associatedtype Body: SContent
    
    @SContentBuilder var body: Self.Body { get }
}
