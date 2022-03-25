//
//  ModifiedContent.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SModifiedContent: UIKitPrimitive
where Content : SContent, Modifier : SContentModifier {
    
    var renderedBody: AnySContent {
        // recognized modifiers
        if let uiKitModifier = modifier as? UIKitModifier {
            // flatten modifiers when content is UIKit modified content
            if let modifiedContent = content as? AnyUIKitModifiedContent {
                return .init(UIKitModifiedContentPrimitive(attributes: modifiedContent.uiKitModifier.renderableAttributes + uiKitModifier.renderableAttributes,
                                                           content: modifiedContent.anyContent))
            }
            else {
                return AnySContent(UIKitModifiedContentPrimitive(attributes: uiKitModifier.renderableAttributes,
                                                                 content: .init(content)))
            }
        }
        // recognized non-collapsible modifiers
        else if let uiKitComposableModifier = modifier as? UIKitComposableModifier {
            return .init(UIKitComposedModifiedContentPrimitive(content: .init(content),
                                                               modifierContent: uiKitComposableModifier.content))
        }
        // unrecognized primitive modifier
        else if Modifier.Body.self == Never.self {
            // Pass the content on without calling the modifier - it's primitive and unsupported on UIKit.
            return AnySContent(content)
        }
        // non-primitive modifier
        else {
            // call the modifier to continue the rendering chain
            return AnySContent(modifier.body(content: .init(modifier: modifier, content: .init(content))))
        }
    }
}
// chained modifiers
extension SModifiedContent: UIKitModifier
where Content : UIKitModifier, Modifier : UIKitModifier {
    
    var renderableAttributes: [UIKitViewAttribute] {
        // combine attributes to flatten the live tree
        content.renderableAttributes + modifier.renderableAttributes
    }
}
extension SModifiedContent: AnyUIKitModifiedContent
where Content : SContent, Modifier : UIKitModifier {
    
    var uiKitModifier: UIKitModifier {
        modifier
    }
    
    var anyContent: AnySContent {
        .init(content)
    }
}

// MARK: any modified content

/// This protocol is used to recognize modified content primitives which meet the requirements in order to flatten modifiers.
protocol AnyUIKitModifiedContent {
    
    var uiKitModifier: UIKitModifier { get }

    /// Content to which the modifier was applied.
    var anyContent: AnySContent { get }
}
