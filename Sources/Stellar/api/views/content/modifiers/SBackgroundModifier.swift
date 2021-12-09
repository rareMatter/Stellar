//
//  SBackgroundModifier.swift
//  
//
//  Created by Jesse Spencer on 11/19/21.
//

import Foundation
import SwiftUI

struct SBackgroundModifier<Background>: SContentModifier
where Background : SContent {
    // TODO: ...
//    var environment: EnvironmentValues
    var background: Background
    var alignment: SAlignment = .center
    
    func body(content: Content) -> some SContent {
        BackgroundModifierContainer(content: content,
                                    background: background,
                                    alignment: alignment)
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

/// A type which can appear in the content hierarchy.
struct BackgroundModifierContainer<Content, Background>: SPrimitiveContent
where Content : SContent, Background : SContent {
    let content: Content
    let background: Background
    let alignment: SAlignment
}
