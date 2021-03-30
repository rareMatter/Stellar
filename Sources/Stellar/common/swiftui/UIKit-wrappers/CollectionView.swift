//
//  CollectionView.swift
//  Stellar
//
//  Created by Jesse Spencer on 11/11/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

protocol CollectionCell {
	static var reuseID: String { get }
}

/**
A SwiftUI wrapper for UICollectionView which utilizes a UICompositionalLayout object.
*/
struct CollectionView<Cell: UICollectionViewCell & CollectionCell, SectionType: Hashable & CaseIterable, DataObject: Hashable>: UIViewRepresentable {
	typealias UIViewType = UICollectionView
	
	@Binding var snapshot: NSDiffableDataSourceSnapshot<SectionType, DataObject>
	
	var cellProvider: UICollectionViewDiffableDataSource<SectionType, DataObject>.CellProvider
	
	var layout: UICollectionViewCompositionalLayout
	
	init(snapshot: Binding<NSDiffableDataSourceSnapshot<SectionType, DataObject>>, layout: UICollectionViewCompositionalLayout, cellProvider: @escaping UICollectionViewDiffableDataSource<SectionType, DataObject>.CellProvider) {
		self._snapshot = snapshot
		self.layout = layout
		self.cellProvider = cellProvider
	}
	
	func makeUIView(context: Context) -> UICollectionView {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor = .black
		collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseID)
		
		// Data source
		let dataSource = UICollectionViewDiffableDataSource<SectionType, DataObject>(collectionView: collectionView, cellProvider: cellProvider)
		
		context.coordinator.dataSource = dataSource
				
		return collectionView
	}
		
	func updateUIView(_ uiView: UICollectionView, context: Context) {
		let dataSource = context.coordinator.dataSource
		dataSource?.apply(self.snapshot, animatingDifferences: true) {
			// Completion handler.
		}
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}
	
	class Coordinator: NSObject, UICollectionViewDelegate {
		var parent: CollectionView<Cell, SectionType, DataObject>
		var dataSource: UICollectionViewDiffableDataSource<SectionType, DataObject>?
		var snapshot = NSDiffableDataSourceSnapshot<SectionType, DataObject>()
		
		init(_ parent: CollectionView<Cell, SectionType, DataObject>) {
			self.parent = parent
		}
				
	}
}

/// An object which provides bindable data for the CollectionView.
class CollectionViewDataProvider<SectionType: Hashable & CaseIterable, DataObject: Hashable>: ObservableObject {
	
	@Published var snapshot: NSDiffableDataSourceSnapshot<SectionType, DataObject> = {
		var snapshot = NSDiffableDataSourceSnapshot<SectionType, DataObject>()
		let sections = [SectionType](SectionType.allCases)
		snapshot.appendSections(sections)
		return snapshot
		}()
		{
		didSet {
			self.data = self.snapshot.itemIdentifiers
		}
	}
	
	var data = [DataObject]() {
		didSet {
			
		}
	}
}


#if DEBUG
// MARK: - Live Preview support
import CoreData

struct CollectionView_Previews: PreviewProvider {
	
	static var previews: some View {
		
		let collectionDataProvider = CollectionViewDataProvider<TestCollectionSections, TestCollectionDataObject>()
		
		let testData = TestCollectionDataObject()
		collectionDataProvider.data = [testData]
		collectionDataProvider.snapshot.appendItems([testData], toSection: .main)
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											  heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .absolute(44))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
													   subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		
		return
			CollectionView<TestCollectionViewCell, TestCollectionSections, TestCollectionDataObject>(snapshot: .init(get: { () -> NSDiffableDataSourceSnapshot<TestCollectionSections, TestCollectionDataObject> in
				return collectionDataProvider.snapshot
			}, set: { (snapshot) in
				collectionDataProvider.snapshot = snapshot
			}), layout: layout, cellProvider: { (collectionView, indexPath, dataObject) -> UICollectionViewCell? in
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: TestCollectionViewCell.reuseID,
					for: indexPath) as? TestCollectionViewCell else { fatalError("Could not create new cell") }
				
				cell.contentView.backgroundColor = .orange
				
				return cell
			})
	}
}

class TestCollectionViewCell: UICollectionViewCell, CollectionCell {
	static var reuseID: String = "testCell"
}

enum TestCollectionSections: CaseIterable {
	case main
}

class TestCollectionDataObject: Hashable {
	var id = UUID()
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: TestCollectionDataObject, rhs: TestCollectionDataObject) -> Bool {
		return lhs.id == rhs.id
	}
}
#endif
