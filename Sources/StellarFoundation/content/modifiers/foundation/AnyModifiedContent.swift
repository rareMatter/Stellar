//
//  AnyModifiedContent.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

public
protocol AnyModifiedContent {
    var anyContent: AnySContent { get }
    var anySModifier: AnySContentModifier { get }
}

// MARK: - type-erased modified content
extension ModifiedElement: AnyModifiedContent
where Content : SContent, Modifier : SContentModifier {
    
    public var anyContent: AnySContent {
        AnySContent(content)
    }
    
    public var anySModifier: AnySContentModifier {
        AnySContentModifier(modifier)
    }
}
