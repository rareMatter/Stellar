//
//  STupleScene.swift
//  
//
//  Created by Jesse Spencer on 11/1/22.
//

struct STupleScene<T>: PrimitiveScene {
    let value: T
    private let _children: [any SScene]
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
// MARK: tuple initializers
extension STupleScene {

    init(_ v: T)
    where T : SScene {
        self.value = v
        self._children = [v]
    }
    
    init<T1 : SScene,
         T2 : SScene>(_ v1: T1,
                      _ v2: T2)
    where T == (T1, T2) {
        self.value = (v1, v2)
        self._children = [v1, v2]
    }
    
    init<T1 : SScene,
         T2 : SScene,
         T3 : SScene>(_ v1: T1,
                      _ v2: T2,
                      _ v3: T3)
    where T == (T1, T2, T3) {
        self.value = (v1, v2, v3)
        self._children = [v1, v2, v3]
    }
    
    init<T1 : SScene,
         T2 : SScene,
         T3 : SScene,
         T4 : SScene>(_ v1: T1,
                      _ v2: T2,
                      _ v3: T3,
                      _ v4: T4)
    where T == (T1, T2, T3, T4) {
        self.value = (v1, v2, v3, v4)
        self._children = [v1, v2, v3, v4]
    }
    
    init<T1 : SScene,
         T2 : SScene,
         T3 : SScene,
         T4 : SScene,
         T5 : SScene>(_ v1: T1,
                      _ v2: T2,
                      _ v3: T3,
                      _ v4: T4,
                      _ v5: T5)
    where T == (T1, T2, T3, T4, T5) {
        self.value = (v1, v2, v3, v4, v5)
        self._children = [v1, v2, v3, v4, v5]
    }
    
    init<T1 : SScene,
         T2 : SScene,
         T3 : SScene,
         T4 : SScene,
         T5 : SScene,
         T6 : SScene>(_ v1: T1,
                      _ v2: T2,
                      _ v3: T3,
                      _ v4: T4,
                      _ v5: T5,
                      _ v6: T6)
    where T == (T1, T2, T3, T4, T5, T6) {
        self.value = (v1, v2, v3, v4, v5, v6)
        self._children = [v1, v2, v3, v4, v5, v6]
    }
    
    init<T1 : SScene,
         T2 : SScene,
         T3 : SScene,
         T4 : SScene,
         T5 : SScene,
         T6 : SScene,
         T7 : SScene>(_ v1: T1,
                      _ v2: T2,
                      _ v3: T3,
                      _ v4: T4,
                      _ v5: T5,
                      _ v6: T6,
                      _ v7: T7)
    where T == (T1, T2, T3, T4, T5, T6, T7) {
        self.value = (v1, v2, v3, v4, v5, v6, v7)
        self._children = [v1, v2, v3, v4, v5, v6, v7]
    }
    
    init<T1 : SScene,
         T2 : SScene,
         T3 : SScene,
         T4 : SScene,
         T5 : SScene,
         T6 : SScene,
         T7 : SScene,
         T8 : SScene>(_ v1: T1,
                      _ v2: T2,
                      _ v3: T3,
                      _ v4: T4,
                      _ v5: T5,
                      _ v6: T6,
                      _ v7: T7,
                      _ v8: T8)
    where T == (T1, T2, T3, T4, T5, T6, T7, T8) {
        self.value = (v1, v2, v3, v4, v5, v6, v7, v8)
        self._children = [v1, v2, v3, v4, v5, v6, v7, v8]
    }
    
    init<T1 : SScene,
         T2 : SScene,
         T3 : SScene,
         T4 : SScene,
         T5 : SScene,
         T6 : SScene,
         T7 : SScene,
         T8 : SScene,
         T9 : SScene>(_ v1: T1,
                      _ v2: T2,
                      _ v3: T3,
                      _ v4: T4,
                      _ v5: T5,
                      _ v6: T6,
                      _ v7: T7,
                      _ v8: T8,
                      _ v9: T9)
    where T == (T1, T2, T3, T4, T5, T6, T7, T8, T9) {
        self.value = (v1, v2, v3, v4, v5, v6, v7, v8, v9)
        self._children = [v1, v2, v3, v4, v5, v6, v7, v8, v9]
    }
    
    init<T1 : SScene,
         T2 : SScene,
         T3 : SScene,
         T4 : SScene,
         T5 : SScene,
         T6 : SScene,
         T7 : SScene,
         T8 : SScene,
         T9 : SScene,
         T10 : SScene>(_ v1: T1,
                       _ v2: T2,
                       _ v3: T3,
                       _ v4: T4,
                       _ v5: T5,
                       _ v6: T6,
                       _ v7: T7,
                       _ v8: T8,
                       _ v9: T9,
                       _ v10: T10)
    where T == (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) {
        self.value = (v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
        self._children = [v1, v2, v3, v4, v5, v6, v7, v8, v9, v10]
    }
}
// MARK: GroupScene
extension STupleScene: GroupScene {
    var children: [any SScene] { _children }
}
