//
//  SContentBuilder.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import Foundation

@resultBuilder
public
enum SContentBuilder {}

// MARK: conditionals
public
extension SContentBuilder {
    
    static func buildEither<TrueContent, FalseContent>(first component: TrueContent) -> _SConditionalContent<TrueContent, FalseContent>
    where TrueContent: SContent, FalseContent: SContent {
        .init(storage: .trueContent(component))
    }
    
    static func buildEither<TrueContent, FalseContent>(second component: FalseContent) -> _SConditionalContent<TrueContent, FalseContent>
    where TrueContent: SContent, FalseContent: SContent {
        .init(storage: .falseContent(component))
    }
    
    static func buildOptional<ContentConfiguration>(_ component: ContentConfiguration?) -> _SOptionalContent<ContentConfiguration>
    where ContentConfiguration: SContent {
        if let content = component {
            return _SOptionalContent(storage: .existing(content))
        }
        else {
            return _SOptionalContent(storage: .empty)
        }
    }
    
    static func buildLimitedAvailability<ContentConfiguration>(_ component: ContentConfiguration) -> ContentConfiguration
    where ContentConfiguration: SContent {
        fatalError("Availability checks are not yet supported.")
    }
}

// MARK: build blocks
public
extension SContentBuilder {
    
    static func buildBlock() -> SEmptyContent {
        SEmptyContent()
    }
    
    static func buildBlock<ContentConfiguration>(_ content: ContentConfiguration) -> ContentConfiguration {
        content
    }
    
    static func buildBlock<C0,
                           C1>(_ c0: C0,
                               _ c1: C1) -> STupleContent<(C0, C1)>
    where C0: SContent,
          C1: SContent {
              STupleContent(c0, c1)
          }
    
    static func buildBlock<C0,
                           C1,
                           C2>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2) -> STupleContent<(C0, C1, C2)>
    where C0: SContent, C1: SContent, C2: SContent {
        STupleContent(c0, c1, c2)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3) -> STupleContent<(C0, C1, C2, C3)>
    where C0: SContent, C1: SContent, C2: SContent, C3: SContent {
        STupleContent(c0, c1, c2, c3)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4) -> STupleContent<(C0, C1, C2, C3, C4)>
    where C0: SContent, C1: SContent, C2: SContent, C3: SContent, C4: SContent {
        STupleContent(c0, c1, c2, c3, c4)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4,
                               _ c5: C5) -> STupleContent<(C0, C1, C2, C3, C4, C5)>
    where C0: SContent, C1: SContent, C2: SContent, C3: SContent, C4: SContent, C5: SContent {
        STupleContent(c0, c1, c2, c3, c4, c5)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5,
                           C6>(
                            _ c0: C0,
                            _ c1: C1,
                            _ c2: C2,
                            _ c3: C3,
                            _ c4: C4,
                            _ c5: C5,
                            _ c6: C6) -> STupleContent<(C0, C1, C2, C3, C4, C5, C6)>
    where C0: SContent, C1: SContent, C2: SContent, C3: SContent, C4: SContent, C5: SContent, C6: SContent {
        STupleContent(c0, c1, c2, c3, c4, c5, c6)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5,
                           C6,
                           C7>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4,
                               _ c5: C5,
                               _ c6: C6,
                               _ c7: C7) -> STupleContent<(C0, C1, C2, C3, C4, C5, C6, C7)>
    where C0: SContent, C1: SContent, C2: SContent, C3: SContent, C4: SContent, C5: SContent, C6: SContent, C7: SContent {
        STupleContent(c0, c1, c2, c3, c4, c5, c6, c7)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5,
                           C6,
                           C7,
                           C8>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4,
                               _ c5: C5,
                               _ c6: C6,
                               _ c7: C7,
                               _ c8: C8) -> STupleContent<(C0, C1, C2, C3, C4, C5, C6, C7, C8)>
    where C0: SContent, C1: SContent, C2: SContent, C3: SContent, C4: SContent, C5: SContent, C6: SContent, C7: SContent, C8: SContent {
        STupleContent(c0, c1, c2, c3, c4, c5, c6, c7, c8)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5,
                           C6,
                           C7,
                           C8,
                           C9>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4,
                               _ c5: C5,
                               _ c6: C6,
                               _ c7: C7,
                               _ c8: C8,
                               _ c9: C9) -> STupleContent<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>
    where C0: SContent, C1: SContent, C2: SContent, C3: SContent, C4: SContent, C5: SContent, C6: SContent, C7: SContent, C8: SContent, C9: SContent {
        STupleContent(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
    }
}
