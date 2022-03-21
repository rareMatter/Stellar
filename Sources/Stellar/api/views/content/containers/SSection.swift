//
//  SSection.swift
//  
//
//  Created by Jesse Spencer on 10/5/21.
//

import Foundation
import SwiftUI

public
struct SSection<Content, Header, Footer>: SPrimitiveContent
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
}

// MARK: - internal recognition
protocol _AnySection {}
extension SSection: _AnySection {}

// MARK: Create a section without a header or footer.
public
extension SSection
where Header == SEmptyContent, Footer == SEmptyContent {
    
    init(@SContentBuilder content: @escaping () -> Content) {
        self.init(content: content,
                  header: { SEmptyContent() },
                  footer: { SEmptyContent() })
    }
}

// MARK: Create a section with no header.
public
extension SSection
where Header == SEmptyContent {
    
    init(@SContentBuilder content: @escaping () -> Content,
         @SContentBuilder footer: @escaping () -> Footer) {
        self.init(content: content,
                  header: { SEmptyContent() },
                  footer: footer)
    }
}

// MARK: Create a section with no footer.
public
extension SSection
where Footer == SEmptyContent {
    
    init(@SContentBuilder content: @escaping () -> Content,
         @SContentBuilder header: @escaping () -> Header) {
        self.init(content: content,
                  header: header,
                  footer: { SEmptyContent() })
    }
}
