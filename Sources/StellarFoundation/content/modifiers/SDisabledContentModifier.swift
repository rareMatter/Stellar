//
//  SDisabledContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

public
struct SDisabledContentModifier: SContentModifier {
    public typealias Body = Never
    public let isDisabled: Bool
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
