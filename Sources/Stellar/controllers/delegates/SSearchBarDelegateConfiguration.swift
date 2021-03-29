//
//  SSearchBarDelegateConfiguration.swift
//  
//
//  Created by Jesse Spencer on 3/28/21.
//

import UIKit

/// Delegates for UISearchBar and forwards requests through closures.
final
class SSearchBarDelegateConfiguration: NSObject {
    
    var searchTextDidChangeHandler: SearchBarEventHandler = {_ in}
    
}

// MARK: - delegate
extension SSearchBarDelegateConfiguration: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextDidChangeHandler(searchBar)
    }
}

// MARK: - typealiases
extension SSearchBarDelegateConfiguration {
    
    typealias SearchBarRequestHandler = (_ searchBar: UISearchBar) -> Bool
    typealias SearchBarEventHandler = (_ searchBar: UISearchBar) -> Void
}
