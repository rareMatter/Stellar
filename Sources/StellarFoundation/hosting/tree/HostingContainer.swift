//
//  HostingContainer.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

import OrderedCollections
import utilities

// TODO: Modifiers are currently being inherited without discretion. Perhaps modifiers which are not heritable should be flagged, filtered, or both in order to avoid handing modifiers, which should not be rendered, to child nodes.
/// A container for a host and related data.
///
/// This container is the storage object for nodes of the `Host Tree`.
struct HostingContainer {
    
    var host: _Host
    
    /// Modifiers to be applied during rendering of this host.
    ///
    /// These modifiers are inherited from ancestor hosts and combined with any modifiers produced by this host.
    let inheritedModifiers: Reference<OrderedSet<ModifierHashProxy>>
    
    /// The parent rendered element to be provided when rendering this host.
    let parentRenderedElement: Reference<PlatformContent>
    
    // TODO: Need environment values.
    // TODO: Need view traits.
}
