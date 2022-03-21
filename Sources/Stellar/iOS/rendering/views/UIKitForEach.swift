//
//  UIKitForEach.swift
//  
//
//  Created by Jesse Spencer on 3/8/22.
//

import Foundation

/// Provides rendered ForEach content on-demand.
final
class UIKitForEach: UIKitTargetRenderableContent {
    
    private
    var forEach: AnyForEach
    
    init(primitive: AnyForEach) {
        self.forEach = primitive
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        guard let forEach = primitive as? AnyForEach else { fatalError() }
        self.forEach = forEach
    }
    
    func addChild(_ view: UIKitTargetRenderableContent, before siblingView: UIKitTargetRenderableContent?) {}
    func removeChild(_ view: UIKitTargetRenderableContent) {}
}
// MARK: - convenience api
extension UIKitForEach {
    
    /// The type-erased data identifiers.
    var identifiers: [AnyHashable] {
        forEach.data.compactMap { datum in
            guard let id = datum[keyPath: forEach.id] as? AnyHashable else {
                assertionFailure("Unexpected identifier type: \(String(describing: datum[keyPath: forEach.id]))")
                return nil
            }
            return id
        }
    }
    
    /// The type-erased data.
    var data: [Any] {
        forEach.data
    }
    
    var idKeypath: AnyKeyPath {
        forEach.id
    }
}


final
class UIKitViewCollection: UIKitTargetRenderableContent {
    
    func update(with primitive: AnyUIKitPrimitive) {
        // TODO:
        fatalError("TODO")
    }
    
    func addChild(_ view: UIKitTargetRenderableContent, before siblingView: UIKitTargetRenderableContent?) {
        // TODO:
        fatalError("TODO")
    }
    
    func removeChild(_ view: UIKitTargetRenderableContent) {
        // TODO:
        fatalError("TODO")
    }
}
