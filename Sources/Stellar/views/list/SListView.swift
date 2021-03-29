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
struct SListView<Model>: SView where Model: SListModel {
    
    // -- taps
    /// A handler that is called when a tap is received by a list item (when not editing).
    var tapHandler: TapHandler?
   
    // -- selection
    /// A handler that is called when a selection is made during list editing.
    var selectionHandler: SelectionHandler?
    var multiselectionConfiguration: ListMultiselectionConfiguration = .init()
    
    // -- reordering
    var canReorderItemHandler: CanReorderItemHandler?
    var didReorderHandler: DidReorderHandler?
    
    // -- section insertion
    var canInsertItemIntoSectionHandler: CanInsertItemIntoSectionHandler?
    var didInsertItemIntoSectionHandler: DidInsertItemIntoSectionHandler?
    
    // -- section expand/collapse
    var canCollapseSectionHandler: CanCollapseSectionHandler?
    var didCollapseSectionHandler: DidCollapseSectionHandler?
    var canExpandSectionHandler: CanExpandSectionHandler?
    var didExpandSectionHandler: DidExpandSectionHandler?
    
    // -- swipe actions
    var leadingSwipeActionsHandler: SwipeActionsHandler?
    var trailingSwipeActionsHandler: SwipeActionsHandler?
    
    // -- first reponders
    var initialFirstResponderHandler: InitialFirstResponderHandler?
    var subsequentFirstResponderHandler: SubsequentFirstResponderHandler?
    
    // -- layout
    var layout: UICollectionViewLayout?
    
    // -- color
    var backgroundColor: UIColor = .systemGroupedBackground
    
    // -- model and rows
    var listModel: Model
    var rowProvider: RowProvider
    
    // -- title bar (nav bar)
    var titleBarView: STitleBarView?
    
    // -- toolbar
    var toolbarContent: ((ListState<ItemType>) -> AnyView)?
    
    /// Creates the view with a model that drives updates.
    public
    init(listModel: Model, layout: UICollectionViewLayout? = nil, rowProvider: @escaping RowProvider) {
        self.listModel = listModel
        self.layout = layout
        self.rowProvider = rowProvider
    }
    
    /// Creates the view using an unchanging snapshot.
    public
    init(snapshot: Model.Snapshot, layout: UICollectionViewLayout? = nil, rowProvider: @escaping RowProvider) {
        let model = SStaticListModel(staticSnapshot: snapshot)
        self.init(listModel: model as! Model, layout: layout, rowProvider: rowProvider)
    }
    
    public
    var id: UUID = .init()
    
    public
    var content: ViewHierarchyObject {
        let controller = ViewController(
            configuration: self,
            listModel: listModel,
            listState: ListState(),
            layout: layout,
            backgroundColor: backgroundColor)
        { (section: SectionType, item: ItemType, listState: ViewController.State) in
            UICollectionView.CellRegistration<ConfigurableCollectionCell, ItemType> { (configurableCollectionCell: ConfigurableCollectionCell, indexPath, item) in
                // -- first-time setup
                let rowData = rowProvider(section, item, listState, configurableCollectionCell.configurationState)
                configurableCollectionCell.contentConfiguration = rowData.contentConfiguration
                configurableCollectionCell.backgroundConfiguration = rowData.backgroundConfiguration
                configurableCollectionCell.accessories = rowData.accessories
                
                // -- updating for configuration state
                configurableCollectionCell.onConfigurationStateChange { (configState) in
                    let rowData = rowProvider(section, item, listState, configState)
                    let contentConfig = rowData.contentConfiguration
                    let backgroundConfig = rowData.backgroundConfiguration
                    return (contentConfig,
                            backgroundConfig)
                }
            }
        }
        .toolbar { (listState) in
            self.toolbarContent?(listState)
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
extension SListView {
    
    public
    typealias SectionType = Model.SectionType
    public
    typealias ItemType = Model.ItemType
    
    typealias ViewController = ListViewController<Model, Self>
    
    public
    typealias TapHandler = (_ item: ItemType, _ inSection: SectionType) -> Void
    
    public
    typealias SelectionHandler = (_ item: ItemType, _ inSection: SectionType) -> Void
    
    public
    typealias CanReorderItemHandler = (_ item: ItemType) -> Bool
    public
    typealias DidReorderHandler = (_ transaction: ListReorderingTransaction<SectionType, ItemType>) -> Void
    
    public
    typealias CanInsertItemIntoSectionHandler = (_ item: ItemType, _ section: SectionType) -> Bool
    public
    typealias DidInsertItemIntoSectionHandler = (_ item: ItemType, _ section: SectionType) -> Void
    
    public
    typealias CanCollapseSectionHandler = (_ section: SectionType, _ header: ItemType) -> Bool
    public
    typealias DidCollapseSectionHandler = (_ section: SectionType, _ header: ItemType) -> Void
    
    public
    typealias CanExpandSectionHandler = (_ section: SectionType, _ header: ItemType) -> Bool
    public
    typealias DidExpandSectionHandler = (_ section: SectionType, _ header: ItemType) -> Void
    
    public
    typealias SwipeActionsHandler = (_ item: ItemType) -> ListSwipeActionsConfiguration
    
    public
    typealias InitialFirstResponderHandler = () -> ItemType?
    public
    typealias SubsequentFirstResponderHandler = (_ currentResponder: ItemType) -> ItemType?
    
    public
    typealias RowProvider = (_ section: Model.SectionType, _ item: Model.ItemType, _ listState: ListState<ItemType>, _ configurationState: UICellConfigurationState) -> SListRowData
}
