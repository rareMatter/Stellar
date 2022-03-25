//
//  List.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SListView: UIKitPrimitive {
    var renderedBody: AnySContent {
        let selections: Set<AnyHashable>? = {
            if let selection = self.selection {
                switch selection {
                case let .one(binding):
                    return .init(arrayLiteral: .init(binding.wrappedValue))
                case let .many(binding):
                    return binding.wrappedValue
                }
            }
            else { return nil }
        }()
        return .init(UIKitListPrimitive(selectionValue: selections,
                                 content: .init(body)))
    }
}
struct UIKitListPrimitive: SContent, AnyUIKitPrimitive {
    let selectionValue: Set<AnyHashable>?
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitCollectionView(primitive: self)
    }
}
extension UIKitListPrimitive: _SContentContainer {
    var children: [AnySContent] {
        [content]
    }
}
