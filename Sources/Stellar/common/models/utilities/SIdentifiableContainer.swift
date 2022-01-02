//
//  SIdentifiableContainer.swift
//  
//
//  Created by Jesse Spencer on 12/14/21.
//

import Foundation

/// An `Identifiable` container of a generic type. The generic type does not need to be `Identifiable`. This container is useful for closures, which cannot have an identity on their own.
///
/// This container is also `Hashable`. The `id` is used to create the hash value.
public
struct SIdentifiableContainer<T>: Identifiable, Hashable {
    
    public
    let id: UUID
    public
    let t: T
    
    public
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public
    static
    func == (lhs: SIdentifiableContainer<T>,
             rhs: SIdentifiableContainer<T>) -> Bool {
        lhs.id == rhs.id
    }
}

public
extension SIdentifiableContainer {

    init(_ t: T,
         uuid: UUID = .init()) {
        self.t = t
        self.id = uuid
    }
}
