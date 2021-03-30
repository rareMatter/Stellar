//
//  TextViewDelegateConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 11/6/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/// Delegates for a UITextView and forwards requests through closures. Events are also published through corresponding publishers.
final
class TextViewDelegateConfiguration: NSObject {
	
    typealias TextViewRequestHandler = (_ textView: UITextView) -> Bool
    typealias TextViewEventHandler = (UITextView) -> Void
	
	// -- editing
    var shouldBeginEditing: TextViewRequestHandler = { _ in true }
    var shouldEndEditing: TextViewRequestHandler = { _ in true }

	let didBeginEditingPublisher = PassthroughSubject<UITextView, Never>()
    var didBeginEditing: TextViewEventHandler = { _ in }
	
	let didEndEditingPublisher = PassthroughSubject<UITextView, Never>()
    var didEndEditing: TextViewEventHandler = { _ in }

	// -- changes
	let didChangePublisher = PassthroughSubject<UITextView, Never>()
    var didChange: TextViewEventHandler = { _ in }
	
	let didChangeSelectionPublisher = PassthroughSubject<UITextView, Never>()
    var didChangeSelection: TextViewEventHandler = { _ in }
}

// MARK: - delegate

extension TextViewDelegateConfiguration: UITextViewDelegate {
    // -- editing
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        shouldBeginEditing(textView)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditing(textView)
        didBeginEditingPublisher.send(textView)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        shouldEndEditing(textView)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditing(textView)
        didEndEditingPublisher.send(textView)
    }
    
    // -- changes
    
    func textViewDidChange(_ textView: UITextView) {
        didChange(textView)
        didChangePublisher.send(textView)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        didChangeSelection(textView)
        didChangeSelectionPublisher.send(textView)
    }
}
