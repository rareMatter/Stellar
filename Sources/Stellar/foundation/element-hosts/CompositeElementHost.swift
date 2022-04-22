//
//  CompositeElementHost.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation
import Combine

/// A host which is capable of storing dynamic properties declared by the composite content.
///
///
class CompositeElementHost: ElementHost {
    
    let parentPlatformContent: PlatformContent?
    
    /// Values taken from state property declarations of the composite element.
    var storage = [Any]()
    
    /// Subscriptions to transient, class-constrained property declarations of the composite element.
    ///
    /// - Important: These subscriptions are not owned by the composite element and therefore may be removed during rendering.
    var transientSubscriptions = [AnyCancellable]()
    
    /// Subscriptions to non-transient, class-constrained, state property declarations of the composite element.
    ///
    /// - Note: These subscriptions are persistent and only removed when the composite element containing them is removed.
    var persistentSubsciptions = [AnyCancellable]()
    
    init(content: AnySContent,
         parentPlatformContent: PlatformContent?,
         parent: ElementHost?) {
        self.parentPlatformContent = parentPlatformContent
        
        super.init(hostedElement: .content(content), parent: parent)
    }
}
extension CompositeElementHost: Hashable {
    
    /// Compares equal on instance equality.
    static func == (lhs: CompositeElementHost, rhs: CompositeElementHost) -> Bool {
        lhs === rhs
    }
    
    /// Hashed using object identity.
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
