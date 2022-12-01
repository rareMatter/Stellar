//
//  _UIKitSearchTextField.swift
//  
//
//  Created by Jesse Spencer on 2/24/22.
//

import Foundation
import UIKit

/// A text field which accepts closure handlers for interactions.
open
class _UIKitSearchTextField: UISearchTextField, UITextFieldDelegate, UISearchTextFieldDelegate {
    
    private
    var searchText: String {
        text ?? ""
    }
    
    // MARK: handlers
    public
    var textDidChange: (_ text: String) -> Void = { _ in }
    public
    var onReturn: (_ text: String) -> Void = { _ in }
    
    // MARK: delegation
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textDidChange(searchText)
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn(searchText)
        return true
    }
}
