//
//  _SContentView.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/1/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/** A content view which provides hooks for creating and updating custom content using a corresponding content configuration.
 
 By accepting a generic configuration property, type equality is enforced in order to make updates more efficient.
 
 # Dynamic Sizing
 
 This view conforms to `SDynamicSizeNotifier` and publishes using a provided `SDynamicSizeNotifier` or creates an empty publisher.

 # Responding
 
 This view conforms to `SRespondable` and, when provided an `SRespondable` object during creation, will act as a passthrough to the provided object. Containing views or view controllers can then watch and control the embedded responder through this view.
 
 - Note: Updating this content view with a configuration of different type than its generic parameter will throw an assertion.
*/
final
class _SContentView<Configuration>: UIView, UIContentView, SDynamicSizeNotifier, SRespondable
where Configuration: UIContentConfiguration & Equatable {
    
    // -- config
    var configuration: UIContentConfiguration {
        get { state.configuration }
        set {
            guard let newConfig = newValue as? Configuration else {
                assertionFailure("Expected \(Configuration.self).")
                return
            }
            state.updateConfiguration(newConfig, for: self)
        }
    }
    
    // -- intrinsic content size
    override
    var intrinsicContentSize: CGSize {
        state.customIntrinsicContentSize ?? super.intrinsicContentSize
    }
    
    private
    var state: State
    
    // -- init
    
    private
    init(state: State,
         configureViewHierarchy: ViewHierarchyConfigurationHandler) {
        self.state = state
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        configureViewHierarchy(self)
        state.handleConfigurationUpdate(nil, state.configuration, self)
        setNeedsUpdateConstraints()
    }
    
    convenience
    init(configuration: Configuration,
         dynamicSizeContent: SDynamicSizeNotifier? = nil,
         responder: SRespondable? = nil,
         configureViewHierarchy: ViewHierarchyConfigurationHandler = {_ in },
         handleConstraintUpdate: @escaping ConstraintUpdateHandler = {_,_ in },
         intrinsicContentSizeProvider: @escaping IntrinsicContentSizeProvider = { nil },
         handleConfigurationUpdate: @escaping ConfigurationUpdateHandler = {_,_,_ in }) {
        let state = State(configuration: configuration,
                          dynamicSizeContent: dynamicSizeContent,
                          responder: responder,
                          handleConstraintUpdate: handleConstraintUpdate,
                          intrinsicContentSizeProvider: intrinsicContentSizeProvider,
                          handleConfigurationUpdate: handleConfigurationUpdate)
        self.init(state: state, configureViewHierarchy: configureViewHierarchy)
    }
    
    @available(*, unavailable)
    required
    init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // -- constraints
    override
    func updateConstraints() {
        invalidateIntrinsicContentSize()
        state.handleConstraintUpdate(self, state.needsConstraintsSetup)
        state.needsConstraintsSetup = false
        super.updateConstraints()
    }
}

// MARK: dynamic size notifier
extension _SContentView {
    
    var sizeDidChangePublisher: AnyPublisher<Any, Never> {
        state.dynamicSizeContent?.sizeDidChangePublisher ??
            .init(Empty(completeImmediately: true))
    }
}

// MARK: - respondable
extension _SContentView {
    
    var responderStatus: ResponderState.Status {
        state.responder?.responderStatus ??
            .resigned
    }
    
    var responderStatusPublisher: AnyPublisher<ResponderState, Never> {
        state.responder?
            .responderStatusPublisher
            .map { state -> ResponderState in
                .init(responder: state.responder, sendingResponder: self, status: state.status)
            }
            .eraseToAnyPublisher()
            ?? .init(Empty(completeImmediately: true))
    }
    
    func becomeResponder() -> Bool {
        state.responder?.becomeResponder()
            ?? false
    }
    
    func stopResponding() -> Bool {
        state.responder?.stopResponding()
            ?? true
    }
}

// MARK: - helper types
extension _SContentView {
    
    struct State {
        
        let dynamicSizeContent: SDynamicSizeNotifier?
        let responder: SRespondable?
        
        /// The current configuration.
        private(set)
        var configuration: Configuration
        
        // -- creation and update handlers
        /// A closure that is called after the configuration is updated.
        let handleConfigurationUpdate: ConfigurationUpdateHandler
        
        /// Called during constraint updates.
        let handleConstraintUpdate: ConstraintUpdateHandler
        
        /// Used to update `customIntrinsicContentSize`.
        private
        let intrinsicContentSizeProvider: IntrinsicContentSizeProvider
        /// Updated by calling the matching handler closure.
        var customIntrinsicContentSize: CGSize? {
            intrinsicContentSizeProvider()
        }
        
        /// Whether the constraints have been configured.
        var needsConstraintsSetup = true
        
        init(configuration: Configuration,
             dynamicSizeContent: SDynamicSizeNotifier?,
             responder: SRespondable?,
             handleConstraintUpdate: @escaping ConstraintUpdateHandler,
             intrinsicContentSizeProvider: @escaping IntrinsicContentSizeProvider,
             handleConfigurationUpdate: @escaping ConfigurationUpdateHandler) {
            self.configuration = configuration
            self.dynamicSizeContent = dynamicSizeContent
            self.responder = responder
            self.handleConfigurationUpdate = handleConfigurationUpdate
            self.handleConstraintUpdate = handleConstraintUpdate
            self.intrinsicContentSizeProvider = intrinsicContentSizeProvider
        }
        
        /// Updates the current configuration and makes appropriate callbacks.
        mutating
        func updateConfiguration(_ updatedConfiguration: Configuration, for contentView: _SContentView<Configuration>) {
            handleConfigurationUpdate(self.configuration, updatedConfiguration, contentView)
            self.configuration = updatedConfiguration
        }
    }
}

// MARK: - typealiases
extension _SContentView {
    typealias ConfigurationUpdateHandler = (_ from: Configuration?, _ to: Configuration, _ contentView: UIView) -> Void
    typealias ViewHierarchyConfigurationHandler = (_ contentView: UIView) -> Void
    typealias ConstraintUpdateHandler = (_ contentView: UIView, _ isFirstSetup: Bool) -> Void
    typealias IntrinsicContentSizeProvider = () -> CGSize?
}
