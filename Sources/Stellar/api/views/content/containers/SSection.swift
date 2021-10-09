//
//  SSection.swift
//  
//
//  Created by Jesse Spencer on 10/5/21.
//

import Foundation
import SwiftUI

public
struct SSection<Content, Header, Footer>: SContent
where Content : SContent, Header : SContent, Footer : SContent {
    
    let contentProvider: () -> Content
    let headerProvider: () -> Header
    let footerProvider: () -> Footer
    
    public
    init(@SContentBuilder content: @escaping () -> Content,
         @SContentBuilder header: @escaping () -> Header,
         @SContentBuilder footer: @escaping () -> Footer) {
        self.contentProvider = content
        self.headerProvider = header
        self.footerProvider = footer
    }
    
    public
    var body: some SContent {
        headerProvider()
        contentProvider()
        footerProvider()
    }
}

// MARK: internal recognition
protocol _SSectionContainer {
    var anyContentProvider: () -> AnySContent { get }
    var anyHeaderProvider: () -> AnySContent { get }
    var anyFooterProvider: () -> AnySContent { get }
}
extension SSection: _SSectionContainer {
    
    var anyContentProvider: () -> AnySContent {
        { .init(contentProvider()) }
    }
    
    var anyHeaderProvider: () -> AnySContent {
        { .init(headerProvider()) }
    }
    
    var anyFooterProvider: () -> AnySContent {
        { .init(footerProvider()) }
    }
}

// MARK: Create a section without a header or footer.
extension SSection
where Header == SEmptyContent, Footer == SEmptyContent {
    
    init(@SContentBuilder content: @escaping () -> Content) {
        self.init(content: content,
                  header: { SEmptyContent() },
                  footer: { SEmptyContent() })
    }
}

// MARK: Create a section with no header.
extension SSection
where Header == SEmptyContent {
    
    public
    init(@SContentBuilder content: @escaping () -> Content,
         @SContentBuilder footer: @escaping () -> Footer) {
        self.init(content: content,
                  header: { SEmptyContent() },
                  footer: footer)
    }
}

// MARK: Create a section with no footer.
extension SSection
where Footer == SEmptyContent {
    
    public
    init(@SContentBuilder content: @escaping () -> Content,
         @SContentBuilder header: @escaping () -> Header) {
        self.init(content: content,
                  header: header,
                  footer: { SEmptyContent() })
    }
}
