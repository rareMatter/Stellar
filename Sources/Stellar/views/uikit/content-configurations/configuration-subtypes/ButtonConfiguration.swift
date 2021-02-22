//
//  ButtonConfiguration.swift
//  life-tool-1-iOS
//
//  Created by Jesse Spencer on 2/1/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

public
struct ButtonConfiguration: Hashable {
    public var primaryAction: UIAction
    public var actions: [UIControl.Event : UIAction] = [:]
    public var title: String? = nil
    public var image: UIImage? = nil
    public var selectedImage: UIImage? = nil
    public var imageProperties: ImageProperties = .init(preferredSymbolConfiguration: .unspecified)
    public var backgroundColor: UIColor? = nil
    public var isSelected = false
    public var isDisabled = false
}
// MARK: - creation
public
extension ButtonConfiguration {
    static func standard(primaryAction: UIAction) -> ButtonConfiguration {
        .init(primaryAction: primaryAction)
    }
}
// MARK: - config mapping
extension ButtonConfiguration {
    func map(to button: UIButton, from oldConfig: ButtonConfiguration? = nil) {
        if let oldConfig = oldConfig {
           updateButtonFromConfig(button, oldConfig: oldConfig)
        }
        else {
            applyInitialConfigTo(button: button)
        }
    }
    
    /// Maps self to the button for the first time.
    /// - Important: Do not call this method more than once on a button instance or its state could become incorrect.
    private func applyInitialConfigTo(button: UIButton) {
        button.addAction(primaryAction, for: .touchUpInside)
        actions.forEach { (event, action) in
            button.addAction(action, for: event)
        }
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        if let image = image {
            button.setImage(image, for: .normal)
        }
        if let selectedImage = selectedImage {
            button.setImage(selectedImage, for: .selected)
        }
        
        applyCommonConfig(to: button)
    }
    
    /// Maps self to the button while skipping unchanged properties.
    private func updateButtonFromConfig(_ button: UIButton, oldConfig: ButtonConfiguration) {
        if oldConfig.primaryAction != primaryAction {
            button.removeAction(primaryAction, for: .touchUpInside)
            button.addAction(primaryAction, for: .touchUpInside)
        }
        if oldConfig.actions != actions {
            oldConfig.actions.forEach { (event, action) in
                button.removeAction(action, for: event)
            }
            actions.forEach { (event, action) in
                button.addAction(action, for: event)
            }
        }
        if let title = title, title != oldConfig.title {
            button.setTitle(title, for: .normal)
        }
        if let image = image, image != oldConfig.image {
            button.setImage(image, for: .normal)
        }
        if let selectedImage = selectedImage, selectedImage != oldConfig.image {
            button.setImage(selectedImage, for: .selected)
        }
        
        applyCommonConfig(to: button)
    }
    
    private func applyCommonConfig(to button: UIButton) {
        button.setPreferredSymbolConfiguration(imageProperties.preferredSymbolConfiguration, forImageIn: .normal)
        if let backgroundColor = backgroundColor {
            button.backgroundColor = backgroundColor
        }
        button.isSelected = isSelected
        button.isEnabled = !isDisabled
    }
}

extension UIControl.Event: Hashable {}
