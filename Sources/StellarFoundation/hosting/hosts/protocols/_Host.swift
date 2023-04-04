//
//  _Host.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

// TODO: Now that architecture has evolved, try value-type hosts again.
protocol _Host: AnyObject {
    var element: CompositeElement { get set }
    
    @MainActor
    func render(with context: RenderContext, enqueueUpdate: @autoclosure () -> Void) -> RenderOutput
    
    @MainActor
    func update(with context: RenderContext, enqueueUpdate: @autoclosure () -> Void) -> RenderOutput
    
    @MainActor
    func dismantle(with context: RenderContext)
}
