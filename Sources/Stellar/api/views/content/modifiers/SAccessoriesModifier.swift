//
//  SAccessoriesModifier.swift
//  
//
//  Created by Jesse Spencer on 6/7/21.
//

import Foundation
// TODO: Obsoleted. Remove this.
struct SAccessoriesModifier<Accessory>: SContentModifier {
    typealias Body = Never
    let accessories: [Accessory]
}

public
extension SContent {
    func accessories<Accessory>(_ accessories: [Accessory]) -> some SContent {
        modifier(SAccessoriesModifier(accessories: accessories))
    }
}
