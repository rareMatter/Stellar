//
//  SPrimitiveContent.swift
//  
//
//  Created by Jesse Spencer on 5/14/21.
//

/// A basic building block to use when composing content.
///
/// The body of primitive content must be determined by a renderer.
protocol SPrimitiveContent: SContent, PrimitiveElement
where Self.Body == Never {}

