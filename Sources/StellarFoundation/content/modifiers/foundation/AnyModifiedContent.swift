//
//  AnyModifiedContent.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

public
protocol AnyModifiedContent {
    var anyContent: any SContent { get }
    var anySModifier: any SContentModifier { get }
}

// MARK: - type-erased modified content
extension ModifiedElement: AnyModifiedContent
where Content : SContent, Modifier : SContentModifier {
    
    public var anyContent: any SContent {
        content
    }
    
    public var anySModifier: any SContentModifier {
        modifier
    }
}
