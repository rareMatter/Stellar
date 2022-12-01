//
//  SOutlineGroup.swift
//  
//
//  Created by Jesse Spencer on 10/5/21.
//

public
struct SOutlineGroup<Data, ID, Parent, Leaf, Subgroup>
where Data : RandomAccessCollection, ID : Hashable {
    
    enum TreeNode {
        case collection(Data)
        case single(Data.Element)
    }
    
    let root: TreeNode
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
            SForEach(data, id: id) { item in
                SOutlineSubgroupChildren { () -> any SContent in
                    if let subgroup = item[keyPath: children] {
                        SDisclosureGroup(content: {
                            SOutlineGroup(root: .collection(subgroup),
                                          children: children,
                                          id: id,
                                          content: content)
                        }, label: {
                            content(item)
                        })
                    }
                    else {
                        content(item)
                    }
                }
            }
            
        case let .single(root):
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

// MARK: Creating an Outline Group from a Binding to Hierarchical Data

/* TODO: Implement. Create SOutlineGroup using a binding to data or an element.
public
extension SOutlineGroup
where Data : RandomAccessCollection,
      ID == Data.Element.ID,
      Parent == Leaf,
      Subgroup == SDisclosureGroup<Parent, SOutlineSubgroupChildren>,
      Data.Element : Identifiable {
    
    /// Creates an outline group from a binding to a root data element and a key path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views across updates based on the identity of the underlying data element.
    /// All generated disclosure groups begin in the collapsed state.
    /// Make sure that the identifier of a data element only changes if you mean to replace that element with a new element, one with a new identity. If the ID of an element changes, then the content view generated from that element will lose any current state and animations.
    init<C, E>(_ root: Binding<E>,
               children: WritableKeyPath<E, C?>,
               content: @escaping (Binding<E>) -> Leaf)
    where Data == Binding<C>,
    ID == E.ID,
    C : MutableCollection,
    C : RandomAccessCollection,
    E : Identifiable,
    E == C.Element {
        
    }
    
    /// Creates an outline group from a binding to a collection of root data elements and a key path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views across updates based on the identity of the underlying data element.
    /// All generated disclosure groups begin in the collapsed state.
    /// Make sure that the identifier of a data element only changes if you mean to replace that element with a new element, one with a new identity. If the ID of an element changes, then the content view generated from that element will lose any current state and animations.
    init<C, E>(_ data: Binding<C>,
               children: WritableKeyPath<E, C?>,
               content: @escaping (Binding<E>) -> Leaf)
    where Data == Binding<C>,
    ID == E.ID,
    C : MutableCollection,
    C : RandomAccessCollection,
    E : Identifiable,
    E == C.Element {
        
    }
    
    /// Creates an outline group from a binding to a root data element, the key path to its identifier, and a key path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views across updates based on the identity of the underlying data element.
    /// All generated disclosure groups begin in the collapsed state.
    /// Make sure that the identifier of a data element only changes if you mean to replace that element with a new element, one with a new identity. If the ID of an element changes, then the content view generated from that element will lose any current state and animations.
    init<C, E>(_ root: Binding<E>,
               id: KeyPath<E, ID>,
               children: WritableKeyPath<E, C?>,
               content: @escaping (Binding<E>) -> Leaf)
    where Data == Binding<C>,
    C : MutableCollection,
    C : RandomAccessCollection,
    E == C.Element {
        
    }

    /// Creates an outline group from a binding to a collection of root data elements, the key path to a data element’s identifier, and a key path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views across updates based on the identity of the underlying data element.
    /// All generated disclosure groups begin in the collapsed state.
    /// Make sure that the identifier of a data element only changes if you mean to replace that element with a new element, one with a new identity. If the ID of an element changes, then the content view generated from that element will lose any current state and animations.
    init<C, E>(_ data: Binding<C>,
               id: KeyPath<E, ID>,
               children: WritableKeyPath<E, C?>,
               content: @escaping (Binding<E>) -> Leaf)
    where Data == Binding<C>,
    C : MutableCollection,
    C : RandomAccessCollection,
    E == C.Element {
        
    }
}
 */

/// Type-erased content representing the children in an outline subgroup.
public
struct SOutlineSubgroupChildren: SPrimitiveContent {
    @SContentBuilder
    let children: () -> any SContent
}
