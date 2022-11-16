//
//  Array+Extensions.swift
//  
//
//  Created by Jesse Spencer on 10/4/21.
//

import Foundation

// MARK: - toggle
extension Array
where Element : Equatable {
        
    /// Appends the element if not present or removes the first appearance, if existing.
    /// - Note: This function assumes the element only appears once in the collection.
    public
    mutating
    func toggle(_ element: Element) {
        if let index = self.firstIndex(where: { $0 == element }) {
            self.remove(at: index)
        }
        else {
            self.append(element)
        }
    }
}
