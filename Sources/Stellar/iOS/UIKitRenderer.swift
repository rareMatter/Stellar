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
    private
    let scheduler: DispatchQueue
    
    /// The root of the target tree.
    private
    var rootTarget: UIKitTarget {
        get { reconciler.rootTarget }
    }
    
    let rootViewController: NLViewController
    
    // TODO: Controller param is temporary, until the framework encompasses navigation and presentation of content.
    // For now, rendering can only be done per view controller.
    /// Creates a renderer for the provided content, using the controller's root view as a foundation for rendering.
    init<C: SContent>(content: C, controller: NLViewController) {
        let scheduler = DispatchQueue.main
        self.scheduler = scheduler
        self.rootViewController = controller
        
        self.reconciler = .init(content: content,
                                target: UIKitTarget(content,
                                                    uiKitPrimitive: UIKitViewPrimitive(viewType: .root(rootViewController.view),
                                                                                       content: { content })),
                                renderer: self,
                                scheduler: { scheduler.schedule(options: nil, $0) })
    }
    
    func mountTarget(before sibling: UIKitTarget?,
                     on parent: UIKitTarget,
                     with host: ElementHost) -> UIKitTarget? {
        
        if let anyPrimitive = host.content as? AnyUIKitPrimitive {
            let target = UIKitTarget(host.content,
                                     uiKitPrimitive: anyPrimitive)
            let view = makeView(from: anyPrimitive)
            
            // check for a sibling
            if let sibling = sibling {
                // add target to parent as a sibling, before sibling param
                parent.view.addChild(view,
                                     before: sibling.view)
            }
            else {
                // add target to parent as a child
                parent.view.addChild(view)
            }
            
            return target
        }
        // UIKit primitives may also be a UIKitViewModifier which should be applied to the parent target instead of creating one.
        else if let anyModifiedContent = host.content as? AnyUIKitModifiedContent {
            parent.view.addAttributes(anyModifiedContent.attributes)
            return parent
        }
        // Handle container primitives which haven't been declared UIKit renderable by passing down the parent target
        else if host.content is _SContentContainer {
            return parent
        }
        
        // The content isn't recognized by this renderer or hasn't yet been declared renderable by UIKit.
        return nil
    }
    
    func update(target: UIKitTarget,
                with host: ElementHost) {
        if let anyPrimitive = host.content as? AnyUIKitPrimitive {
            target.view.update(using: anyPrimitive)
        }
        else if let anyModifiedContent = host.content as? AnyUIKitModifiedContent {
            target.view.updateAttributes(anyModifiedContent.attributes)
        }
    }
    
    func unmount(target: UIKitTarget,
                 from parent: UIKitTarget,
                 withTask task: UnmountHostTask<UIKitRenderer>) {
        // TODO: This likely needs the same type checks as mount.
        
        if let _ = task.host.content as? AnyUIKitPrimitive {
            parent.view.removeChild(target.view)
        }
        // UIKit primitives may also be a UIKitViewModifier which should be applied to the parent target instead of creating one.
        else if let anyModifiedContent = task.host.content as? AnyUIKitModifiedContent {
            parent.view.removeAttributes(anyModifiedContent.attributes)
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
