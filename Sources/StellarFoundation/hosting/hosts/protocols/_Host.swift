//
//  _Host.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

public
protocol _Host {
    var element: CompositeElement { get set }
    
    @MainActor
    mutating
    func render(with context: RenderContext, enqueueUpdate: @escaping () -> Void) -> RenderOutput?
    
    @MainActor
    mutating
    func update(with context: RenderContext, enqueueUpdate: @escaping () -> Void) -> RenderOutput?
    
    @MainActor
    mutating
    func dismantle(with context: DismantleContext)
}
