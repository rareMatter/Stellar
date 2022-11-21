//
//  SDisabledContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

struct SDisabledContentModifier: SContentModifier {
    typealias Body = Never
    let isDisabled: Bool
}

public
extension SContent {
    /// Whether the content should be disabled or not.
    ///
    /// The appearance of disabled content updates to reflect its interactability.
    func disabled(_ state: Bool = true) -> some SContent {
        modifier(SDisabledContentModifier(isDisabled: state))
    }
}
