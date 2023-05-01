//
//  SForEach.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

public
struct SForEach<Data, ID, Content>: SPrimitiveContent
where Data: RandomAccessCollection, ID: Hashable, Content: SContent {
    
    let data: Data
    let id: KeyPath<Data.Element, ID>
    
    public
    let content: (Data.Element) -> Content
    
    public
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         @SContentBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
// TODO: This likely should be removed after a lazy approach is implemented.
extension SForEach: GroupedContent {
    public
    var children: [any SContent] {
        data.map { element in
            SIdentifiableContent(content(element), id: element[keyPath: id])
        }
    }
}

// MARK: Identifiable data
public
extension SForEach
where Data.Element : Identifiable, ID == Data.Element.ID {
    
    init(_ data: Data,
         @SContentBuilder content: @escaping (Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

// MARK: Ranges

public
extension SForEach
where Data == Range<Int>,
      ID == Int {
    init(_ data: Range<Int>,
         @SContentBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        id = \.self
        self.content = content
    }
}

// MARK: Internal recognition
protocol SForEachProtocol {
    var elementType: Any.Type { get }
    func element(at: Int) -> Any
}
extension SForEach: SForEachProtocol
where Data.Index == Int {
    
    var elementType: Any.Type { Data.Element.self }
    
    func element(at index: Int) -> Any {
        data[index]
    }
}

// MARK: type erasure

/// A type-erased ForEach which forwards all calls to the wrapped instance.
struct AnyForEach: SPrimitiveContent {
    
    /// The wrapped data type.
    let dataType: Any.Type
    /// The wrapped id keypath type.
    let idType: Any.Type
    /// The wrapped content type.
    let contentType: Any.Type
    
    let content: (_ datum: Any) -> any SContent
    let data: [Any]
    let id: AnyKeyPath
    
    init<Data, ID, Content>(_ forEach: SForEach<Data, ID, Content>) {
        self.dataType = Data.self
        self.idType = ID.self
        self.contentType = Content.self
        
        self.content = { [forEach] datum in
            guard let matchingDatum = forEach.data.first(where: { element in
                element[keyPath: forEach.id] == (datum[keyPath: forEach.id as AnyKeyPath] as? ID)
            }) else { fatalError() }
            return forEach.content(matchingDatum)
        }
        self.data = Array(forEach.data.map({ $0 as Any }))
        self.id = forEach.id
    }
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
