//
//  _SDisablingContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

import Foundation

public
struct _SDisablingContentModifier: SContentModifier {
    
    let isDisabled: Bool
    
    public
    func body(content: Content) -> Never {
        fatalError()
    }
}

public
extension SContent {
    
    func disabled(_ state: Bool) -> some SContent {
        modifier(_SDisablingContentModifier(isDisabled: state))
    }
}
