//
//  TextViewDelegateConfiguration.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 11/6/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/// Delegates for a UITextView and forwards requests through closures. Events are also published through corresponding publishers.
public
final class TextViewDelegateConfiguration: NSObject, UITextViewDelegate {
	
    public typealias TextViewRequestHandler = (_ textView: UITextView) -> Bool
    public typealias TextViewEventHandler = (UITextView) -> Void
	
	// -- editing
	private let shouldBeginEditing: TextViewRequestHandler
	private let shouldEndEditing: TextViewRequestHandler

	private let _didBeginEditingPublisher = PassthroughSubject<UITextView, Never>()
    public var didBeginEditingPublisher: AnyPublisher<UITextView, Never> {
		_didBeginEditingPublisher.eraseToAnyPublisher()
	}
	private let didBeginEditing: TextViewEventHandler
	
	private let _didEndEditingPublisher = PassthroughSubject<UITextView, Never>()
    public var didEndEditingPublisher: AnyPublisher<UITextView, Never> {
		_didEndEditingPublisher.eraseToAnyPublisher()
	}
	private let didEndEditing: TextViewEventHandler

	// -- changes
	private let _didChangePublisher = PassthroughSubject<UITextView, Never>()
    public var didChangePublisher: AnyPublisher<UITextView, Never> {
		_didChangePublisher.eraseToAnyPublisher()
	}
	private let didChange: TextViewEventHandler
	
	private let _didChangeSelectionPublisher = PassthroughSubject<UITextView, Never>()
    public var didChangeSelectionPublisher: AnyPublisher<UITextView, Never> {
		_didChangeSelectionPublisher.eraseToAnyPublisher()
	}
	private let didChangeSelection: TextViewEventHandler
	
	// MARK: - init
    public 
	init(shouldBeginEditing: @escaping TextViewRequestHandler = { _ in true }, shouldEndEditing: @escaping TextViewRequestHandler = { _ in true }, didBeginEditing: @escaping TextViewEventHandler = {_ in }, didEndEditing: @escaping TextViewEventHandler = {_ in }, didChange: @escaping TextViewEventHandler = {_ in }, didChangeSelection: @escaping TextViewEventHandler = {_ in }) {
		self.shouldBeginEditing = shouldBeginEditing
		self.shouldEndEditing = shouldEndEditing
		self.didBeginEditing = didBeginEditing
		self.didEndEditing = didEndEditing
		self.didChange = didChange
		self.didChangeSelection = didChangeSelection
	}
	
	// MARK: delegation
	
	// -- editing
	
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		shouldBeginEditing(textView)
	}
    public func textViewDidBeginEditing(_ textView: UITextView) {
		didBeginEditing(textView)
		_didBeginEditingPublisher.send(textView)
	}
	
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		shouldEndEditing(textView)
	}
    public func textViewDidEndEditing(_ textView: UITextView) {
		didEndEditing(textView)
		_didEndEditingPublisher.send(textView)
	}
	
	// -- changes
	
    public func textViewDidChange(_ textView: UITextView) {
		didChange(textView)
		_didChangePublisher.send(textView)
	}
	
    public func textViewDidChangeSelection(_ textView: UITextView) {
		didChangeSelection(textView)
		_didChangeSelectionPublisher.send(textView)
	}
}
