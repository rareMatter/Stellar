//
//  _UIKitSearchTextField.swift
//  
//
//  Created by Jesse Spencer on 2/24/22.
//

import Foundation
import UIKit

/// A text field which accepts closure handlers for interactions.
class _UIKitSearchTextField: UISearchTextField, UITextFieldDelegate, UISearchTextFieldDelegate {
    
    private
    var searchText: String {
        text ?? ""
    }
    
    // MARK: handlers
    var textDidChange: (_ text: String) -> Void = { _ in }
    var onReturn: (_ text: String) -> Void = { _ in }
    
    // MARK: delegation
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textDidChange(searchText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn(searchText)
        return true
    }
}
