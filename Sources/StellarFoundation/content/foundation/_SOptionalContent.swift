//
//  _SOptionalContent.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

struct _SOptionalContent<OptionalContent>: SPrimitiveContent
where OptionalContent: SContent {
    
    enum Storage {
        case existing(OptionalContent)
        case empty
    }
    
    let storage: Storage
}

extension _SOptionalContent: _SContentContainer {
    var children: [AnySContent] {
        switch storage {
            case let .existing(content):
                return [AnySContent(content)]
            default:
                return []
        }
    }
}
