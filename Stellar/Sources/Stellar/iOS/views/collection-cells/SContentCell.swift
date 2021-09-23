//
//  SContentCell.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine
import SwiftUI

/// Content is provided using a `UIContentConfiguration`. Content views are checked for dynamic size changes through `SDynamicSizeNotifier` and responders through `SRespondable`.
///
/// # Configuration and Updating
///
/// If you need to update your configuration when configuration state changes use the method `onConfigurationStateChange(:)` to provide a handler closure. This closure is called each time the configuration state changes in order to update this cell's state and appearance. Update your configuration using the provided state and return a prepared `...`.
///
/// # Embedded Responders
///
/// This cell conforms to `SRespondable` and acts as a passthrough for messages while replacing the `sender` property of the `ResponderState` instance with an instance of self. If the content view does not conform to `SRespondable`, nothing will happen. If you change the configuration or content view be sure to recreate your subscriptions with the updated publishers.
///
/// # Embedded Dynamically Sizing Content
///
/// This cell conforms to `SDynamicSizeNotifier` and acts as a passthrough for messages while replacing the output of the messages with an instance of self. If you change the configuration or content view be sure to recreate your subscriptions with the updated publishers. The published object is an instance of this class.
///
final
class SContentCell: UICollectionViewListCell, SDynamicSizeNotifier, SRespondable {
	
    /// Call this handler when a configuration update is requested.
    /// The handler returns an updated `CellState` instance which will be applied to the cell during updates.
    private
    lazy var _configurationUpdateHandler: CellStateUpdateHandler = { state in
        .makeDefaultState()
    }
    
    /// The state applied to this cell instance.
    ///
    /// Setting this property will cause the cell to update its content.
    private
    var _content = Content.makeDefaultState() {
        didSet {
            updateWithState(_content)
        }
    }
    
    // -- init
    
    override
    init(frame: CGRect) {
        super.init(frame: frame)
        
        // Disable automatic updates to apply them manually in updateConfiguration(using:), according to Apple documentation.
        automaticallyUpdatesContentConfiguration = false
        automaticallyUpdatesBackgroundConfiguration = false
    }
    
    @available(*, unavailable)
    required
    init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override
    func prepareForReuse() {
        super.prepareForReuse()
        
        /// Reset to base state in case clients do not update properties.
        _configurationUpdateHandler = { state in
            .makeDefaultState()
        }
        setNeedsUpdateConfiguration()
    }
    
    /// Updates the cell configuration using the provided state. Don't call this method directly, instead call setNeedsUpdateConfiguration() to schedule an update if state has changed which affects cell content configuration.
    /// - Note: This method calls the configuration update handler.
    override
    func updateConfiguration(using state: UICellConfigurationState) {
        let updatedCellState = _configurationUpdateHandler(state)
        _content = updatedCellState
            .updated(for: configurationState)
    }
}

// MARK: - state updating
private
extension SContentCell {
    
    /// Updates `self` using the `Content`.
    func updateWithState(_ state: Content) {
        contentConfiguration = state.contentConfiguration
        backgroundConfiguration = state.backgroundConfiguration
        accessories = state.accessories
    }
}

// MARK: - api
extension SContentCell {
    
    // -- cell content
    /// Set this property to immediately update the cell's content. The value of the property is the content that is currently applied to the cell.
    var content: Content {
        get { _content }
        set { _content = newValue }
    }
    
    /// Handle state changes by updating your configuration.
    @discardableResult
    func onConfigurationStateChange(_ handler: @escaping CellStateUpdateHandler) -> Self {
        _configurationUpdateHandler = handler
        return self
    }
    
    // -- taps
    /// A handler that is called when a tap is received by a list item (when not editing).
    var tapHandler: SHashableClosure? {
        get { _content.tapHandler }
        set { _content.tapHandler = newValue }
    }
    
    func canTap() -> Bool {
        _content.tapHandler != nil
    }
    func didTap() {
        _content.tapHandler?()
    }
    
    // -- selection
    
    func canSelect() -> Bool {
        _content.isEditingSelectable
    }
}

// MARK: - dynamic size content
extension SContentCell {
    
    /// A helper which returns the content view cast to `SDynamicSizeNotifier`.
    private
    var dynamicSizeContentView: SDynamicSizeNotifier? {
        contentView as? SDynamicSizeNotifier
    }
    
    var sizeDidChangePublisher: AnyPublisher<Any, Never> {
        dynamicSizeContentView?
            .sizeDidChangePublisher
            .map { _ in
                self
            }
            .eraseToAnyPublisher()
            ?? Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}

// MARK: - respondable
extension SContentCell {
    
    /// A helper which returns the content view cast to `SRespondable`.
    private
    var respondableContentView: SRespondable? {
        contentView as? SRespondable
    }
    
    var responderStatus: ResponderState.Status {
        respondableContentView?.responderStatus ?? .resigned
    }
    
    var responderStatusPublisher: AnyPublisher<ResponderState, Never> {
        respondableContentView?
            .responderStatusPublisher
            .map({ [unowned self] responderState in
                responderState
                    .replacingSenderWith(self)
            })
            .eraseToAnyPublisher()
            ?? Empty(completeImmediately: true).eraseToAnyPublisher()
    }
    
    func becomeResponder() -> Bool {
        respondableContentView?.becomeResponder() ?? false
    }
    
    func stopResponding() -> Bool {
        respondableContentView?.stopResponding() ?? true
    }
}

// MARK: - typealiases
extension SContentCell {
    typealias CellStateUpdateHandler = (UICellConfigurationState) -> Content
    typealias Content = UIKitRenderableContent
}
