//
//  AnySModifiedContent.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

import Foundation

// FIXME: Temp public.
public
protocol AnySModifiedContent {
    var anyContent: AnySContent { get }
    var anySModifier: AnySContentModifier { get }
}

// MARK: - type-erased modified content
extension SModifiedContent: AnySModifiedContent
where Content : SContent, Modifier : SContentModifier {
    
    public var anyContent: AnySContent {
        AnySContent(content)
    }
    
    public var anySModifier: AnySContentModifier {
        AnySContentModifier(modifier)
    }
}
