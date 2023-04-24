//
//  Reconciler.swift
//  
//
//  Created by Jesse Spencer on 12/8/22.
//

public
protocol Reconciler: AnyObject {
    
    // TODO: How can a platform associate a scene instance provided by its system with a scene description provided by the app?
    // system says: a scene is requested by the user. How should it be configured?
    // reconciler: what kind of scene? which scene description should be used to configure it?
    // - scene kind
    // - identifier
    // - type structure
    // These different levels of identity allow different levels of association. If only scene kind association is possible on a platform (seemingly iOS), then multiple scenes of the same primitive type (i.e. WindowGroup) will not be possible because association can only be made at the "kind" (type-erasure due to different types; i.e. Apple provides the scene type) and not type-level. If a stronger association (type structure, identifier) is possible on the platform (i.e. scene type can be declared or an identifier can be specified) then variadic same-type primitive scenes can be declared by the app.
    // .. This will be apparent when building support for macOS because Window requires an ID when created.
    
    // TODO: This is needed so the platform can prepare to render scenes when the system provides the rendered instance.
    // This could contain multiple WindowGroups, or other platform-specific scenes like a menu bar or settings.
    var scenes: [SceneContext] { get }
    
    // TODO: When a scene is added or removed, the reconciler should traverse the scene hosts until a matching type is found. When found, create a new host for the scene and append it to the children of the parent host.
    /// Creates a new scene with its own state and content hierarchy using the specified type as a template.
    func addNewSceneInstance(_ scene: SceneContext, platformContent: PlatformContent)
    func replaceExistingScene(_ scene: SceneContext, platformContent: PlatformContent)
    func removeSceneInstance(_ scene: SceneContext)
}
