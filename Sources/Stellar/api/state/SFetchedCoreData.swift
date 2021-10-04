//
//  SFetchedCoreData.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Foundation
import CoreData
import SwiftUI
import Combine

@propertyWrapper
public
struct SFetchedCoreData<Result>
where Result : NSFetchRequestResult {
    
    let fetchRequest: NSFetchRequest<Result>
    
    private
    let fetchedResultsController: NSFetchedResultsController<Result>
    
    private
    let fetchedResultsControllerDelegate: FetchedResultsControllerDelegate
    
    /// Notifies that changes have ocurred in the context to the dataset.
    // TODO: This is public until the framework takes control of view tree updating. This temporarily allows clients to imperatively interface with updates.
    public
    let didChangePublisher = PassthroughSubject<Void, Never>()
    
    public
    var wrappedValue: [Result] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    public
    init(fetchRequest: NSFetchRequest<Result>,
         context: NSManagedObjectContext)
    where Result : NSFetchRequestResult {
        self.fetchRequest = fetchRequest
        self.fetchedResultsController = .init(fetchRequest: fetchRequest,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        fetchedResultsControllerDelegate = .init(didChangePublisher: didChangePublisher)
        fetchedResultsController.delegate = fetchedResultsControllerDelegate
    }
}

// MARK: - Create fetched core data with sort descriptors and a predicate.
public
extension SFetchedCoreData {
    
    init(sortDescriptors: [SortDescriptor<Result>],
         context: NSManagedObjectContext,
         predicate: NSPredicate? = nil) {
        
        let fetchRequest = NSFetchRequest<Result>()
        fetchRequest.sortDescriptors = sortDescriptors
            .map { NSSortDescriptor($0) }
        fetchRequest.predicate = predicate
        
        self.init(fetchRequest: fetchRequest,
                  context: context)
    }
}

// MARK: - conformance
extension SFetchedCoreData: SDynamicProperty
where Result : NSFetchRequestResult {
    
    public
    func update() {
        // Update fetched results.
        do {
            try fetchedResultsController.performFetch()
        } catch let e as NSError {
            assertionFailure(e.description)
        }
    }
}

// MARK: - helper class
extension SFetchedCoreData {
    
    final
    class FetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        
        let didChangePublisher: PassthroughSubject<Void, Never>
        
        init(didChangePublisher: PassthroughSubject<Void, Never>) {
            self.didChangePublisher = didChangePublisher
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            didChangePublisher.send()
        }
    }
}

