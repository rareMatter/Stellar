//
//  ModifiedElement.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

// TODO: This type should probably be renamed to something like ModifierBox.
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
protocol AnyModifiedElement: PrimitiveElement {
    var anyElement: CompositeElement { get }
    var anyModifier: ElementModifier { get }
}
extension ModifiedElement: AnyModifiedElement
where Content : CompositeElement, Modifier : ElementModifier {
    
    public
    var anyElement: CompositeElement {
        content
    }
    
    public
    var anyModifier: ElementModifier {
        modifier
    }
}

// MARK: content modification function
public
extension SContent {
    
    func modifier<T>(_ modifier: T) -> ModifiedElement<Self, T> {
        .init(content: self, modifier: modifier)
    }
}
