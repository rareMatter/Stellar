//
//  AnySContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

import Foundation

struct AnySContentModifier: SContentModifier {
    
    /// The type of the wrapped `SContentModifier`.
    /// This is used in order to cast the `_SContentModifierProxy<>` to the correct type.
    private
    let contentModifierType: Any.Type
    
    private
    let bodyProvider: (Content) -> AnySContent
    
    init<Modifier>(_ erasingModifier: Modifier)
    where Modifier : SContentModifier {
        if let anyModifier = erasingModifier as? AnySContentModifier {
            self = anyModifier
        }
        else {
            contentModifierType = Modifier.self
            bodyProvider = { contentModifierProxy in
                guard let contentModifierProxy = contentModifierProxy as? Modifier.Content else {
                    fatalError()
                }
                return AnySContent(erasingModifier
                                    .body(content: contentModifierProxy))
            }
        }
    }
    
    func body(content: Content) -> AnySContent {
        bodyProvider(content)
    }
}
