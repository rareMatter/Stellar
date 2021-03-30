//
//  ConfigurableCollectionCell.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/// A cell whose content can be set using a UIContentConfiguration object.
///
/// If you need to update your configuration when configuration state changes use the method `onConfigurationStateChange(:)` to provide a handler closure. This closure is called each time the content configuration or configuration state changes.
///
/// This cell conforms to ResponderNotifier and attempts to fullfill the requirements using the configuration content view. However, when receiving published UIResponder instances from the content view, the instance is replaced with an instance of self. This allows the containing collection view to correctly infer which cell corresponds to the published responder message. If the content view does not conform to ResponderNotifier, nothing will happen.
///
/// This cell also conforms to SDynamicContentContainer. When a content configuration is provided which also conforms, the cell will connect to it so that messages will be passed up to a containing controller.
final
class ConfigurableCollectionCell: UICollectionViewListCell, SDynamicContentContainer {
	
	/// Call this handler when a configuration update is requested.
    private
    var configurationUpdateHandler: ConfigurationUpdateHandler = { state in
        debugPrint("Default cell configuration update handler called.")
        return (UIListContentConfiguration.cell().updated(for: state),
                UIBackgroundConfiguration.listGroupedCell())
	}
    
    /// Call this closure from height-modifying code. This closure is set by the containing view and used to update for size changes.
    /// - Warning: Only call this closure from the main thread - it is UI updating
    var sizeDidChange: () -> Void = { debugPrint("Blank `sizeDidChange` handler called.") }
	
	/// Updates the cell configuration using the provided state. Don't call this method directly, instead call setNeedsUpdateConfiguration() to schedule an update if state has changed which affects cell content configuration.
	/// - Note: This method calls the configuration update handler.
    override
    func updateConfiguration(using state: UICellConfigurationState) {
        var updatedConfigs = configurationUpdateHandler(state)
        
        // connect to SDynamicContentContainers
        if var dynamicContentContainer = updatedConfigs.content as? SDynamicContentConfiguration {
            dynamicContentContainer.sizeDidChange = { [unowned self] in
                sizeDidChange()
            }
            updatedConfigs.content = dynamicContentContainer
        }
        
        contentConfiguration = updatedConfigs.content
        backgroundConfiguration = updatedConfigs.background
	}
	
	// MARK: - first responder passthrough
	
    override var isFirstResponder: Bool {
        contentView.isFirstResponder
	}
	
	override var canBecomeFirstResponder: Bool {
        contentView.canBecomeFirstResponder
	}
	
	override func becomeFirstResponder() -> Bool {
		super.becomeFirstResponder()
        return contentView.becomeFirstResponder()
	}
    
    override var canResignFirstResponder: Bool {
        contentView.canResignFirstResponder
	}
	
    override func resignFirstResponder() -> Bool {
		super.resignFirstResponder()
        return contentView.resignFirstResponder()
	}
}

// MARK: - typealiases
extension ConfigurableCollectionCell {
    
    typealias ConfigurationUpdateHandler = (UICellConfigurationState) -> (content: UIContentConfiguration?, background: UIBackgroundConfiguration?)
}

// MARK: - responder notifier
extension ConfigurableCollectionCell: ResponderNotifier {
	
    var didBecomeFirstResponderPublisher: AnyPublisher<UIResponder, Never> {
        if let responderNotifierContentView = contentView as? ResponderNotifier {
            return responderNotifierContentView.didBecomeFirstResponderPublisher
                .map { _ in self as UIResponder }
                .eraseToAnyPublisher()
        }
        else {
            warnPrematurePublisherAccess()
        }
        return PassthroughSubject<UIResponder, Never>().eraseToAnyPublisher()
    }
    
    var didResignFirstResponderPublisher: AnyPublisher<UIResponder, Never> {
        if let responderNotifierContentView = contentView as? ResponderNotifier {
            return responderNotifierContentView.didResignFirstResponderPublisher
                .map { _ in self as UIResponder }
                .eraseToAnyPublisher()
        }
        else {
            warnPrematurePublisherAccess()
        }
        return PassthroughSubject<UIResponder, Never>().eraseToAnyPublisher()
    }
    
    /// Prints a warning about ResponderNotifier publishers being accessed before available from the content configuration view.
    private
    func warnPrematurePublisherAccess() {
        debugPrint("\(Self.debugDescription()):")
        debugPrint("`ResponderNotifier` publisher was requested from a cell whose `contentView` does not conform to `ResponderNotifier`. This will result in a blank publisher.")
        debugPrint("cell instance: \(self)")
    }
}

// MARK: - api
extension ConfigurableCollectionCell {
    
    @discardableResult
    func onConfigurationStateChange(_ handler: @escaping ConfigurationUpdateHandler) -> Self {
        configurationUpdateHandler = handler
        return self
    }
}
