//
//  ListSwipeActions.swift
//  Stellar
//
//  Created by Jesse Spencer on 8/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

// MARK: - configuration
/// A type for creating swipe actions in a list view.
public
struct ListSwipeActionsConfiguration {
	public var actions: [ListSwipeAction]
	public var performsFirstActionWithFullSwipe: Bool
    
    public
    init(actions: [ListSwipeAction] = [], performsFirstActionWithFullSwipe: Bool = false) {
        self.actions = actions
        self.performsFirstActionWithFullSwipe = performsFirstActionWithFullSwipe
    }
}
// MARK: - bridging
extension ListSwipeActionsConfiguration {
	/// Creates a UISwipeActionsConfiguration by bridging the receiver.
	/// A closure is required to wrap the handler of each ContextualAction with the handler of the created UIContextualAction for each, providing a completion handler from the caller.
	func bridgeToUISwipeActionsConfiguration(withDataForAction: (_ action: ListSwipeAction) -> (listMode: ListMode, completionHandler: ListSwipeAction.CompletionHandler)) -> UISwipeActionsConfiguration {
		
		let config = UISwipeActionsConfiguration(actions: self.actions.map { action in
			let dataForAction = withDataForAction(action)
			return action.bridgeToUIContextualAction(using: dataForAction.listMode, withCompletionHandler: dataForAction.completionHandler)
		})
		config.performsFirstActionWithFullSwipe = self.performsFirstActionWithFullSwipe
		
		return config
	}
}

// MARK: - actions
/// An action that is associated with a list row swipe action.
public
struct ListSwipeAction {
	
    public
	typealias Handler = (_ action: ListSwipeAction, _ sourceView: UIView, _ listMode: ListMode, _ completionHandler: @escaping CompletionHandler) -> Void
    public
	typealias CompletionHandler = (_ actionPerformed: Bool) -> Void
	
	/// The visual style applied to the action.
	var style: UIContextualAction.Style
	/// This type determines how a completed action is handled by the list. Actions that are not completed do not consult this value.
	var completionAction: CompletionAction = .none
	
	var title: String? = nil
	var backgroundColor: UIColor? = nil
	var image: UIImage? = nil
	
	var handler: Handler
}
// MARK: - supporting types
public
extension ListSwipeAction {
	enum CompletionAction {
		/// No completion action is performed.
		case none
	}
}
// MARK: - bridging
extension ListSwipeAction {
	/** Bridges the receiver into a UIContextualAction.
	
	Calls the handler of self using the provided ListState and completion handler.
	*/
	func bridgeToUIContextualAction(using listMode: ListMode, withCompletionHandler chainedCompletion: @escaping (_ actionPerformed: Bool) -> Void) -> UIContextualAction {
		
		let uiContextualAction = UIContextualAction(style: self.style, title: self.title, handler: { (action, sourceView, completion) in
			self.handler(self, sourceView, listMode) { actionPerformed in
				completion(actionPerformed)
				chainedCompletion(actionPerformed)
			}
		})
		
		if let backgroundColor = self.backgroundColor {
			uiContextualAction.backgroundColor = backgroundColor
		}
		uiContextualAction.image = self.image
		
		return uiContextualAction
	}
}
