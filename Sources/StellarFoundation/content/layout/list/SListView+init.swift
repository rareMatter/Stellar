//
//  SListView+init.swift
//  
//
//  Created by Jesse Spencer on 10/18/21.
//

import Foundation

public
extension SListView {
    
    // MARK: - Creating a List with Arbitrary Content
    
    init(@SContentBuilder content: () -> Content)
    where Selection == Never {
        self.content = content()
        self.selection = nil
    }
    
    init(selection: SBinding<Selection>?,
         @SContentBuilder content: @escaping () -> Content) {
        if let selection = selection {
            self.selection = .one(selection)
        }
        else {
            self.selection = nil
        }
        self.content = content()
    }
    
    init(selection: SBinding<Set<Selection>>?,
         @SContentBuilder content: @escaping () -> Content) {
        if let selection = selection {
            self.selection = .many(selection)
        }
        else {
            self.selection = nil
        }
        self.content = content()
    }
    
    // MARK: - Creating a List from a Range
    
    /// Creates a list that computes its views on demand over a constant range.
    ///
    /// This instance only reads the initial value of data and doesn’t need to identify views across updates. To compute views on demand over a dynamic range, use init(_:id:rowContent:).
    init<RowContent>(_ data: Range<Int>,
                     @SContentBuilder rowContent: @escaping (Int) -> RowContent)
    where Content == SForEach<Range<Int>, Int, RowContent>,
    RowContent : SContent,
    Selection == Never {
        self.init {
            SForEach(data) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a list that computes its views on demand over a constant range, optionally allowing users to select a single row.
    ///
    /// This instance only reads the initial value of data and doesn’t need to identify views across updates. To compute views on demand over a dynamic range, use init(_:id:selection:rowContent:).
    init<RowContent>(_ data: Range<Int>,
                     selection: SBinding<Selection>?,
                     @SContentBuilder rowContent: @escaping (Int) -> RowContent)
    where Content == SForEach<Range<Int>, Int, RowContent>,
    RowContent : SContent {
        self.init(selection: selection) {
            SForEach(data) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a list that computes its views on demand over a constant range, optionally allowing users to select multiple rows.
    ///
    /// This instance only reads the initial value of data and doesn’t need to identify views across updates. To compute views on demand over a dynamic range, use init(_:id:selection:rowContent:).
    init<RowContent>(_ data: Range<Int>,
                     selection: SBinding<Set<Selection>>?,
                     @SContentBuilder rowContent: @escaping (Int) -> RowContent)
    where Content == SForEach<Range<Int>, Int, SHStack<RowContent>>,
    RowContent : SContent {
        self.init(selection: selection) {
            SForEach(data) { row in
                SHStack {
                    rowContent(row)
                }
            }
        }
    }
    
    // MARK: - Creating a List from Identifiable Data
    
    /// Creates a list that computes its rows on demand from an underlying collection of identifiable data.
    ///
    ///
    init<Data, RowContent>(_ data: Data,
                           @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SForEach<Data, Data.Element.ID, RowContent>,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable,
    Selection == Never {
        self.init { SForEach(data, content: rowContent) }
    }
    
    /// Creates a list that computes its rows on demand from an underlying collection of identifiable data, optionally allowing users to select a single row.
    init<Data, RowContent>(_ data: Data,
                           selection: SBinding<Selection>?,
                           @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SForEach<Data, Data.Element.ID, RowContent>,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable {
        self.init(selection: selection) {
            SForEach(data) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a list that computes its rows on demand from an underlying collection of identifiable data, optionally allowing users to select multiple rows.
    init<Data, RowContent>(_ data: Data,
                           selection: SBinding<Set<Selection>>?,
                           @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SForEach<Data, Data.Element.ID, RowContent>,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable {
        self.init(selection: selection) {
            SForEach(data) { row in
                rowContent(row)
            }
        }
    }
    
    // MARK: - Creating a List from Data and an Identifier
    
    /// Creates a list that identifies its rows based on a key path to the identifier of the underlying data.
    init<Data, ID, RowContent>(_ data: Data,
                               id: KeyPath<Data.Element, ID>,
                               @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SForEach<Data, ID, RowContent>,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent,
    Selection == Never {
        self.init {
            SForEach(data, id: id) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a list that identifies its rows based on a key path to the identifier of the underlying data, optionally allowing users to select a single row.
    ///
    ///
    init<Data, ID, RowContent>(_ data: Data,
                               id: KeyPath<Data.Element, ID>,
                               selection: SBinding<Selection>?,
                               @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SForEach<Data, ID, RowContent>,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent {
        self.init(selection: selection) {
            SForEach(data, id: id) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a list that identifies its rows based on a key path to the identifier of the underlying data, optionally allowing users to select multiple rows.
    ///
    ///
    init<Data, ID, RowContent>(_ data: Data,
                               id: KeyPath<Data.Element, ID>,
                               selection: SBinding<Set<Selection>>?,
                               @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SForEach<Data, ID, RowContent>,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent {
        self.init(selection: selection) {
            SForEach(data, id: id) { row in
                rowContent(row)
            }
        }
    }
    
    // MARK: - Creating a List from a Binding to Identifiable Data
    
    /* TODO: Implement. SForEach needs init for LazyMapSequence.
    /// Creates a list that computes its rows on demand from an underlying collection of identifiable data.
    ///
    ///
    init<Data, RowContent>(_ data: SBinding<Data>,
                           rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable,
    Data.Index : Hashable,
    Selection == Never {
        self.init {
            SForEach(data) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a list that computes its rows on demand from an underlying collection of identifiable data, optionally allowing users to select a single row.
    ///
    ///
    init<Data, RowContent>(_ data: SBinding<Data>,
                           selection: SBinding<Selection?>?,
                           rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable,
    Data.Index : Hashable {
        
    }
    
    /// Creates a list that computes its rows on demand from an underlying collection of identifiable data, optionally allowing users to select multiple rows.
    ///
    ///
    init<Data, RowContent>(_ data: SBinding<Data>,
                           selection: SBinding<Set<Selection>>?,
                           rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable,
    Data.Index : Hashable {
        
    }
    
    // MARK: - Creating a List from a Binding to Data and an Identifier
    
    /// Creates a list that identifies its rows based on a key path to the identifier of the underlying data.
    ///
    ///
    init<Data, ID, RowContent>(_ data: SBinding<Data>,
                               id: KeyPath<Data.Element, ID>,
                               rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent,
    Data.Index : Hashable,
    Selection == Never {
        
    }
    
    /// Creates a list that identifies its rows based on a key path to the identifier of the underlying data, optionally allowing users to select a single row.
    ///
    ///
    init<Data, ID, RowContent>(_ data: SBinding<Data>,
                               id: KeyPath<Data.Element, ID>,
                               selection: SBinding<Selection?>?,
                               rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent,
    Data.Index : Hashable {
        
    }
    
    /// Creates a list that identifies its rows based on a key path to the identifier of the underlying data, optionally allowing users to select multiple rows.
    ///
    ///
    init<Data, ID, RowContent>(_ data: SBinding<Data>,
                               id: KeyPath<Data.Element, ID>,
                               selection: SBinding<Set<Selection>>?,
                               rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent,
    Data.Index : Hashable {
        
    }
     */
    
    // MARK: - Creating a List from Hierarchical, Identifiable Data
    
    /// Creates a hierarchical list that computes its rows on demand from an underlying collection of identifiable data.
    ///
    ///
    init<Data, RowContent>(_ data: Data,
                           children: KeyPath<Data.Element, Data?>,
                           @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SOutlineGroup<Data, Data.Element.ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable,
    Selection == Never {
        self.init {
            SOutlineGroup(data, children: children) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a hierarchical list that computes its rows on demand from an underlying collection of identifiable data, optionally allowing users to select a single row.
    ///
    ///
    init<Data, RowContent>(_ data: Data,
                           children: KeyPath<Data.Element, Data?>,
                           selection: SBinding<Selection>?,
                           @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SOutlineGroup<Data, Data.Element.ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable {
        self.init(selection: selection) {
            SOutlineGroup(data, children: children) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a hierarchical list that computes its rows on demand from an underlying collection of identifiable data, optionally allowing users to select multiple rows.
    ///
    ///
    init<Data, RowContent>(_ data: Data,
                           children: KeyPath<Data.Element, Data?>,
                           selection: SBinding<Set<Selection>>?,
                           @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SOutlineGroup<Data, Data.Element.ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable {
        self.init(selection: selection) {
            SOutlineGroup(data, children: children) { row in
                rowContent(row)
            }
        }
    }
    
    // MARK: - Creating a List from Hierarchical Data and an Identifier
    
    /// Creates a hierarchical list that identifies its rows based on a key path to the identifier of the underlying data.
    ///
    ///
    init<Data, ID, RowContent>(_ data: Data,
                               id: KeyPath<Data.Element, ID>,
                               children: KeyPath<Data.Element, Data?>,
                               @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SOutlineGroup<Data, ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent,
    Selection == Never {
        self.init {
            SOutlineGroup(data, id: id, children: children) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a hierarchical list that identifies its rows based on a key path to the identifier of the underlying data, optionally allowing users to select a single row.
    ///
    ///
    init<Data, ID, RowContent>(_ data: Data,
                               id: KeyPath<Data.Element, ID>,
                               children: KeyPath<Data.Element, Data?>,
                               selection: SBinding<Selection>?,
                               @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SOutlineGroup<Data, ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent {
        self.init(selection: selection) {
            SOutlineGroup(data, id: id, children: children) { row in
                rowContent(row)
            }
        }
    }
    
    /// Creates a hierarchical list that identifies its rows based on a key path to the identifier of the underlying data, optionally allowing users to select multiple rows.
    ///
    ///
    init<Data, ID, RowContent>(_ data: Data,
                               id: KeyPath<Data.Element, ID>,
                               children: KeyPath<Data.Element, Data?>,
                               selection: SBinding<Set<Selection>>?,
                               @SContentBuilder rowContent: @escaping (Data.Element) -> RowContent)
    where Content == SOutlineGroup<Data, ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent {
        self.init(selection: selection) {
            SOutlineGroup(data, id: id, children: children) { row in
                rowContent(row)
            }
        }
    }
    
    // MARK: - Creating a List from a SBinding to Hierarchical, Identifiable Data
    /* TODO: Implement. Create a list with a bindig to data.
    /// Creates a hierarchical list that computes its rows on demand from a SBinding to an underlying collection of identifiable data.
    ///
    ///
    init<Data, RowContent>(_ data: SBinding<Data>,
                           children: WritableKeyPath<Data.Element, Data?>,
                           rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SOutlineGroup<SBinding<Data>, Data.Element.ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable,
    Selection == Never {
        self.init {
            SOutlineGroup(
        }
    }
    
    /// Creates a hierarchical list that computes its rows on demand from a binding to an underlying collection of identifiable data, optionally allowing users to select a single row.
    ///
    ///
    init<Data, RowContent>(_ data: SBinding<Data>,
                           children: WritableKeyPath<Data.Element, Data?>,
                           selection: SBinding<Selection?>?,
                           rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SOutlineGroup<SBinding<Data>, Data.Element.ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable {
        
    }
    
    /// Creates a hierarchical list that computes its rows on demand from a binding to an underlying collection of identifiable data, optionally allowing users to select multiple rows.
    ///
    ///
    init<Data, RowContent>(_ data: SBinding<Data>,
                           children: WritableKeyPath<Data.Element, Data?>,
                           selection: SBinding<Set<Selection>>?,
                           rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SOutlineGroup<SBinding<Data>, Data.Element.ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    RowContent : SContent,
    Data.Element : Identifiable {
        
    }
    
    
    // MARK: - Creating a List from a Binding to Hierarchical Data and an Identifier
    
    /// Creates a hierarchical list that identifies its rows based on a key path to the identifier of the underlying data.
    ///
    ///
    init<Data, ID, RowContent>(_ data: SBinding<Data>,
                               id: KeyPath<Data.Element, ID>,
                               children: WritableKeyPath<Data.Element, Data?>,
                               rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SOutlineGroup<SBinding<Data>, ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent,
    Selection == Never {
        
    }
    
    /// Creates a hierarchical list that identifies its rows based on a key path to the identifier of the underlying data, optionally allowing users to select a single row.
    ///
    ///
    init<Data, ID, RowContent>(_ data: SBinding<Data>,
                               id: KeyPath<Data.Element, ID>,
                               children: WritableKeyPath<Data.Element, Data?>,
                               selection: SBinding<Selection?>?,
                               rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SOutlineGroup<SBinding<Data>, ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent {
        
    }
    
    /// Creates a hierarchical list that identifies its rows based on a key path to the identifier of the underlying data, optionally allowing users to select multiple rows.
    ///
    ///
    init<Data, ID, RowContent>(_ data: SBinding<Data>,
                               id: KeyPath<Data.Element, ID>,
                               children: WritableKeyPath<Data.Element, Data?>,
                               selection: SBinding<Set<Selection>>?,
                               rowContent: @escaping (SBinding<Data.Element>) -> RowContent)
    where Content == SOutlineGroup<SBinding<Data>, ID, RowContent, RowContent, SDisclosureGroup<RowContent, SOutlineSubgroupChildren>>,
    Data : MutableCollection,
    Data : RandomAccessCollection,
    ID : Hashable,
    RowContent : SContent {
        
    }
     */
}
