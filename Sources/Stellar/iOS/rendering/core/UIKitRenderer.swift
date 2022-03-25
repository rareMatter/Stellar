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
    
    typealias TargetType = UIKitTarget
    
    /// The reconciler to use when updating and rendering.
    private
    var reconciler: TreeReconciler!
    
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
    
    func mountTarget(before sibling: UIKitTarget?,
                     on parent: UIKitTarget,
                     with host: ElementHost) -> UIKitTarget? {
        // TODO: Create map function (similar to Tokamak) to avoid diving down into `AnySContent` content properties.
        if let anyPrimitive = host.content.content as? AnyUIKitPrimitive {
            let target = UIKitTarget(content: host.content,
                                     anyUIKitPrimitive: anyPrimitive)
            parent.addChild(target, before: sibling)
            return target
        }
        // TODO: This should probably be checking for GroupedContent?
        // Handle container primitives which haven't been declared UIKit renderable by passing down the parent target
        else if host.content.content is _SContentContainer {
            return parent
        }
        
        // The content isn't recognized by this renderer or hasn't yet been declared renderable by UIKit.
        return nil
    }
    
    func update(target: UIKitTarget,
                with host: ElementHost) {
        if let anyUIKitPrimitive = host.content.content as? AnyUIKitPrimitive {
            target.update(withPrimitive: anyUIKitPrimitive)
        }
    }
    
    func unmount(target: UIKitTarget,
                 from parent: UIKitTarget,
                 withTask task: UnmountHostTask<UIKitRenderer>) {
        // TODO: This likely needs the same type checks as mount.
        
        if let _ = task.host.content.content as? AnyUIKitPrimitive {
            parent.removeChild(target)
        }
        
        // TODO: Perform removal transition.
        
        task.finish()
    }
    
    func bodyFor(primitiveContent: Any) -> AnySContent? {
        (primitiveContent as? UIKitPrimitive)?.renderedBody
    }
    
    func isPrimitiveContent(_ type: Any.Type) -> Bool {
        type is UIKitPrimitive.Type
    }
}
