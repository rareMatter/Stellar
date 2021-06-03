//
//  ContextMenuButtonContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/22/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// Displays a button which shows a contexual menu containing provided actions.
struct ContextMenuButtonContentConfiguration: SContentConfiguration, Equatable {
	
	var title: String?
    var titleProperties: TextProperties = .init(font: .preferredFont(forTextStyle: .title1))
    
    var image: UIImage?
    
	var menu: UIMenu?
    
    var menuWillAppear: MenuTransitionHandler  = {_,_,_ in}
    var menuWillDisappear: MenuTransitionHandler  = {_,_,_ in}
    
    var isDisabled = false
    
    var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center
}

// MARK: - equatable
extension ContextMenuButtonContentConfiguration {
    
    static
    func == (lhs: ContextMenuButtonContentConfiguration, rhs: ContextMenuButtonContentConfiguration) -> Bool {
        lhs.title == rhs.title &&
            lhs.titleProperties == rhs.titleProperties &&
            lhs.menu == rhs.menu
    }
}

// MARK: - content view
extension ContextMenuButtonContentConfiguration {
    
    func contentView() -> _SContentView<Self> {
        
        let button: _SContextMenuButton = {
            let button = _SContextMenuButton(frame: .zero)
            button.setTitleColor(.label, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        return _SContentView<Self>(configuration: self) { contentView in
            contentView.addSubview(button)
        } handleConstraintUpdate: { contentView, isFirstSetup in
            guard isFirstSetup else { return }
            button.snp.makeConstraints { (make) in
                make.directionalEdges.equalTo(contentView.snp.directionalMargins)
                make.top.equalTo(contentView.snp.topMargin)
                make.bottom.equalTo(contentView.snp.bottomMargin)
            }
        } handleConfigurationUpdate: { oldConfig, updatedConfig, contentView in
            
            button.setTitle(updatedConfig.title, for: .normal)
            button.titleLabel?.font = updatedConfig
                .titleProperties
                .font
            button.setImage(updatedConfig.image, for: .normal)
            button.menu = updatedConfig.menu
            button.isEnabled = !updatedConfig
                .isDisabled
            button.contentHorizontalAlignment = updatedConfig.contentHorizontalAlignment
        }
    }
}

// MARK: - typealiases
extension ContextMenuButtonContentConfiguration {
    typealias MenuTransitionHandler = (_ interaction: UIContextMenuInteraction, _ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void
}

// MARK: SPrimitiveRepresentable
extension SContextMenuButton: SPrimitiveContentConfigurationRenderer {
    
    func makeContentConfiguration() -> UIContentConfiguration {
        ContextMenuButtonContentConfiguration(title: title,
                                              image: image,
                                              menu: .init(title: title,
                                                          image: image,
                                                          children: menuItems),
                                              isDisabled: isDisabled)
    }
}
