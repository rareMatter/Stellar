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
struct SListView<Content, Selection>: SView
where Content : SContent {
    
    let contentProvider: () -> Content
    
    typealias HierarchyObjectProvider = (Content, SectionsSubject) -> ViewHierarchyObject
    let hierarchyObjectProvider: HierarchyObjectProvider
    
    typealias SectionsSubject = CurrentValueSubject<[ListSection], Never>
    let sectionsSubject = SectionsSubject([])
    
    var cancellable: AnyCancellable?
    
    public
    var id: UUID = .init()
    
    init(cancellable: inout AnyCancellable?,
         contentProvider: @escaping () -> Content,
         hierarchyObjectProvider: @escaping (Content, CurrentValueSubject<[ListSection], Never>) -> ViewHierarchyObject) {
        self.cancellable = cancellable
        self.contentProvider = contentProvider
        self.hierarchyObjectProvider = hierarchyObjectProvider
    }
    
    public
    var content: ViewHierarchyObject {
        hierarchyObjectProvider(contentProvider(), sectionsSubject)
    }
}

// MARK: - Create a list with identifiable, hierarchical data.
public
extension SListView {
    
    init<Data, RowContent>(_ dataSubject: CurrentValueSubject<Data, Never>,
                           children: KeyPath<Data.Element, Data?>?,
                           selections: CurrentValueSubject<[Selection], Never>? = nil,
                           mode: CurrentValueSubject<ListMode, Never>? = nil,
                           layout: UICollectionViewLayout? = nil,
                           backgroundColor: UIColor = .systemGroupedBackground,
                           @SContentBuilder rowContentProvider: @escaping (Data.Element) -> RowContent)
    where Data : RandomAccessCollection,
    Data.Element : Hashable,
    Data.Element : Identifiable,
    RowContent : SContent,
    Content == SForEach<Data, Data.Element.ID, RowContent> {
        
        var cancellable: AnyCancellable?
        
        self.init(cancellable: &cancellable) {
            SForEach(dataSubject) { item in
                rowContentProvider(item)
            }
        } hierarchyObjectProvider: { content, sectionsSubject in
            
            // Decompose content.
            // Check for content containers...are children sections?
            // Map sections to ListSections.
            // If not content container, use for all rows.
            func decomposeContent(_ content: Content) -> [ListSection] {
                guard let contentContainer = content as? _SContentContainer else {
                    assertionFailure("Unexpected content type.")
                    return []
                }
                
                var sections: [ListSection] = []
                
                // If content is a container, check it for sections.
                // Check content containers for SSections.
                for (index, child) in contentContainer.children.enumerated() {
                    // Extract sections.
                    if let sectionContainer = child.content as? _SSectionContainer {
                        
                        sections.append(.init(id: index,
                                              dataSubject: (sectionContainer.anyContentProvider().content as? DataPublisher)?._dataIDSubject ?? .init([]),
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
            }
            
            // Connect data subject to sections subject.
            cancellable = dataSubject.map { _ in
                // Use the data as contained by the content provider.
                decomposeContent(content)
            }
            .assign(to: \.value, on: sectionsSubject)
            
            let controller = ListViewController(sectionsSubject,
                                                children: (children as! KeyPath<AnyHashable, [AnyHashable]?>),
                                                selections: (selections as! CurrentValueSubject<[AnyHashable], Never>),
                                                mode: mode ?? .init(.normal),
                                                configuration: .init(),
                                                layout: layout,
                                                backgroundColor: backgroundColor) { section, row, cellConfigState in
                section.rowProvider()
            }
            
            return controller
        }
    }
}
