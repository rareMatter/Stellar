//
//  SOutlineGroup.swift
//  
//
//  Created by Jesse Spencer on 10/5/21.
//

import Foundation
import SwiftUI

public
struct SOutlineGroup<Data, ID, Parent, Leaf, Subgroup>
where Data : RandomAccessCollection, ID : Hashable {
    
    enum Root {
        case collection(Data)
        case single(Data.Element)
    }
    
    let root: Root
    let children: KeyPath<Data.Element, Data?>
    let id: KeyPath<Data.Element, ID>
    let content: (Data.Element) -> Leaf
}

// MARK: SContent conformance
extension SOutlineGroup: SContent
where Parent : SContent, Leaf : SContent, Subgroup : SContent {
    
    public
    var body: some SContent {
        switch root {
            case let .collection(data):
                return AnySContent(
                    SForEach(data, id: id) { item in
                        SOutlineSubgroupChildren { () -> AnySContent in
                            if let subgroup = item[keyPath: children] {
                                return AnySContent(
                                    SDisclosureGroup(content: {
                                        SOutlineGroup(root: .collection(subgroup),
                                                      children: children,
                                                      id: id,
                                                      content: content)
                                    }, label: {
                                        content(item)
                                    })
                                )
                            }
                            else {
                                return AnySContent(content(item))
                            }
                        }
                    }
                )
                
            case let .single(root):
                return AnySContent(
                    SDisclosureGroup(content: {
                        if let subgroup = root[keyPath: children] {
                            SOutlineGroup(root: .collection(subgroup),
                                          children: children,
                                          id: id,
                                          content: content)
                        }
                        else {
                            content(root)
                        }
                    }, label: {
                        content(root)
                    })
                )
        }
    }
}

// MARK: Create an outline group from a single item or a collection of data.
public
extension SOutlineGroup
where Parent: SContent,
      Parent == Leaf,
      Subgroup == SDisclosureGroup<Parent, SOutlineSubgroupChildren> {
    
    init<DataElement>(_ root: DataElement,
                      id: KeyPath<DataElement, ID>,
                      children: KeyPath<DataElement, Data?>,
                      @SContentBuilder content: @escaping (DataElement) -> Leaf)
    where DataElement == Data.Element {
        self.root = .single(root)
        self.children = children
        self.id = id
        self.content = content
    }
    
    init<DataElement>(_ data: Data,
                      id: KeyPath<DataElement, ID>,
                      children: KeyPath<DataElement, Data?>,
                      @SContentBuilder content: @escaping (DataElement) -> Leaf)
    where DataElement == Data.Element {
        root = .collection(data)
        self.id = id
        self.children = children
        self.content = content
    }
}

// MARK: Create an outline group from a single item or collection of identifiable data.
public
extension SOutlineGroup
where Parent : SContent,
      Parent == Leaf,
      Subgroup == SDisclosureGroup<Parent, SOutlineSubgroupChildren>,
      Data.Element : Identifiable {
    
    init<DataElement>(_ root: DataElement,
                      children: KeyPath<DataElement, Data?>,
                      @SContentBuilder content: @escaping (DataElement) -> Leaf)
    where ID == DataElement.ID, DataElement: Identifiable, DataElement == Data.Element {
        self.init(root, id: \.id, children: children, content: content)
    }
    
    init<DataElement>(_ data: Data,
                      children: KeyPath<DataElement, Data?>,
                      @SContentBuilder content: @escaping (DataElement) -> Leaf)
    where ID == DataElement.ID, DataElement: Identifiable, DataElement == Data.Element {
        self.init(data, id: \.id, children: children, content: content)
    }
}

public
struct SOutlineSubgroupChildren: SContent {
    
    let children: () -> AnySContent
    
    public
    var body: some SContent {
        children()
    }
}
