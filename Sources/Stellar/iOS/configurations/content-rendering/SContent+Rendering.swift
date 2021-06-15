//
//  SContent+Rendering.swift
//  
//
//  Created by Jesse Spencer on 5/20/21.
//

import UIKit

extension SContent {
    
    func renderContent() -> UIKitRenderableContent {
        let cellContent: UIKitRenderableContent = .makeDefaultState()
        mountContent(on: cellContent,
                     anyContent: AnySContent(self))
        return cellContent
    }
    
    // AnySContent is being used directly for now - until the need to create a "mounted" layer is necessary (to allow state change observation and updating). When this happens, AnySContent will be replaced by a host type which stores hierarchy properties that it hosts.
    // Also, this deconstruction process of the content hierarchy will be moved into the app launch process and functions for mounting content onto a rendering target will be moved into a rendering type specific to the platform.
    private
    func mountContent(on parent: UIKitRenderableContent,
                      anyContent: AnySContent) {
        
        // content is primitive
        if anyContent.bodyType == Never.self {
            
            // content is renderable
            if let renderablePrimitiveContent = anyContent.content as? UIKitContentRenderer {
                renderablePrimitiveContent
                    .mountContent(on: parent)
                #warning("is this always an endpoint for recursion?")
            }
            // content is a modifier
            else if let anyModifiedContent = anyContent.content as? AnySModifiedContent {
                
                // modified content is a renderable primitive
                if let uikitModifiedContentRenderer = anyModifiedContent as? UIKitModifiedContentRenderer {
                    // mount the modifier directly
                    uikitModifiedContentRenderer
                        .mountModifier(on: parent)
                    // recurse with content
                    mountContent(on: parent,
                                 anyContent: anyModifiedContent.anyContent)
                }
                // modified content is a composite, recurse with the body
                else if let nestedModifiedContent = anyModifiedContent.anyContent as? AnySModifiedContent {
                    let modifiedBody = AnySContent(
                        nestedModifiedContent
                            .anySModifier
                            .body(content: .init(modifier: nestedModifiedContent.anySModifier,
                                                 content: nestedModifiedContent.anyContent)))
                    mountContent(on: parent,
                                 anyContent: modifiedBody)
                }
                else {
                    assertionFailure("Unhandled Modified Content type. Rendering could be incorrect or fail.")
                }
            }
            // content is a container
            else if let contentContainer = anyContent.content as? _SContentContainer {
                // mount each child
                contentContainer.children
                    .forEach { child in
                        mountContent(on: parent,
                                     anyContent: child)
                    }
            }
            else {
                assertionFailure("Unhandled SContent type. Rendering could be incorrect or fail.")
            }
            
            return
        }
        // content is some composite type
        else {
            // Deconstruct using the body provider.
            // In the future, this will be the point where any state updating properties will be extracted from the composite using detailed type information in order to trigger content hierarchy updates after state changes.
            let bodyContent = anyContent.bodyProvider(anyContent.content)
            mountContent(on: parent,
                         anyContent: bodyContent)
        }
    }
}
