//
//  _SContextMenuButton.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/22/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// A button which displays a context menu when tapped.
///
/// Configure the context menu by setting the menu property. Add animations by setting the corresponding menu appearance and disappearance closures.
class _SContextMenuButton: UIButton {
	
	typealias MenuTransitionHandler = (_ interaction: UIContextMenuInteraction, _ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void
	var menuWillAppear: MenuTransitionHandler = { _,_,_ in }
	var menuWillDisappear: MenuTransitionHandler = { _,_,_ in }
	
	override
    init(frame: CGRect) {
		super.init(frame: frame)
		showsMenuAsPrimaryAction = true
	}
	@available(*, unavailable)
	required
    init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
	// MARK: - animation
	
    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
		super.contextMenuInteraction(interaction, willDisplayMenuFor: configuration, animator: animator)
		menuWillAppear(interaction, configuration, animator)
	}
	
    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
		super.contextMenuInteraction(interaction, willEndFor: configuration, animator: animator)
		menuWillDisappear(interaction, configuration, animator)
	}
}
