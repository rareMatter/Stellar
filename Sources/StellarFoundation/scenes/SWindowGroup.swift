//
//  SWindowGroup.swift
//  
//
//  Created by Jesse Spencer on 11/8/22.
//

public
struct SWindowGroup<C>: PrimitiveScene, AnySWindowGroup
where C : SContent {
    
    let content: C
    
    public
    init(@SContentBuilder content: () -> C) {
        self.content = content()
    }
}

public
protocol AnySWindowGroup {}
