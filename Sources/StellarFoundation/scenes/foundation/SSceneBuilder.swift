//
//  SSceneBuilder.swift
//  
//
//  Created by Jesse Spencer on 11/1/22.
//

import Foundation

@resultBuilder
public
enum SSceneBuilder {
    
    static func buildBlock<Content : SScene>(_ content: Content) -> some SScene {
        content
    }
    
    static func buildBlock<C0,
                           C1>(_ c0: C0,
                               _ c1: C1) -> some SScene
    where C0: SScene,
          C1: SScene {
              STupleScene(c0, c1)
          }
    
    static func buildBlock<C0,
                           C1,
                           C2>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2) -> some SScene
    where C0: SScene, C1: SScene, C2: SScene {
        STupleScene(c0, c1, c2)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3) -> STupleScene<(C0, C1, C2, C3)>
    where C0: SScene, C1: SScene, C2: SScene, C3: SScene {
        STupleScene(c0, c1, c2, c3)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4) -> STupleScene<(C0, C1, C2, C3, C4)>
    where C0: SScene, C1: SScene, C2: SScene, C3: SScene, C4: SScene {
        STupleScene(c0, c1, c2, c3, c4)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4,
                               _ c5: C5) -> STupleScene<(C0, C1, C2, C3, C4, C5)>
    where C0: SScene, C1: SScene, C2: SScene, C3: SScene, C4: SScene, C5: SScene {
        STupleScene(c0, c1, c2, c3, c4, c5)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5,
                           C6>(
                            _ c0: C0,
                            _ c1: C1,
                            _ c2: C2,
                            _ c3: C3,
                            _ c4: C4,
                            _ c5: C5,
                            _ c6: C6) -> STupleScene<(C0, C1, C2, C3, C4, C5, C6)>
    where C0: SScene, C1: SScene, C2: SScene, C3: SScene, C4: SScene, C5: SScene, C6: SScene {
        STupleScene(c0, c1, c2, c3, c4, c5, c6)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5,
                           C6,
                           C7>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4,
                               _ c5: C5,
                               _ c6: C6,
                               _ c7: C7) -> STupleScene<(C0, C1, C2, C3, C4, C5, C6, C7)>
    where C0: SScene, C1: SScene, C2: SScene, C3: SScene, C4: SScene, C5: SScene, C6: SScene, C7: SScene {
        STupleScene(c0, c1, c2, c3, c4, c5, c6, c7)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5,
                           C6,
                           C7,
                           C8>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4,
                               _ c5: C5,
                               _ c6: C6,
                               _ c7: C7,
                               _ c8: C8) -> STupleScene<(C0, C1, C2, C3, C4, C5, C6, C7, C8)>
    where C0: SScene, C1: SScene, C2: SScene, C3: SScene, C4: SScene, C5: SScene, C6: SScene, C7: SScene, C8: SScene {
        STupleScene(c0, c1, c2, c3, c4, c5, c6, c7, c8)
    }
    
    static func buildBlock<C0,
                           C1,
                           C2,
                           C3,
                           C4,
                           C5,
                           C6,
                           C7,
                           C8,
                           C9>(_ c0: C0,
                               _ c1: C1,
                               _ c2: C2,
                               _ c3: C3,
                               _ c4: C4,
                               _ c5: C5,
                               _ c6: C6,
                               _ c7: C7,
                               _ c8: C8,
                               _ c9: C9) -> STupleScene<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>
    where C0: SScene, C1: SScene, C2: SScene, C3: SScene, C4: SScene, C5: SScene, C6: SScene, C7: SScene, C8: SScene, C9: SScene {
        STupleScene(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
    }
}
