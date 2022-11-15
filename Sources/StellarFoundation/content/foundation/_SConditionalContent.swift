//
//  _SConditionalContent.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import Foundation

public
struct _SConditionalContent<TrueContent, FalseContent>: SPrimitiveContent
where TrueContent: SContent, FalseContent: SContent {
    
    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }
    
    let storage: Storage
}

extension _SConditionalContent: _SContentContainer {
    
    var children: [AnySContent] {
        switch storage {
            case .trueContent(let content):
                return [AnySContent(content)]
            case .falseContent(let content):
                return [AnySContent(content)]
        }
    }
}
