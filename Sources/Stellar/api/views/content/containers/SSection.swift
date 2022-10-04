//
//  SSection.swift
//  
//
//  Created by Jesse Spencer on 10/5/21.
//

import Foundation
import SwiftUI

public
struct SSection<Parent, Content, Footer>: SPrimitiveContent
where Parent : SContent, Content : SContent, Footer : SContent {
    
    let parent: _SSectionPart<Parent>
    let content: _SSectionPart<Content>
    let footer: _SSectionPart<Footer>
    
    public
    init(@SContentBuilder parent: () -> Parent,
         @SContentBuilder content: () -> Content,
         @SContentBuilder footer: () -> Footer) {
        self.parent = .init(content: parent(), part: .parent)
        self.content = .init(content: content(), part: .content)
        self.footer = .init(content: footer(), part: .footer)
    }
}
extension SSection: _SContentContainer {
    var children: [AnySContent] { [.init(parent), .init(content), .init(footer)] }
}

// FIXME: temp public
public
enum SectionPartType {
    case parent, content, footer
}
struct _SSectionPart<Content: SContent>: SPrimitiveContent {
    let content: Content
    let part: SectionPartType
}
extension _SSectionPart: _SContentContainer {
    var children: [AnySContent] { [.init(content)] }
}

// FIXME: temp public
public
protocol AnySectionPart {
    var part: SectionPartType { get }
}
extension _SSectionPart: AnySectionPart {}

// MARK: - internal recognition
// FIXME: temp public
public
protocol _AnySection {}
extension SSection: _AnySection {}

// MARK: Create a section without a header or footer.
public
extension SSection
where Parent == SEmptyContent, Footer == SEmptyContent {
    
    init(@SContentBuilder content: @escaping () -> Content) {
        self.init(parent: { SEmptyContent() },
                  content: content,
                  footer: { SEmptyContent() })
    }
}

// MARK: Create a section with no header.
public
extension SSection
where Parent == SEmptyContent {
    
    init(@SContentBuilder content: @escaping () -> Content,
         @SContentBuilder footer: @escaping () -> Footer) {
        self.init(parent: { SEmptyContent() },
                  content: content,
                  footer: footer)
    }
}

// MARK: Create a section with no footer.
public
extension SSection
where Footer == SEmptyContent {
    
    init(@SContentBuilder content: @escaping () -> Content,
         @SContentBuilder parent: @escaping () -> Parent) {
        self.init(parent: parent,
                  content: content,
                  footer: { SEmptyContent() })
    }
}
