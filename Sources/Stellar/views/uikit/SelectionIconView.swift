//
//  SelectionIconView.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/7/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

public
typealias SelectionIconViewProvider = () -> (UIView & SelectableView)

/// A view which updates its appearance for selection state.
public
final class SelectionIconView: UIView {
    // -- views
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let selectableImage: UIImage
    private let selectedImage: UIImage
    private var currentImage: UIImage {
        isSelected ?
            selectedImage
            : selectableImage
    }
    
    // -- state
    private var isSelected: Bool {
        didSet {
            self.imageView.image = currentImage
        }
    }
    public
    init(isSelected: Bool = false, selectableImage: UIImage, selectedImage: UIImage) {
        self.isSelected = isSelected
        self.selectableImage = selectableImage
        self.selectedImage = selectedImage
        
        super.init(frame: .zero)
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: layoutMarginsGuide.topAnchor, multiplier: 1),
            imageView.leadingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: layoutMarginsGuide.leadingAnchor, multiplier: 1),
            imageView.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: layoutMarginsGuide.bottomAnchor, multiplier: 1),
            imageView.trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: layoutMarginsGuide.trailingAnchor, multiplier: 1)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SelectionIconView: SelectableView {
    public func setSelection(to state: Bool) {
        isSelected = state
    }
}
