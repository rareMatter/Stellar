//
//  UIKitCollectionView.swift
//  
//
//  Created by Jesse Spencer on 3/3/22.
//

import Foundation
import UIKit
import StellarFoundation

final
class UIKitCollectionView: UICollectionView, UIKitContent, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    /// The data source which drives state updates.
    private
    var collectionDataSource: UICollectionViewDiffableDataSource<UIKitSection, AnyHashable>!
    
    var modifiers: [UIKitContentModifier] = []
    
    init(modifiers: [UIKitContentModifier]) {
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
        
        applyModifiers(modifiers)
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
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        switch primitiveContent.type {
        case .section(let anySection):
            let section = anySection.makeUIKitSection(modifiers: modifiers.uiKitModifiers())
            addSection(section, sibling: sibling)
            return section
        
        default:
            fatalError()
        }
    }
    private func addSection(_ section: UIKitSection, sibling: PlatformContent?) {
        var snapshot = collectionDataSource.snapshot()
        
        if let siblingSection = sibling as? UIKitSection {
            snapshot.insertSections([section],
                                    beforeSection: siblingSection)
        }
        else {
            snapshot.appendSections([section])
        }
        
        collectionDataSource.apply(snapshot)
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard case .list(let anyList) = primitiveContent.type else { fatalError() }
        updateSelections(anyList.selectionSet)
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    func removeChild(_ child: PlatformContent,
                     for task: UnmountHostTask) {
        guard let section = child as? UIKitSection else {
            fatalError("Unexpected child added to \(self): \(child).")
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
extension UIKitCollectionView {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        UIView.applyModifiers(modifiers, toView: self)
    }
}

extension SListView: UIKitRenderable {
    public func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitCollectionView(modifiers: modifiers)
    }
}
