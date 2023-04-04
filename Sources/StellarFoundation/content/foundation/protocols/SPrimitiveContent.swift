//
//  SPrimitiveContent.swift
//  
//
//  Created by Jesse Spencer on 5/14/21.
//

import Foundation

/// A basic building block to use when composing content.
///
/// The body of primitive content must be determined by a renderer.
protocol SPrimitiveContent: SContent, PrimitiveElement
where Self.Body == Never {}

// MARK: default primitive body
extension SContent
where Body == Never {
    
    public
    var body: Never {
        primitiveBodyFailure(withType: String(reflecting: Self.self))
    }
}

/// A function to be called from body properties which have a Never type and don't produce content. Provide a type description to be printed with the error message.
func primitiveBodyFailure(withType description: String) -> Never {
    fatalError("\(description) is a primitive type and its body can't be called.")
}
