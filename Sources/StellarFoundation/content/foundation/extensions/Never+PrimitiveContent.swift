//
//  Never+PrimitiveContent.swift
//  
//
//  Created by Jesse Spencer on 5/14/21.
//

extension Never: SPrimitiveContent {
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
