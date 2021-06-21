//
//  NLButton.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/12/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import SwiftUI

public
struct NLButton: View {
    
    let configuration: NLButtonConfiguration
    
    init(_ configuration: NLButtonConfiguration) {
        self.configuration = configuration
    }
    
    public var body: some View {
        configuration.showsContextMenuAsPrimaryAction ?
            AnyView(
                Menu {
                    contextMenu(for: configuration.contextMenuItems)
                } label: {
                    if !configuration.title.isEmpty {
                        Text(configuration.title)
                    }
                    configuration.imageView()
                }
                .config(configuration)
            )
            : AnyView(
                Button(action: configuration.handler) {
                    if !configuration.title.isEmpty {
                        Text(configuration.title)
                    }
                    configuration.imageView()
                }
                .contextMenu {
                    contextMenu(for: configuration.contextMenuItems)
                }
                .config(configuration)
            )
    }
    
    private func contextMenu(for items: [NLButtonConfiguration]) -> some View {
        ForEach(items) { config in
            Button(action: config.handler) {
                Text(config.title)
                config.imageView()
            }
        }
    }
}

extension View {
    func config(_ buttonConfiguration: NLButtonConfiguration) -> some View {
        self
            .imageScale(buttonConfiguration.imageScale)
            .font(buttonConfiguration.font)
            .padding(buttonConfiguration.padding)
            .disabled(buttonConfiguration.isDisabled)
    }
}
