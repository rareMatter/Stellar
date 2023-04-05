//
//  RenderContext.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

import OrderedCollections

// TODO: Render context will be provided to hosts during renderings, either the initial render or each update. It should be stored in hosts or in the node which stores a host.
struct RenderContext {
    
    // TODO: Modifiers are currently being inherited without discretion. Perhaps modifiers which are not heritable should be flagged, filtered, or both in order to avoid handing modifiers, which should not be rendered, to child nodes.
    let modifiers: OrderedSet<ModifierHashProxy>
}
