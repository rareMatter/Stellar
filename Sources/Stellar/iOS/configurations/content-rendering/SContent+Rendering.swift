//
//  SContent+Rendering.swift
//  
//
//  Created by Jesse Spencer on 5/20/21.
//

import UIKit

extension SContent {
    
    func renderContentConfiguration() -> UIContentConfiguration {
        var contentConfiguration: UIContentConfiguration? = nil
        applyContentToConfiguration(AnySContent(self), contentConfiguration: &contentConfiguration)
        return contentConfiguration!
    }
    
    private
    func applyContentToConfiguration(_ anyContent: AnySContent,
                                     contentConfiguration: inout UIContentConfiguration?) {
        
        // The type is primitive and must be rendered.
        if anyContent.bodyType == Never.self && anyContent.type is SPrimitiveContentConfigurationRenderer.Type {
            if let renderablePrimitiveContent = anyContent.content as? SPrimitiveContentConfigurationRenderer {
                contentConfiguration = renderablePrimitiveContent.makeContentConfiguration()
            }
            return
        }
        // The type is primitive with no appearance.
        else if anyContent.bodyType == Never.self && !(anyContent.type is SPrimitiveContentConfigurationRenderer.Type) {
            // The type is a content container and has children.
            if let contentContainer = anyContent.content as? _SContentContainer {
                contentContainer.children.forEach {
                    // Recurse with each child.
                    applyContentToConfiguration($0, contentConfiguration: &contentConfiguration)
                }
            }
        }
        // Content is some composite type.
        else {
            // Deconstruct using the body provider.
            let bodyContent = anyContent.bodyProvider(anyContent.content)
            applyContentToConfiguration(bodyContent, contentConfiguration: &contentConfiguration)
        }
    }
}
