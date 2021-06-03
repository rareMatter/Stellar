//
//  STextEditorContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 11/6/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// A multi-line text editor.
struct STextEditorContentConfiguration: SContentConfiguration, Equatable {
    
    var text: String
    var placeholderText: String = "Enter text..."
    
    var onTextChange: (String) -> Void
    
    var font: UIFont = .preferredFont(forTextStyle: .title1)
    
    var inputAccessoryView: UIView?
}

// MARK: - equatable
extension STextEditorContentConfiguration {
    
    static
    func ==(lhs: STextEditorContentConfiguration, rhs: STextEditorContentConfiguration) -> Bool {
        lhs.text == rhs.text &&
            lhs.placeholderText == rhs.placeholderText &&
            lhs.font == rhs.font &&
            lhs.inputAccessoryView == rhs.inputAccessoryView
    }
}

// MARK: - content view
extension STextEditorContentConfiguration {
    
    func contentView() -> _SContentView<Self> {
        
        let textView: STextView = {
            let textView = STextView(frame: .zero)
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.isScrollEnabled = false
            textView.adjustsFontForContentSizeCategory = true
            textView.textColor = .label
            return textView
        }()
        
        return _SContentView<Self>(configuration: self, dynamicSizeContent: textView, responder: textView) { contentView in
            contentView.addSubview(textView)
        } handleConstraintUpdate: { contentView, isFirstSetup in
            guard isFirstSetup else { return }
            textView.snp.makeConstraints { make in
                make.directionalEdges.equalTo(contentView.snp.directionalMargins)
                make.top.equalTo(contentView.snp.topMargin)
                make.bottom.equalTo(contentView.snp.bottomMargin)
            }
        } handleConfigurationUpdate: { oldConfig, updatedConfig, contentView in
            textView.text = updatedConfig.text
            textView.placeholder = updatedConfig.placeholderText
            textView.font = updatedConfig.font
            textView.placeholderFont = updatedConfig.font
            textView.inputAccessoryView = updatedConfig.inputAccessoryView
        }
    }
}

// MARK: SPrimitiveRepresentable
extension STextEditor: SPrimitiveContentConfigurationRenderer {
    
    func makeContentConfiguration() -> UIContentConfiguration {
        STextEditorContentConfiguration(
            text: text,
            placeholderText: placeholderText,
            onTextChange: onTextChange,
            inputAccessoryView: inputAccessoryView)
    }
}
