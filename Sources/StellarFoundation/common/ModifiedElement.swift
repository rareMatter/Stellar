//
//  ModifiedElement.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

public
struct ModifiedElement<Content, Modifier> {
    public typealias Body = Never
    public let content: Content
    public let modifier: Modifier
    
    public
    init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}

// MARK: Type-erased recognition
public
protocol AnyModifiedElement {}
extension ModifiedElement: AnyModifiedElement {}

// MARK: content modification function
public
extension SContent {
    
    func modifier<T>(_ modifier: T) -> ModifiedElement<Self, T> {
        .init(content: self, modifier: modifier)
    }
}
