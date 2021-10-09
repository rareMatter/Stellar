//
//  STupleContent.swift
//  
//
//  Created by Jesse Spencer on 10/5/21.
//

import Foundation

/// `SContent created from a tuple of `SContent` values.
/// This is not intended for direct use in your composed content.
public
struct STupleContent<T>: SPrimitiveContent {
    
    public
    let value: T
    
    let _children: [AnySContent]
    
    public
    init(_ value: T) {
        self.value = value
        _children = []
    }
    
    public
    init(_ value: T,
         children: [AnySContent]) {
        self.value = value
        self._children = children
    }
    
    public
    init<T1: SContent,
         T2: SContent> (_ v1: T1,
                        _ v2: T2)
    where T == (T1, T2) {
        self.value = (v1, v2)
        self._children = [AnySContent(v1),
                          AnySContent(v2)]
    }
    
    init<T1: SContent,
         T2: SContent,
         T3: SContent> (_ v1: T1,
                        _ v2: T2,
                        _ v3: T3)
    where T == (T1, T2, T3) {
        value = (v1, v2, v3)
        _children = [AnySContent(v1),
                     AnySContent(v2),
                     AnySContent(v3)]
    }
    
    init<T1: SContent,
         T2: SContent,
         T3: SContent,
         T4: SContent> (_ v1: T1,
                        _ v2: T2,
                        _ v3: T3,
                        _ v4: T4)
    where T == (T1, T2, T3, T4) {
        value = (v1, v2, v3, v4)
        _children = [AnySContent(v1),
                     AnySContent(v2),
                     AnySContent(v3),
                     AnySContent(v4)]
    }
    
    init<T1: SContent,
         T2: SContent,
         T3: SContent,
         T4: SContent,
         T5: SContent> (_ v1: T1,
                        _ v2: T2,
                        _ v3: T3,
                        _ v4: T4,
                        _ v5: T5)
    where T == (T1, T2, T3, T4, T5) {
        value = (v1, v2, v3, v4, v5)
        _children = [AnySContent(v1),
                     AnySContent(v2),
                     AnySContent(v3),
                     AnySContent(v4),
                     AnySContent(v5)]
    }
    
    init<T1: SContent,
         T2: SContent,
         T3: SContent,
         T4: SContent,
         T5: SContent,
         T6: SContent> (_ v1: T1,
                        _ v2: T2,
                        _ v3: T3,
                        _ v4: T4,
                        _ v5: T5,
                        _ v6: T6)
    where T == (T1, T2, T3, T4, T5, T6) {
        value = (v1, v2, v3, v4, v5, v6)
        _children = [AnySContent(v1),
                     AnySContent(v2),
                     AnySContent(v3),
                     AnySContent(v4),
                     AnySContent(v5),
                     AnySContent(v6)]
    }
    
    init<T1: SContent,
         T2: SContent,
         T3: SContent,
         T4: SContent,
         T5: SContent,
         T6: SContent,
         T7: SContent>(_ v1: T1,
                       _ v2: T2,
                       _ v3: T3,
                       _ v4: T4,
                       _ v5: T5,
                       _ v6: T6,
                       _ v7: T7)
    where T == (T1, T2, T3, T4, T5, T6, T7) {
        value = (v1, v2, v3, v4, v5, v6, v7)
        _children = [
            AnySContent(v1),
            AnySContent(v2),
            AnySContent(v3),
            AnySContent(v4),
            AnySContent(v5),
            AnySContent(v6),
            AnySContent(v7),
        ]
    }
    
    init<T1: SContent,
         T2: SContent,
         T3: SContent,
         T4: SContent,
         T5: SContent,
         T6: SContent,
         T7: SContent,
         T8: SContent>(_ v1: T1,
                       _ v2: T2,
                       _ v3: T3,
                       _ v4: T4,
                       _ v5: T5,
                       _ v6: T6,
                       _ v7: T7,
                       _ v8: T8)
    where T == (T1, T2, T3, T4, T5, T6, T7, T8) {
        value = (v1, v2, v3, v4, v5, v6, v7, v8)
        _children = [
            AnySContent(v1),
            AnySContent(v2),
            AnySContent(v3),
            AnySContent(v4),
            AnySContent(v5),
            AnySContent(v6),
            AnySContent(v7),
            AnySContent(v8),
        ]
    }
    
    init<T1: SContent,
         T2: SContent,
         T3: SContent,
         T4: SContent,
         T5: SContent,
         T6: SContent,
         T7: SContent,
         T8: SContent,
         T9: SContent>(_ v1: T1,
                       _ v2: T2,
                       _ v3: T3,
                       _ v4: T4,
                       _ v5: T5,
                       _ v6: T6,
                       _ v7: T7,
                       _ v8: T8,
                       _ v9: T9)
    where T == (T1, T2, T3, T4, T5, T6, T7, T8, T9) {
        value = (v1, v2, v3, v4, v5, v6, v7, v8, v9)
        _children = [
            AnySContent(v1),
            AnySContent(v2),
            AnySContent(v3),
            AnySContent(v4),
            AnySContent(v5),
            AnySContent(v6),
            AnySContent(v7),
            AnySContent(v8),
            AnySContent(v9),
        ]
    }
    
    init<T1: SContent,
         T2: SContent,
         T3: SContent,
         T4: SContent,
         T5: SContent,
         T6: SContent,
         T7: SContent,
         T8: SContent,
         T9: SContent,
         T10: SContent>(_ v1: T1,
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
        value = (v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
        _children = [
            AnySContent(v1),
            AnySContent(v2),
            AnySContent(v3),
            AnySContent(v4),
            AnySContent(v5),
            AnySContent(v6),
            AnySContent(v7),
            AnySContent(v8),
            AnySContent(v9),
            AnySContent(v10),
        ]
    }
}

// MARK: - content container
extension STupleContent: _SContentContainer {
    var children: [AnySContent] { _children }
}
