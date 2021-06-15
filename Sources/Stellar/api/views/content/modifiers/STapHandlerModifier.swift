//
//  STapHandlerModifier.swift
//  
//
//  Created by Jesse Spencer on 6/7/21.
//

import Foundation

struct STapHandlerModifier: SContentModifier {
    typealias Body = Never
    let tapHandler: () -> Void
}

public
extension SContent {
    func onTap(_ handler: @escaping () -> Void) -> some SContent {
        modifier(STapHandlerModifier(tapHandler: handler))
    }
}
