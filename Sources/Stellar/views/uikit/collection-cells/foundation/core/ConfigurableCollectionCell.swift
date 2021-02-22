//
//  ConfigurableCollectionCell.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 10/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/// A cell whose content can be set using a UIContentConfiguration object.
///
/// Use `applyCustomContentConfiguration(_:UIContentConfiguration)` to apply a content configuration to the cell. If you need to do extra setup during configuration state updates, use the configuration update closure. This closure is called each time the content configuration or configuration state changes.
///
/// This cell conforms to ResponderNotifier and attempts to fullfill the requirements using the configuration content view. However, when receiving published UIResponder instances this cell replaces the recieved instance with self. This is to allow the containing collection view to correctly infer which cell corresponds to the published responder. If the content view does not conform to ResponderNotifier, nothing will happen.
public
class ConfigurableCollectionCell: DynamicSizeCollectionCell {
	// TODO: Remove state storage and updating.
	typealias State = [UIConfigurationStateCustomKey : AnyHashable]
	@available(*, deprecated)
	private var data: State = .init()
	@available(*, deprecated)
	func updateWith(_ stateKey: UIConfigurationStateCustomKey, value updatedValue: AnyHashable?) {
		data[stateKey] = updatedValue
		setNeedsUpdateConfiguration()
	}
	@available(*, deprecated)
	func updateWithStates(_ updatedState: State) {
		for key in updatedState.keys {
			updateWith(key, value: updatedState[key])
		}
	}

    public override var configurationState: UICellConfigurationState {
		var configurationState = super.configurationState
		for key in data.keys {
			configurationState[key] = data[key]
		}
		return configurationState
	}
	//
	
	// MARK: - config
	
	/// Applies the custom content configuration to the cell by embedding the content view.
	///
	/// Calling this causes the cell to schedule a content configuration update. If a configuration content view already exists it is updated with the new configuration, otherwise one is created using the configuration.
	/// - Warning: The first time this method is called the configuration content view is created. This means that any subsequent calls must provide a compatible configuration.
    public
	func applyCustomContentConfiguration(_ contentConfiguration: UIContentConfiguration) {
		customContentConfiguration = contentConfiguration
		if configurationContentView == nil {
			configurationContentView = contentConfiguration.makeContentView()
		}
		setNeedsUpdateConfiguration()
	}
	
	/// The custom content configuration used to create the configuration content view and update it during configuration state updates.
	private var customContentConfiguration: UIContentConfiguration?
	
	// content view
	/// This view is created after a custom content configuration is provided.
	private var configurationContentView: (UIView & UIContentView)?
	
	// MARK: view lifecycle
	
	// update handler
    public
	typealias ConfigurationUpdateHandler = (UICellConfigurationState, ConfigurableCollectionCell) -> Void
	/// The handler for updating cell configuration using the provided state.
    public
	var updateConfigurationForStateIn: ConfigurationUpdateHandler = { _, _ in
		debugPrint("cell told to update for configuration state change without handler closure set")
	}
	
	/// Updates the cell configuration using the provided state. Don't call this method directly, instead call setNeedsUpdateConfiguration() to schedule an update if state has changed which affects cell content configuration.
	/// - Note: This method calls the configuration update handler.
    public override func updateConfiguration(using state: UICellConfigurationState) {
		configureCustomHierarchyIfNeeded()
		if let customContentConfig = customContentConfiguration {
			if let configurationContentView = configurationContentView {
				configurationContentView.configuration = customContentConfig
			}
			else {
				assertionFailure("Configuration content view does not exist.")
			}
		}
		updateConfigurationForStateIn(state, self)
	}
	
	/// A helper method which embeds the custom content view if it exists and has not yet been added as a subview.
	private func configureCustomHierarchyIfNeeded() {
		// If the content view is not nil and has not been added to the hierarchy.
		if let configurationContentView = configurationContentView, configurationContentView.superview == nil {
			contentView.addSubview(configurationContentView)
			configurationContentView.snp.makeConstraints { (make) in
				make.directionalEdges.equalToSuperview()
				make.top.bottom.equalToSuperview()
			}
		}
	}
	
	// MARK: - first responder passthrough
	
    public override var isFirstResponder: Bool {
		configurationContentView?.isFirstResponder ?? false
	}
	
	public override var canBecomeFirstResponder: Bool {
		configurationContentView?.canBecomeFirstResponder ?? false
	}
	
	public override func becomeFirstResponder() -> Bool {
		super.becomeFirstResponder()
		return configurationContentView?.becomeFirstResponder() ?? false
	}
	
    public override var canResignFirstResponder: Bool {
		configurationContentView?.canResignFirstResponder ?? true
	}
	
    public override func resignFirstResponder() -> Bool {
		super.resignFirstResponder()
		return configurationContentView?.resignFirstResponder() ?? true
	}
}
extension ConfigurableCollectionCell: ResponderNotifier {
	
	var didBecomeFirstResponderPublisher: AnyPublisher<UIResponder, Never> {
		if let contentView = configurationContentView {
			if let responderNotifierContentView = contentView as? ResponderNotifier {
				return responderNotifierContentView.didBecomeFirstResponderPublisher
					.map { _ in self as UIResponder }
					.eraseToAnyPublisher()
			}
		}
		else {
			warnPrematurePublisherAccess()
		}
		return PassthroughSubject<UIResponder, Never>().eraseToAnyPublisher()
	}
	
	var didResignFirstResponderPublisher: AnyPublisher<UIResponder, Never> {
		if let contentView = configurationContentView {
			if let responderNotifierContentView = contentView as? ResponderNotifier {
				return responderNotifierContentView.didResignFirstResponderPublisher
					.map { _ in self as UIResponder }
					.eraseToAnyPublisher()
			}
		}
		else {
			warnPrematurePublisherAccess()
		}
		return PassthroughSubject<UIResponder, Never>().eraseToAnyPublisher()
	}
	
	/// Prints a warning about ResponderNotifier publishers being accessed before available from the content configuration view.
	private func warnPrematurePublisherAccess() {
		debugPrint("\(self):")
		debugPrint("ResponderNotifier publisher was requested before the content configuration view was loaded. This will result in a blank publisher.")
	}
}
