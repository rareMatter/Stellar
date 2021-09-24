//
//  SContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

import Foundation

public
protocol SContentModifier {
    typealias Content = _SContentModifierProxy<Self>
    associatedtype Body: SContent
    func body(content: Content) -> Self.Body
}

public
struct _SContentModifierProxy<Modifier>: SContent
where Modifier : SContentModifier {
    let modifier: Modifier
    let content: AnySContent
    
    public var body: AnySContent {
        content
    }
}

// MARK: - default primitive body
extension SContentModifier
where Body == Never {

    func body(content: Content) -> Self.Body {
        primitiveBodyFailure(withType: String(reflecting: Self.self))
    }
}
