//
//  UIKitCollectionView.swift
//  
//
//  Created by Jesse Spencer on 3/3/22.
//

import Foundation
import UIKit

final
class UIKitCollectionView: UICollectionView, UIKitTargetRenderableContent, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    /// The data source which drives state updates.
    private
    var collectionDataSource: UICollectionViewDiffableDataSource<UIKitSection, AnyHashable>!
    
    init(primitive: UIKitListPrimitive) {
        super.init(frame: .zero,
                   collectionViewLayout: UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped)))

        configureSelf()
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, AnyHashable> { cell, indexPath, itemIdentifier in
            // TODO: Configure cell instance.
            // TODO: Retrieve section
            fatalError()
        }
        collectionDataSource = .init(collectionView: self,
                                     cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: itemIdentifier)
        })
    }
    
    /// An init helper which sets up properties of self.
    private
    func configureSelf() {
        
        delegate = self
        
        // drag and drop
        dragDelegate = self
        dropDelegate = self
        dragInteractionEnabled = true
        
        translatesAutoresizingMaskIntoConstraints = false
        isPrefetchingEnabled = false
        allowsMultipleSelectionDuringEditing = true
        keyboardDismissMode = .interactive
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        guard let listPrimitive = primitive as? UIKitListPrimitive else {
            assertionFailure()
            return
        }
        
        updateSelections(listPrimitive.selectionValue ?? .init())
    }
    
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent?) {
        
        // TODO: Recognize UIKitForEach.
        // Use data to form snapshot. If structs - copy-on-write semantics should apply. If not, only references will be created.
        // When cells must be configured, use the section provided at that point to use its content for the cell.
        // When headers and footers must be created, retrieve the section data...
        
        guard let forEach = view as? UIKitForEach else {
            assertionFailure("Unexpected child added to \(self): \(view).")
            return
        }
        
        
        // -- old --
        guard let section = view as? UIKitSection else {
            assertionFailure("Unexpected child added to \(self): \(view).")
            return
        }
        
        var snapshot = collectionDataSource.snapshot()
        
        if let siblingView = siblingView,
        let siblingSection = siblingView as? UIKitSection {
            snapshot.insertSections([section],
                                    beforeSection: siblingSection)
        }
        else {
            snapshot.appendSections([section])
        }
        
        collectionDataSource.apply(snapshot)
    }
    func removeChild(_ view: UIKitTargetRenderableContent) {
        guard let section = view as? UIKitSection else {
            assertionFailure("Unexpected child added to \(self): \(view).")
            return
        }
        
        var snapshot = collectionDataSource.snapshot()
        snapshot.deleteSections([section])
        collectionDataSource.apply(snapshot)
    }
}
// MARK: - state updates
private
extension UIKitCollectionView {
    
    /// Immediately updates currently selected cells using provided snapshot identifiers.
    func updateSelections(_ selections: Set<AnyHashable>) {
        // TODO:
        fatalError()
    }
}
// MARK: - delegate
extension UIKitCollectionView {
    // TODO:
}
// MARK: - drag and drop delegate
extension UIKitCollectionView {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // TODO:
        []
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // TODO:
    }
}
