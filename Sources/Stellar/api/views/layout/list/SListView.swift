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
    var rowProvider: RowProvider
    
    // -- title bar (nav bar)
    var titleBarView: STitleBarView?
    
    /// Creates the view with a model that drives updates.
    public
    init(listModel: Model, listState: State = .init(), layout: UICollectionViewLayout? = nil, rowProvider: @escaping RowProvider) {
        self.listModel = listModel
        self.listState = listState
        self.layout = layout
        self.rowProvider = rowProvider
    }
    
    /// Creates the view using an unchanging snapshot.
    public
    init(snapshot: Model.Snapshot, listState: State = .init(), layout: UICollectionViewLayout? = nil, rowProvider: @escaping RowProvider) {
        let model = SStaticListModel(staticSnapshot: snapshot)
        self.init(listModel: model as! Model, listState: listState, layout: layout, rowProvider: rowProvider)
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
        { (section: SectionType, item: ItemType, listState: ViewController.State) in
            UICollectionView.CellRegistration<ConfigurableCollectionCell, ItemType> { (configurableCollectionCell: ConfigurableCollectionCell, indexPath, item) in
                // -- first-time setup
                let listRow = rowProvider(section, item, listState, configurableCollectionCell.configurationState)
                updateCell(configurableCollectionCell, listRow: listRow)
                
                // -- updating for configuration state
                configurableCollectionCell.onConfigurationStateChange { (configState) in
                    let listRow = rowProvider(section, item, listState, configState)
                    updateCell(configurableCollectionCell, listRow: listRow)
                }
            }
        }
        
        // -- nav bar setup
        if let titleBarView = titleBarView {
            controller.navigationItem.copy(propertiesFrom: titleBarView.content)
        }
        
        return titleBarView != nil ?
            NLNavigationController(rootViewController: controller) :
            controller
    }
    
    /// Applies updated configuration properties to the cell using the SListRow.
    private
    func updateCell(_ cell: ConfigurableCollectionCell, listRow: SListRow) {
        cell.contentConfiguration = listRow.contentConfiguration
        cell.backgroundConfiguration = listRow.backgroundConfiguration
        cell.accessories = listRow.accessories
        cell.tapHandler = listRow.tapHandler
        if listRow.isSelectable {
            cell.selectionHandler = {}
        }
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
    
    typealias RowProvider = (_ section: Model.SectionType, _ item: Model.ItemType, _ listState: ListState<ItemType>, _ configurationState: UICellConfigurationState) -> SListRow
}
extension SListView {
    typealias ViewController = ListViewController<Model, Self>
}
