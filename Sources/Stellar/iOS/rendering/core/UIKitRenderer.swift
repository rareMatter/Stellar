//
//  UIKitRenderer.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

// TODO: WIP

import UIKit

final
class UIKitRenderer: Renderer {
    
    /// The reconciler to use when updating and rendering.
    private
    var reconciler: TreeReconciler<UIKitRenderer>!
    
    /// Use this to schedule updates to the Descriptive Tree.
    let scheduler: DispatchQueue
    
    /// The root of the target tree.
    var rootTarget: UIKitTarget {
        get { reconciler.rootTarget }
    }
    
    /// Creates a renderer for the provided content.
    init<C: SContent>(content: C) {
        let scheduler = DispatchQueue.main
        self.scheduler = scheduler
        
        guard let anyPrimitive = content as? AnyUIKitPrimitive else {
            fatalError()
        }
        self.reconciler = .init(content: content,
                                target: UIKitTarget(content: .init(content),
                                                    anyUIKitPrimitive: anyPrimitive),
                                renderer: self,
                                scheduler: { scheduler.schedule(options: nil, $0) })
    }
    
    func makeTarget(for host: PrimitiveViewHost<UIKitRenderer>, beforeSibling sibling: UIKitTarget?, withParent parent: UIKitTarget) -> UIKitTarget? {
        
        if let anyPrimitive = host.wrappedContent as? AnyUIKitPrimitive {
            let target = UIKitTarget(content: host.content,
                                     anyUIKitPrimitive: anyPrimitive)
            parent.addChild(target, before: sibling)
            return target
        }
        
        // The content isn't recognized by this renderer or hasn't yet been declared renderable by UIKit.
        return nil
    }
    
    func update(_ target: UIKitTarget,
                with host: PrimitiveViewHost<UIKitRenderer>) {
        if let anyUIKitPrimitive = host.wrappedContent as? AnyUIKitPrimitive {
            target.update(withPrimitive: anyUIKitPrimitive)
        }
    }
    
    func remove(_ target: UIKitTarget, fromParent parent: UIKitTarget, withTask task: UnmountHostTask<UIKitRenderer>) {
        // TODO: This likely needs the same type checks as mount.
        
        if let _ = task.host.wrappedContent as? AnyUIKitPrimitive {
            parent.removeChild(target)
        }
        
        // TODO: Perform removal transition.
        
        task.finish()
    }
}
