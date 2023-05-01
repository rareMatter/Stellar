//
//  SSceneBuilder.swift
//  
//
//  Created by Jesse Spencer on 11/1/22.
//

@resultBuilder
public
enum SSceneBuilder {
    
    // TODO: When attempting to use `some SScene` as the parameter and return type, building fails at use sites such as `Never` body types with only a call to `fatalError()`.
    static func buildBlock<C>(_ content: C) -> C
    where C : SScene {
        content
    }
    
    static func buildBlock(_ c0: some SScene,
                           _ c1: some SScene) -> some SScene {
        STupleScene(c0, c1)
    }
    
    static func buildBlock(_ c0: some SScene,
                           _ c1: some SScene,
                           _ c2: some SScene) -> some SScene {
        STupleScene(c0, c1, c2)
    }
    
    static func buildBlock(_ c0: some SScene,
                           _ c1: some SScene,
                           _ c2: some SScene,
                           _ c3: some SScene) -> some SScene {
        STupleScene(c0, c1, c2, c3)
    }
    
    static func buildBlock(_ c0: some SScene,
                           _ c1: some SScene,
                           _ c2: some SScene,
                           _ c3: some SScene,
                           _ c4: some SScene) -> some SScene {
        STupleScene(c0, c1, c2, c3, c4)
    }
    
    static func buildBlock(_ c0: some SScene,
                           _ c1: some SScene,
                           _ c2: some SScene,
                           _ c3: some SScene,
                           _ c4: some SScene,
                           _ c5: some SScene) -> some SScene {
        STupleScene(c0, c1, c2, c3, c4, c5)
    }
    
    static func buildBlock(_ c0: some SScene,
                           _ c1: some SScene,
                           _ c2: some SScene,
                           _ c3: some SScene,
                           _ c4: some SScene,
                           _ c5: some SScene,
                           _ c6: some SScene) -> some SScene {
        STupleScene(c0, c1, c2, c3, c4, c5, c6)
    }
    
    static func buildBlock(_ c0: some SScene,
                           _ c1: some SScene,
                           _ c2: some SScene,
                           _ c3: some SScene,
                           _ c4: some SScene,
                           _ c5: some SScene,
                           _ c6: some SScene,
                           _ c7: some SScene) -> some SScene {
        STupleScene(c0, c1, c2, c3, c4, c5, c6, c7)
    }
    
    static func buildBlock(_ c0: some SScene,
                           _ c1: some SScene,
                           _ c2: some SScene,
                           _ c3: some SScene,
                           _ c4: some SScene,
                           _ c5: some SScene,
                           _ c6: some SScene,
                           _ c7: some SScene,
                           _ c8: some SScene) -> some SScene {
        STupleScene(c0, c1, c2, c3, c4, c5, c6, c7, c8)
    }
    
    static func buildBlock(_ c0: some SScene,
                           _ c1: some SScene,
                           _ c2: some SScene,
                           _ c3: some SScene,
                           _ c4: some SScene,
                           _ c5: some SScene,
                           _ c6: some SScene,
                           _ c7: some SScene,
                           _ c8: some SScene,
                           _ c9: some SScene) -> some SScene {
        STupleScene(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
    }
}
