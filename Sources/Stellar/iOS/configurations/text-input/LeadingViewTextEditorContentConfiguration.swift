//
//  LeadingViewTextEditorContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/28/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

/// Displays a leading view before a text editor view.
struct LeadingViewTextEditorContentConfiguration: SContentConfiguration, Equatable {
    var leadingView: UIView
    var textEditorConfiguration: STextEditorContentConfiguration
    var configurationState: UICellConfigurationState = .init(traitCollection: .current)
}

// MARK: - content view
extension LeadingViewTextEditorContentConfiguration {
    
    func contentView() -> _SContentView<Self> {
        
        let hStack: UIStackView = {
            let hStack = UIStackView(frame: .zero)
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.axis = .horizontal
            hStack.alignment = .center
            return hStack
        }()
        
        var leadingView = self.leadingView {
            willSet {
                guard newValue != leadingView else { return }
                leadingView.removeFromSuperview()
            }
            didSet {
                leadingView.translatesAutoresizingMaskIntoConstraints = false
                leadingView.setContentHuggingPriority(.required, for: .horizontal)
                leadingView.setContentCompressionResistancePriority(.required, for: .horizontal)
                hStack.insertArrangedSubview(leadingView, at: 0)
            }
        }
        
        let textEditor: _SContentView<STextEditorContentConfiguration> = {
            let view = textEditorConfiguration.contentView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.directionalLayoutMargins = .zero
            return view
        }()
        
        return _SContentView<Self>(configuration: self, dynamicSizeContent: textEditor, responder: textEditor) { contentView in
            contentView.addSubview(hStack)
            if leadingView.superview == nil {
                hStack.addArrangedSubview(leadingView)
            }
            hStack.addArrangedSubview(textEditor)
        } handleConstraintUpdate: { contentView, isFirstSetup in
            guard isFirstSetup else { return }
            hStack.snp.makeConstraints { make in
                make.directionalEdges.equalTo(contentView.snp.directionalMargins)
                make.top.equalTo(contentView.snp.topMargin)
                make.bottom.equalTo(contentView.snp.bottomMargin)
            }
        } handleConfigurationUpdate: { oldConfig, updatedConfig, contentView in
            textEditor.configuration = updatedConfig.textEditorConfiguration
            leadingView = updatedConfig.leadingView
        }
    }
}

// MARK: SPrimitiveRepresentable
extension SLeadingViewTextEditor: UIKitContentRenderer {
    
    func mountContent(on target: UIKitRenderableContent) {
        target.contentConfiguration =
            LeadingViewTextEditorContentConfiguration(
                leadingView: leadingView,
                textEditorConfiguration: .init(
                    text: text,
                    placeholderText: placeholderText,
                    onTextChange: textChangeHandler,
                    inputAccessoryView: inputAccessoryView))
    }
}

