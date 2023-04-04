//
//  CompositeElementState.swift
//  
//
//  Created by Jesse Spencer on 2/20/23.
//

import Combine

/// Hosts state storage and management for an element.
struct CompositeElementState {
    
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
}
