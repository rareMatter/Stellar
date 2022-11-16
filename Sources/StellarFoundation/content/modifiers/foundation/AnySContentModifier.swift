//
//  AnySContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

import Foundation

// FIXME: Temp public.
public
struct AnySContentModifier: SContentModifier {
    
    /// The type of the wrapped `SContentModifier`.
    let type: Any.Type
    
    let typeConstructorName: String
    
    /// The type-erased modifier.
    let modifier: Any
    
    /// The type of the `body` of the wrapped `SContentModifier`.
    let bodyType: Any.Type
    
    private
    let bodyProvider: (Content) -> AnySContent
    
    init<Modifier>(_ erasingModifier: Modifier)
    where Modifier : SContentModifier {
        if let anyModifier = erasingModifier as? AnySContentModifier {
            self = anyModifier
        }
        else {
            type = Modifier.self
            typeConstructorName = StellarFoundation.typeConstructorName(Modifier.self)
            modifier = erasingModifier
            bodyType = Modifier.Body.self
            bodyProvider = { contentModifierProxy in
                guard let modifier = contentModifierProxy.modifier.modifier as? Modifier else { fatalError() }
                let proxy = _SContentModifierProxy(modifier: modifier, content: contentModifierProxy.content)
                return AnySContent(erasingModifier
                                    .body(content: proxy))
            }
        }
    }
    
    // FIXME: Temp public.
    public func body(content: Content) -> AnySContent {
        bodyProvider(content)
    }
}
extension AnySContentModifier: Equatable, Hashable {
    
    public static func ==(lhs: AnySContentModifier, rhs: AnySContentModifier) -> Bool {
        lhs.typeConstructorName == rhs.typeConstructorName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(typeConstructorName)
    }
}
