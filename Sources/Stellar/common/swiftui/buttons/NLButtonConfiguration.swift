//
//  NLButtonConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 12/13/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

/// An abstraction which describes details and behaviors of a button, to be used for creating actual button instances.
public
struct NLButtonConfiguration: Identifiable {
    
    public typealias Handler = () -> Void
    
    public let id: NLButtonIdentifier
    
    public var title: String
    public var imageView: () -> AnyView
    
	/// A primary action handler for button taps.
	/// - Note: If `showsContextMenuAsPrimaryAction` is true, this handler will not be called.
	public var handler: Handler
    /// When true this button will show the items provided by `contextMenuItems` as its response to interaction.
    /// - Note: When true, the `handler` will never be called.
    public var showsContextMenuAsPrimaryAction: Bool
    public var contextMenuItems: [NLButtonConfiguration]
	
    public var imageScale: Image.Scale
    public var font: Font
	public var padding: EdgeInsets
    
    public var isDisabled = false
    
    public init(id: NLButtonIdentifier, title: String = "", imageView: @escaping () -> AnyView = { AnyView(EmptyView()) }, handler: @escaping Handler = {}, showsContextMenuAsPrimaryAction: Bool = false, contextMenuItems: [NLButtonConfiguration] = [], imageScale: Image.Scale = .medium, font: Font = .title, padding: EdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)) {
        self.id = id
        self.title = title
        self.imageView = imageView
        self.handler = handler
        self.showsContextMenuAsPrimaryAction = showsContextMenuAsPrimaryAction
        self.contextMenuItems = contextMenuItems
        self.imageScale = imageScale
        self.font = font
        self.padding = padding
    }
}
// MARK: - standard configurations
public
extension NLButtonConfiguration {
    
    static func done(_ handler: @escaping Handler) -> NLButtonConfiguration {
        .init(id: .done,
              imageView: {
                AnyView(
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .accentColor(.blue)
                        Text("Done")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 4.0)
                    .fixedSize()
                )
              },
              handler: handler)
    }
}
