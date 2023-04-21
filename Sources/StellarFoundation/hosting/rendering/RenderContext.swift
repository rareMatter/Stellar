//
//  RenderContext.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

import OrderedCollections
import utilities

/// Contextual data for performing rendering.
struct RenderContext {
    // TODO: Need transaction.
    let parentRenderedElement: Reference<PlatformContent>
    let modifiers: OrderedSet<ModifierHashProxy>
}
