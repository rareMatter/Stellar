//
//  RenderOutput.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

import OrderedCollections

public
struct RenderOutput {
    // TODO: Need preference store here?
    let renderedElement: PlatformContent?
    let modifiers: OrderedSet<ModifierHashProxy>?
    let children: [CompositeElement]
}
