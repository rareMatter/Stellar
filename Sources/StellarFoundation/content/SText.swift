//
//  SText.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

public
struct SText: SPrimitiveContent {
    public
    let string: String
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
public
extension SText {
    
    init<S>(_ content: S)
    where S : StringProtocol {
        self.string = String(content)
    }
}
