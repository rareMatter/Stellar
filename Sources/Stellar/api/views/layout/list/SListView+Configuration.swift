//
//  SListView+Configuration.swift
//  
//
//  Created by Jesse Spencer on 3/27/21.
//

import Foundation

public
extension SListView {
    
    func initialFirstResponder(_ handler: @escaping InitialFirstResponderHandler) -> Self {
        var modified = self
        modified.initialFirstResponderHandler = handler
        return modified
    }
    func subsequentFirstResponder(_ handler: @escaping SubsequentFirstResponderHandler) -> Self {
        var modified = self
        modified.subsequentFirstResponderHandler = handler
        return modified
    }
}
