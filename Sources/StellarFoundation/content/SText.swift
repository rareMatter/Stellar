//
//  SText.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

public
struct SText: SPrimitiveContent {
    let string: String
}
public
extension SText {
    
    init<S>(_ content: S)
    where S : StringProtocol {
        self.string = String(content)
    }
}
