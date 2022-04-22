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
    
    private
    var reconciler: TreeReconciler<UIKitRenderer>!
    
    let scheduler: DispatchQueue
    
    let rootTarget: UIKitTarget
    
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
        // TODO: Create a target and add it to the parent; or create renderable content from the host's primitive and add it to the parent, returning the parent target.
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
        // TODO: This requires a one-to-one relationship of targets to primitive content in order to provide updates to the correct rendered instance. Consequently, as primitive content is provided to the renderer to be translated into a renderable hierarchy, it cannot be flattened into one target instance. This means that on UIKit, it's currently difficult or impossible to create a UIViewController hierarchy within one renderer instance. This may or may not be a significant issue, depending on if UIViewController provides no significant benefits to rendering. If it is better to allow a one-to-many relationship between targets and primitives, it will be necessary to be able to identify primitive instances across updates, or at least to associate primitives with the rendered instance.
        // OR - the renderer could maintain a hierarchy of view controllers by watching for presentation modifiers. Primitives would be added to the top controller on a stack until another presentation modifier is encountered, where a new controller would be pushed onto the stack.
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
