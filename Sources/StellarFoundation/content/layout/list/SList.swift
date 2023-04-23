//
//  SList.swift
//  
//
//  Created by Jesse Spencer on 2/28/21.
//

public
struct SList<Content, Selection>: SPrimitiveContent
where Content : SContent, Selection : Hashable {
    
    /// The content of this list.
    let content: Content
    /// The selection, if existing, in the list.
    let selection: _Selection?
    
    enum _Selection {
        case one(SBinding<Selection>)
        case many(SBinding<Set<Selection>>)
    }
}
extension SList: _SContentContainer {
    public
    var children: [any SContent] { [content] }
}

public
protocol AnyList {
    var selectionSet: Set<AnyHashable> { get }
}
extension SList: AnyList {
    
    public
    var selectionSet: Set<AnyHashable> {
        if let selection = self.selection {
            switch selection {
            case let .one(binding):
                return .init(arrayLiteral: .init(binding.wrappedValue))
            case let .many(binding):
                return binding.wrappedValue
            }
        }
        else { return .init() }
    }
}
