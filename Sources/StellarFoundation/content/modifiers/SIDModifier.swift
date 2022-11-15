//
//  SIDModifier.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Foundation

public
extension SContent {
    
    func id<ID>(_ id: ID) -> some SContent
    where ID: Hashable {
        SIdentifiableContent(self, id: id)
    }
}
