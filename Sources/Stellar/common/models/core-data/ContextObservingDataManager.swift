//
//  ContextObservingDataManager.swift
//  Stellar
//
//  Created by Jesse Spencer on 6/26/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import CoreData
import Combine

/// Observes a context for changes to a data set determined by a predicate.
public
final class ContextObservingDataManager<DataType: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
	
	private typealias FetchedResultsController = NSFetchedResultsController<DataType>
	private let fetchedResultsController: FetchedResultsController
	
	// changes subject
	private lazy var changesSubject = PassthroughSubject<Changes<DataType>, Never>()
	
	// MARK: - init
	
    public
	init(with fetchRequest: NSFetchRequest<DataType>, for context: NSManagedObjectContext) {
		self.fetchedResultsController = FetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		
		super.init()
		
		fetchedResultsController.delegate = self
		performFetchWith(controller: fetchedResultsController)
	}
	
	@discardableResult
	private func performFetchWith(controller: FetchedResultsController) -> [DataType] {
		do {
			try fetchedResultsController.performFetch()
		} catch let e as NSError {
			assertionFailure(e.description)
		}
		return fetchedResultsController.fetchedObjects ?? []
	}
	
	// MARK: - controller delegate
	
	/// All changes that occured during a given update loop.
	private var changes = Changes<DataType>()
	
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		changes.originalData = self.data
	}

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		guard let object = anObject as? DataType
			else { fatalError() }
		
		switch type {
		case .update:
			changes.updated.append(object)
		case .move:
			changes.moved.append(object)
		case .insert:
			changes.inserted.append(object)
		case .delete:
			changes.removed.append(object)
		@unknown default:
			fatalError("Unimplemented case: \(type), \(#function)")
		}
	}
	
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		// finalize changes and publish
		changes.resultingData = self.data
		changesSubject.send(self.changes)
		cleanupUpdateSession()
	}
	
	/// Performs cleanup after an update session has completed.
	private func cleanupUpdateSession() {
		changes = Changes()
	}
}
// MARK: api
public
extension ContextObservingDataManager {

	var changesPublisher: AnyPublisher<Changes<DataType>, Never> {
		changesSubject.eraseToAnyPublisher()
	}
	
	var data: [DataType] {
		fetchedResultsController.fetchedObjects ?? []
	}
	
	/// Updates the results using the new predicate.
	/// - Note: This method does not cause changes to be published.
	func refreshWithPredicate(_ newPredicate: NSPredicate) {
		fetchedResultsController.fetchRequest.predicate = newPredicate
		performFetchWith(controller: fetchedResultsController)
	}
}
public
struct Changes<DataType> {
	/// All added objects.
    public var inserted: [DataType] = []
	
	/// All removed objects.
    public var removed: [DataType] = []
	
	/// Objects whose indexed location changed in the observed collection.
    public var moved: [DataType] = []
	
	/// Data which changed due to property changes.
    public var updated: [DataType] = []
	
	/// The data before changes were made.
    public var originalData: [DataType] = []
	/// The resulting data following the changes.
    public var resultingData: [DataType] = []
}
extension Changes: Equatable where DataType : Equatable {}
