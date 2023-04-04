//
//  HostingContainer.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

/// A container for a host and related data.
struct HostingContainer {
    var host: _Host
    var renderedElement: PlatformContent?
    var renderContext: RenderContext
}
