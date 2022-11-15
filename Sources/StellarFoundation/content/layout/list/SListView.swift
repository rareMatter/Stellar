//
//  SListView.swift
//  
//
//  Created by Jesse Spencer on 2/28/21.
//

import Foundation
import Combine
import UIKit
import SwiftUI

public
struct SListView<Content, Selection>: SPrimitiveContent
where Content : SContent, Selection : Hashable {
    
    /// The content of this list.
    let content: Content
    /// The selection, if existing, in the list.
    let selection: _Selection?
    
    enum _Selection {
        case one(SBinding<Selection>)
        case many(SBinding<Set<Selection>>)
    }
    
    private
    var sectionedContent: some SContent {
        // check content for any contents which are not in a section
        // normalize by placing any loose contents into implicit sections, while finding explicit sections.
        if let contentContainer = content as? _SContentContainer {
            
            // Content has children. Check for SSections and other content.
            var sections = [AnySContent]()
            var otherContents = [AnySContent]()
            
            for child in contentContainer.children {
                if child.content is _AnySection {
                    if !otherContents.isEmpty {
                        // if other contents has been found, create a section for it
                        sections.append(.init(SSection(content: {
                            SForEach(Array(otherContents.enumerated()),
                                     id: \.offset) { _, content in content }
                        })))
                        otherContents = []
                    }
                    sections.append(child)
                }
                else {
                    // non-sectioned content: add it to otherContents to be implicitly sectioned
                    if !child.children.isEmpty {
                        // the child is another content container: add its children to otherContents
                        otherContents.append(contentsOf: child.children)
                    }
                    else {
                        // add the child to otherContents
                        otherContents.append(child)
                    }
                }
            }
            // if any other contents remain, create a section for it
            if !otherContents.isEmpty {
                sections.append(.init(SSection(content: {
                    SForEach(Array(otherContents.enumerated()),
                             id: \.offset) { _, content in content }
                })))
            }
            
            return AnySContent(SForEach(Array(sections.enumerated()),
                            id: \.offset) { _, content in
               content
            })
        }
        else {
            // Content has no children
           return AnySContent(content)
        }
    }
}

extension SListView: _SContentContainer {
    var children: [AnySContent] { [.init(sectionedContent)] }
}

// FIXME: temp public
public
protocol AnyList {
    var selectionSet: Set<AnyHashable> { get }
}
extension SListView: AnyList {
    
    public
    var selectionSet: Set<AnyHashable> {
        if let selection = self.selection {
            switch selection {
            case let .one(binding):
                return .init(arrayLiteral: .init(binding.wrappedValue))
            case let .many(binding):
                return binding.wrappedValue
            }
        }
        else { return .init() }
    }
}
