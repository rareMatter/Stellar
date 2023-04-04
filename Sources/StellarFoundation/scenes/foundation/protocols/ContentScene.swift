//
//  ContentScene.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

// Scenes which produce content.
protocol ContentScene: PrimitiveScene {
    var content: [any SContent] { get }
}

// TODO: A host which manages a scene that provides a content hierarchy.
// This host is the bridge from a scene to a content hierarchy. This host performs lazy rendering like other primitive scene hosts, however, it mounts a content hierarchy as its children. When the platform content instance is provided the content hierarchy is mounted.
// TODO: This host, or a different but similar host, should maintain a collection of content root instances, each of which would be its own distinct hierarchy. This would be done for Windowed scene types, which are probably an extension to Content scene types. WindowedContentScene?
/*
 final class ContentSceneHost: ElementHost {
 
 let anyContentScene: any ContentScene
 var content: [any SContent] = []
 
 override
 init(scene: any PrimitiveScene, parentPlatformContent: PlatformContent, parent: ElementHost?) {
 guard let anyContentScene = scene as? any ContentScene else { fatalError() }
 self.anyContentScene = anyContentScene
 
 super.init(scene: scene, parentPlatformContent: parentPlatformContent, parent: parent)
 }
 
 override
 func performLazyMount() {
 // TODO: Mount the content provided by the content scene, appending the root to the collection.
 super.performLazyMount()
 }
 }
 */
