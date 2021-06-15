//
//  STextView.swift
//  
//
//  Created by Jesse Spencer on 4/30/21.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/// A text view which accepts handlers for interactions.
class STextView: KMPlaceholderTextView, UITextViewDelegate, SDynamicSizeNotifier, SRespondable {

    // -- respondable
    private
    let _responderStatusPublisher: PassthroughSubject<ResponderState, Never> = .init()

    // -- size changes
    private
    let _sizeChangePublisher: PassthroughSubject<Any, Never> = .init()
    
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
    
    // -- init
    override
    init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
    }
    
    convenience
    init() {
        self.init(frame: .zero, textContainer: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - first responder messages
    
    override
    func becomeFirstResponder() -> Bool {
        let didRespond = super.becomeFirstResponder()
        /*
        if didRespond {
            _responderStatusPublisher
                .send(.responding(responder: self, sendingResponder: self))
        }
         */
        return didRespond
    }
    
    override
    func resignFirstResponder() -> Bool {
        let didResign = super.resignFirstResponder()
        /* This method is called by UIKit during view creation and therefore can be called without a matching precursor call to becomeFirstResponder(). Therefore is publishing is done here it is misleading to clients.
        if didResign {
            _responderStatusPublisher
                .send(.resigned(responder: self, sendingResponder: self))
        }
        */
        return didResign
    }
}

// MARK: - delegate
extension STextView {
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
        _sizeChangePublisher.send(self)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        didChangeSelection(textView)
        didChangeSelectionPublisher.send(textView)
    }
}

// MARK: - dynamic size
extension STextView {
    
    var sizeDidChangePublisher: AnyPublisher<Any, Never> {
        _sizeChangePublisher.eraseToAnyPublisher()
    }
}

// MARK: - respondable
extension STextView {
    
    var responderStatus: ResponderState.Status {
        isFirstResponder ?
            .responding : .resigned
    }
    
    var responderStatusPublisher: AnyPublisher<ResponderState, Never> {
        _responderStatusPublisher
            .eraseToAnyPublisher()
    }
    
    func becomeResponder() -> Bool {
        let didRespond = becomeFirstResponder()
        if didRespond {
            _responderStatusPublisher
                .send(.responding(responder: self, sendingResponder: self))
        }
        return didRespond
    }
    
    func stopResponding() -> Bool {
        let didResign = resignFirstResponder()
        if didResign {
            _responderStatusPublisher
                .send(.resigned(responder: self, sendingResponder: self))
        }
        return didResign
    }
}

// MARK: - typealiases
extension STextView {
    typealias TextViewRequestHandler = (_ textView: UITextView) -> Bool
    typealias TextViewEventHandler = (UITextView) -> Void
}
