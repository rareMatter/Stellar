//
//  SSearchBarDelegate.swift
//  
//
//  Created by Jesse Spencer on 3/28/21.
//

import UIKit

/// Delegates for UISearchBar and forwards requests through closures.
final
class SSearchBarDelegate: NSObject {
    
    // -- changes
    var shouldEnterText: SearchBarRequestHandler?
    var onTextChange: SearchBarEventHandler?
    
    // -- editing
    var shouldBeginEditing: SearchBarRequestHandler?
    var didBeginEditing: SearchBarEventHandler?
    
    var shouldEndEditing: SearchBarRequestHandler?
    var didEndEditing: SearchBarEventHandler?
    
    // -- controls
    var onCancel: SearchBarEventHandler?
    var onSearchClicked: SearchBarEventHandler?
    var onResultsListClicked: SearchBarEventHandler?
    
    // -- scope
    var onScopeChange: SearchBarScopeChangeHandler?
}

// MARK: - delegate
extension SSearchBarDelegate: UISearchBarDelegate {
    
    // -- changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onTextChange?(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        ((shouldEnterText?(searchBar)) != nil)
    }
    
    // -- editing
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        shouldBeginEditing?(searchBar) ?? true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        didBeginEditing?(searchBar)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        shouldEndEditing?(searchBar) ?? true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        didEndEditing?(searchBar)
    }
    
    // -- search controls
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onCancel?(searchBar)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        onSearchClicked?(searchBar)
    }
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        onResultsListClicked?(searchBar)
    }
    
    // -- scope
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        onScopeChange?(selectedScope, searchBar)
    }
}

// MARK: - typealiases
extension SSearchBarDelegate {
    
    typealias SearchBarRequestHandler = (_ searchBar: UISearchBar) -> Bool
    typealias SearchBarEventHandler = (_ searchBar: UISearchBar) -> Void
    typealias SearchBarScopeChangeHandler = (_ selectedScope: Int, _ searchBar: UISearchBar) -> Void
}
