//
//  SContentBuilder.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

@resultBuilder
public
enum SContentBuilder {}

// MARK: conditionals
public
extension SContentBuilder {
    
    static func buildEither<TrueContent, FalseContent>(first component: TrueContent) -> some SContent
    where TrueContent: SContent, FalseContent: SContent {
        _SConditionalContent<TrueContent, FalseContent>(storage: .trueContent(component))
    }
    
    static func buildEither<TrueContent, FalseContent>(second component: FalseContent) -> some SContent
    where TrueContent: SContent, FalseContent: SContent {
        _SConditionalContent<TrueContent, FalseContent>(storage: .falseContent(component))
    }
    
    static func buildOptional<C>(_ component: C?) -> some SContent
    where C: SContent {
        if let content = component {
            return _SOptionalContent(storage: .existing(content))
        }
        else {
            return _SOptionalContent<C>(storage: .empty)
        }
    }
    
    static func buildLimitedAvailability<C>(_ component: C) -> some SContent
    where C: SContent {
        return fatalError("Availability checks are not yet supported.")
    }
}

// MARK: build blocks
public
extension SContentBuilder {
    
    static func buildBlock() -> some SContent {
        SEmptyContent()
    }
    
    static func buildBlock<C>(_ content: C) -> some SContent
    where C : SContent {
        content
    }
    
    static func buildBlock(_ c0: some SContent,
                           _ c1: some SContent) -> some SContent {
        STupleContent(c0, c1)
    }
    
    static func buildBlock(_ c0: some SContent,
                           _ c1: some SContent,
                           _ c2: some SContent) -> some SContent {
        STupleContent(c0, c1, c2)
    }
    
    static func buildBlock(_ c0: some SContent,
                           _ c1: some SContent,
                           _ c2: some SContent,
                           _ c3: some SContent) -> some SContent {
        STupleContent(c0, c1, c2, c3)
    }
    
    static func buildBlock(_ c0: some SContent,
                           _ c1: some SContent,
                           _ c2: some SContent,
                           _ c3: some SContent,
                           _ c4: some SContent) -> some SContent {
        STupleContent(c0, c1, c2, c3, c4)
    }
    
    static func buildBlock(_ c0: some SContent,
                           _ c1: some SContent,
                           _ c2: some SContent,
                           _ c3: some SContent,
                           _ c4: some SContent,
                           _ c5: some SContent) -> some SContent {
        STupleContent(c0, c1, c2, c3, c4, c5)
    }
    
    static func buildBlock(_ c0: some SContent,
                           _ c1: some SContent,
                           _ c2: some SContent,
                           _ c3: some SContent,
                           _ c4: some SContent,
                           _ c5: some SContent,
                           _ c6: some SContent) -> some SContent {
        STupleContent(c0, c1, c2, c3, c4, c5, c6)
    }
    
    static func buildBlock(_ c0: some SContent,
                           _ c1: some SContent,
                           _ c2: some SContent,
                           _ c3: some SContent,
                           _ c4: some SContent,
                           _ c5: some SContent,
                           _ c6: some SContent,
                           _ c7: some SContent) -> some SContent {
        STupleContent(c0, c1, c2, c3, c4, c5, c6, c7)
    }
    
    static func buildBlock(_ c0: some SContent,
                           _ c1: some SContent,
                           _ c2: some SContent,
                           _ c3: some SContent,
                           _ c4: some SContent,
                           _ c5: some SContent,
                           _ c6: some SContent,
                           _ c7: some SContent,
                           _ c8: some SContent) -> some SContent {
        STupleContent(c0, c1, c2, c3, c4, c5, c6, c7, c8)
    }
    
    static func buildBlock(_ c0: some SContent,
                           _ c1: some SContent,
                           _ c2: some SContent,
                           _ c3: some SContent,
                           _ c4: some SContent,
                           _ c5: some SContent,
                           _ c6: some SContent,
                           _ c7: some SContent,
                           _ c8: some SContent,
                           _ c9: some SContent) -> some SContent {
        STupleContent(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
    }
}
