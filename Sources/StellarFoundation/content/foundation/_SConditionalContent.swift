//
//  _SConditionalContent.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

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
    
    var children: [any SContent] {
        switch storage {
            case .trueContent(let content):
                return [content]
            case .falseContent(let content):
                return [content]
        }
    }
}
