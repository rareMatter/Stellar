//
//  SEmptyContent.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

public
struct SEmptyContent: SPrimitiveContent {
    @inlinable
    public init() {}
    @inlinable
    public var body: Never { fatalError() }
    @inlinable
    public var _body: CompositeElement { fatalError() }
}
