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
struct SListView<Content, Selection>: SView, SContent
where Content : SContent {
    
    /// The content of this list.
    let contentProvider: Content
    /// The selection, if existing, in the list.
    let selection: _Selection?
    
    /// Renders `SContent` into `UIKit` renderable types.
    /// TODO: This will be moved into app level framework code.
    var renderer: UIKitRenderer { .init(content: body) }
    
    /// The controller which will perform rendering of this instance.
    /// TODO: This will be removed when the framework is handling rendering of `SView` types.
    let controller: NLViewController = .init(nibName: nil, bundle: nil)
    
    enum _Selection {
        case one(SBinding<Selection?>?)
        case many(SBinding<[Selection]>?)
    }
    
    public
    var id: UUID = .init()
    
    public
    var content: ViewHierarchyObject {
        // Add the root view from the rendered target content to the root view controller.
        guard let rootView = renderer.rootTarget.renderableContent as? UIView else {
            fatalError("Root content is not a view.")
        }
        controller.view = rootView
        
        return controller
    }
    
    public
    var body: some SContent {
        // check content for any contents which are not in a section
        // normalize by placing any loose contents into implicit sections, while finding explicit sections.
        if let contentContainer = content as? _SContentContainer {
            
            // Content has children. Check for SSections and other content.
            var sections = [AnySContent]()
            var otherContents = [AnySContent]()
            
            for child in contentContainer.children {
                if child.content is _SSectionContainer {
                    if !otherContents.isEmpty {
                        // if other contents has been found, create a section for it
                        sections.append(.init(SSection(content: {
                            SForEach(Array(otherContents.enumerated()),
                                     id: \.offset,
                                     dataSubject: nil) { _, content in content }
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
                             id: \.offset,
                             dataSubject: nil) { _, content in content }
                })))
            }
            
            return AnySContent(SForEach(Array(sections.enumerated()),
                            id: \.offset) { _, content in
                if let section = content as? _SSectionContainer {
                    section.makeListRow()
                }
                else {
                    content
                }
            })
        }
        else {
            // Content has no children
           return AnySContent(contentProvider)
        }
    }
    
    /*
     guard let contentContainer = content as? _SContentContainer else {
     assertionFailure("Unexpected content type.")
     return .init([])
     }
     var sections = [ListSection]()
     
     // Check content containers for SSections.
     for (index, child) in contentContainer.children.enumerated() {
     if let sectionContainer = child.content as? _SSectionContainer {
     sections.append(.init(id: index,
     dataSubject: (sectionContainer.anyContentProvider().content as? DataPublisher)?._dataSubject ?? .init([]),
     rowProvider: { sectionContainer.anyContentProvider().renderContent() },
     headerProvider: { sectionContainer.anyHeaderProvider().renderContent() },
     footerProvider: { sectionContainer.anyFooterProvider().renderContent() }))
     }
     }
     
     // If no sections were found in the top level list content,
     // create one.
     if sections.isEmpty {
     let emptyRenderableContent = { SEmptyContent().renderContent() }
     sections.append(.init(id: 0,
     dataSubject: dataSubject,
     rowProvider: { content.renderContent() },
     headerProvider: emptyRenderableContent,
     footerProvider: emptyRenderableContent))
     }
     
     return sections
     */
}
