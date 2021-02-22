//
//  ManagedObjectContextExtensions.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 12/4/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import CoreData

public extension NSManagedObjectContext {
	
	/// Returns a new context on the main queue whose parent is the receiver.
	func createChildContext() -> NSManagedObjectContext {
		let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		childContext.parent = self
		return childContext
	}
		
	/// Attempts to save the context. Catches any thrown error and prints it, throwing an assertionFailure instead. Returns true if successful.
	@discardableResult func attemptSave() -> Bool {
		
		guard self.hasChanges else { return true }
		
		do {
			try self.save()
			return true
		} catch let error as NSError {
			print("Unable to save context: \(error), \(error.userInfo)")
			assertionFailure()
			return false
		}
	}
	
}
