//
//  SSearchBarView.swift
//  
//
//  Created by Jesse Spencer on 4/30/21.
//

import UIKit
import Combine

class SSearchBarView: UISearchBar, UISearchBarDelegate, SRespondable {
    
    // -- respondable
    private
    let _responderStatusPublisher: PassthroughSubject<ResponderState, Never> = .init()
    
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
    
    // -- init
    override
    init(frame: CGRect) {
        super.init(frame: .zero)
        delegate = self
    }
    
    convenience
    init() {
        self.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - first responder messages
    
    override
    func becomeFirstResponder() -> Bool {
        let didRespond = super.becomeFirstResponder()
        if didRespond {
            _responderStatusPublisher
                .send(.responding(responder: self, sendingResponder: self))
        }
        return didRespond
    }
    
    override
    func resignFirstResponder() -> Bool {
        let didResign = super.resignFirstResponder()
        if didResign {
            _responderStatusPublisher
                .send(.resigned(responder: self, sendingResponder: self))
        }
        return didResign
    }
}

// MARK: - delegate
extension SSearchBarView {
    
    // -- changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onTextChange?(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        shouldEnterText?(searchBar) ?? true
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

// MARK: - dynamic size
extension SSearchBarView {
    var sizeDidChangePublisher: AnyPublisher<Any, Never> {
        Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}

// MARK: - respondable
extension SSearchBarView {
    
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
extension SSearchBarView {
    typealias SearchBarRequestHandler = (_ searchBar: UISearchBar) -> Bool
    typealias SearchBarEventHandler = (_ searchBar: UISearchBar) -> Void
    typealias SearchBarScopeChangeHandler = (_ selectedScope: Int, _ searchBar: UISearchBar) -> Void
}

