//
//  RenderOutput.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

struct RenderOutput {
    let renderedElement: PlatformContent?
    let children: [CompositeElement]
    let modifiers: OrderedSet<ModifierHashProxy>
}
