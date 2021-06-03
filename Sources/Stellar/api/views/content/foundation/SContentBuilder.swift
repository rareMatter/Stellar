//
//  SContentBuilder.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import Foundation

@resultBuilder
public
enum SContentBuilder {
    
    public static func buildBlock() -> SEmptyContent {
        SEmptyContent()
    }
    
    public static func buildBlock<ContentConfiguration>(_ content: ContentConfiguration) -> ContentConfiguration {
        content
    }
    
    public static func buildEither<TrueContent, FalseContent>(first component: TrueContent) -> _SConditionalContent<TrueContent, FalseContent>
    where TrueContent: SContent, FalseContent: SContent {
        .init(storage: .trueContent(component))
    }
    
    public static func buildEither<TrueContent, FalseContent>(second component: FalseContent) -> _SConditionalContent<TrueContent, FalseContent>
    where TrueContent: SContent, FalseContent: SContent {
        .init(storage: .falseContent(component))
    }
    
    public static func buildOptional<ContentConfiguration>(_ component: ContentConfiguration?) -> _SOptionalContent<ContentConfiguration>
    where ContentConfiguration: SContent {
        if let content = component {
            return _SOptionalContent(storage: .existing(content))
        }
        else {
            return _SOptionalContent(storage: .empty)
        }
    }
    
    public static func buildLimitedAvailability<ContentConfiguration>(_ component: ContentConfiguration) -> ContentConfiguration
    where ContentConfiguration: SContent {
        fatalError("Availability checks are not yet supported.")
    }
}
