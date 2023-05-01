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
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}

extension _SOptionalContent: _SContentContainer {
    var children: [any SContent] {
        switch storage {
            case let .existing(content):
                return [content]
            default:
                return []
        }
    }
}
