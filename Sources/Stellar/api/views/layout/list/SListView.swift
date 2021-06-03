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
struct SListView<Model, Content>: SView where Model: SListModel, Content: SContent {
    
    // -- list state
    var listState: State
    
    // -- first reponders
    var initialFirstResponderHandler: InitialFirstResponderHandler?
    var subsequentFirstResponderHandler: SubsequentFirstResponderHandler?
    
    // -- layout
    var layout: UICollectionViewLayout?
    
    // -- color
    var backgroundColor: UIColor = .systemGroupedBackground
    
    // -- model and rows
    var listModel: Model
    
    @SContentBuilder
    var rowProvider: RowContentProvider
    
    // -- title bar (nav bar)
    var titleBarView: STitleBarView?
    
    /// Creates the view with a model that drives updates.
    public
    init(listModel: Model,
         listState: State = .init(),
         layout: UICollectionViewLayout? = nil,
         @SContentBuilder rowContentProvider: @escaping RowContentProvider) {
        self.listModel = listModel
        self.listState = listState
        self.layout = layout
        self.rowProvider = rowContentProvider
    }
    
    /// Creates the view using an unchanging snapshot.
    public
    init(snapshot: Model.Snapshot,
         listState: State = .init(),
         layout: UICollectionViewLayout? = nil,
         @SContentBuilder rowContentProvider: @escaping RowContentProvider) {
        let model = SStaticListModel(staticSnapshot: snapshot)
        self.init(listModel: model as! Model,
                  listState: listState,
                  layout: layout,
                  rowContentProvider: rowContentProvider)
    }
    
    public
    var id: UUID = .init()
    
    public
    var content: ViewHierarchyObject {
        let controller = ViewController(
            configuration: self,
            listModel: listModel,
            listState: listState,
            layout: layout,
            backgroundColor: backgroundColor)
        { [rowProvider] (section: SectionType,
                         item: ItemType,
                         listState: ViewController.State,
                         cellConfigState: UICellConfigurationState) in
            let rowContent = rowProvider(section,
                                      item,
                                      listState,
                                      cellConfigState)
            
            #warning("TODO: Update properties with actual values.")
            return .init(contentConfiguration: rowContent
                            .renderContentConfiguration(),
                         backgroundConfiguration: UIBackgroundConfiguration
                            .listPlainCell(),
                         accessories: [],
                         tapHandler: nil,
                         selectionHandler: nil)
        }
        
        // -- nav bar setup
        if let titleBarView = titleBarView {
            controller.navigationItem.copy(propertiesFrom: titleBarView.content)
        }
        
        return titleBarView != nil ?
            NLNavigationController(rootViewController: controller) :
            controller
    }
}

// MARK: - typealiases
public
extension SListView {
    typealias SectionType = Model.SectionType
    typealias ItemType = Model.ItemType
    
    typealias State = ListState<ItemType>
    
    typealias InitialFirstResponderHandler = () -> ItemType?
    typealias SubsequentFirstResponderHandler = (_ currentResponder: ItemType) -> ItemType?
    
    typealias RowContentProvider = (
        _ section: Model.SectionType,
        _ item: Model.ItemType,
        _ listState: ListState<ItemType>,
        _ configurationState: UICellConfigurationState
    ) -> Content
}
extension SListView {
    typealias ViewController = ListViewController<Model, Self>
}
