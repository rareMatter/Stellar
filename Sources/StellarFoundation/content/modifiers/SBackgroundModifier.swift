//
//  SBackgroundModifier.swift
//  
//
//  Created by Jesse Spencer on 11/19/21.
//

struct SBackgroundModifier<Background>: SContentModifier
where Background : SContent {
    // TODO: ...
//    var environment: EnvironmentValues
    var background: Background
    var alignment: SAlignment = .center
    
    func body(content: Content) -> some SContent {
        SZStack(alignment: alignment) {
            content
            background
        }
    }
}
extension SBackgroundModifier: Equatable
where Background : Equatable {
    static
    func ==(lhs: SBackgroundModifier,
            rhs: SBackgroundModifier) -> Bool {
        lhs.background == rhs.background
    }
}

public
extension SContent {
    
    func background<Background>(_ background: Background,
                                alignment: SAlignment = .center) -> some SContent
    where Background : SContent {
        modifier(SBackgroundModifier(background: background,
                                     alignment: alignment))
    }
    
    @inlinable
    func background<V>(alignment: SAlignment = .center,
                       @SContentBuilder content: () -> V) -> some SContent
    where V : SContent {
        background(content(),
                   alignment: alignment)
    }
}
