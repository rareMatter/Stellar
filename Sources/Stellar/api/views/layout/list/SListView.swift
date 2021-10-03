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
struct SListView<Content, Data>: SView
where Content: SContent, Data : RandomAccessCollection, Data.Element : Hashable, Data.Element : Identifiable {
    
    // -- content
    let contentProvider: (Data.Element, UICellConfigurationState) -> Content

    // -- data
    let data: CurrentValueSubject<Data, Never>
    let children: KeyPath<Data.Element, Data?>?
    
    // -- state
    let selections: CurrentValueSubject<Set<Data.Element>, Never>
    let mode: CurrentValueSubject<ListMode, Never>
    
    // -- title bar (nav bar)
    var titleBarView: STitleBarView?
    
    // -- first reponders
//    var initialFirstResponderHandler: (() -> AnyHashable?)?
//    var subsequentFirstResponderHandler: ((AnyHashable) -> AnyHashable?)?
    
    // -- layout
    var layout: UICollectionViewLayout?
    
    // -- color
    var backgroundColor: UIColor = .systemGroupedBackground
    
    public
    var id: UUID = .init()
    
    public
    var content: ViewHierarchyObject {
        let controller = ListViewController<Content, Data>(
            data,
            children: children,
            selections: selections,
            mode: mode,
            configuration: .init(),
            layout: layout,
            backgroundColor: backgroundColor,
            rowContent: contentProvider)
        
        // -- nav bar setup
        if let titleBarView = titleBarView {
            controller.navigationItem.copy(propertiesFrom: titleBarView.content)
        }
        
        return titleBarView != nil ?
            NLNavigationController(rootViewController: controller) :
            controller
    }
}

// MARK: - Create a list with identifiable, hierarchical data.
public
extension SListView {
    
    init(_ dataSubject: CurrentValueSubject<Data, Never>,
         children: KeyPath<Data.Element, Data?>? = nil,
         selections: CurrentValueSubject<Set<Data.Element>, Never>? = nil,
         mode: CurrentValueSubject<ListMode, Never>? = nil,
         @SContentBuilder rowContent: @escaping (Data.Element, UICellConfigurationState) -> Content) {
        self.data = dataSubject
        self.children = children
        self.selections = selections ?? .init(.init())
        self.mode = mode ?? .init(.normal)
        self.contentProvider = rowContent
    }
}

public
extension SListView {
    
    func titleBar(_ titleBarViewProvider: () -> STitleBarView) -> Self {
        var modified = self
        modified.titleBarView = titleBarView
        return modified
    }
}
