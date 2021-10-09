//
//  SForEach.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Foundation

public
struct SForEach<Data, ID, Content>: SPrimitiveContent
where Data: RandomAccessCollection, ID: Hashable, Content: SContent {
    
    let data: Data
    let id: KeyPath<Data.Element, ID>
    // TODO: Remove this once the framework is handling updates.
    let dataSubject: CurrentValueSubject<Data, Never>?
    
    public
    let content: (Data.Element) -> Content
    
    public
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         dataSubject: CurrentValueSubject<Data, Never>? = nil,
         @SContentBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.dataSubject = dataSubject
        self.content = content
    }    
}

// MARK: Identifiable data
public
extension SForEach
where Data.Element: Identifiable, ID == Data.Element.ID {
    
    init(_ data: Data,
         @SContentBuilder content: @escaping (Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

// MARK: Dynamic, Identifiable data
import Combine

public
extension SForEach
where Data.Element : Identifiable, ID == Data.Element.ID {
    // TODO: Remove this once the framework is handling updates.
    init(_ dataSubject: CurrentValueSubject<Data, Never>,
         @SContentBuilder content: @escaping (Data.Element) -> Content) {
        self.init(dataSubject.value,
                  id: \.id,
                  dataSubject: dataSubject,
                  content: content)
    }
}

// MARK: - protocol conformance

extension SForEach: _SContentContainer {
    var children: [AnySContent] {
        data.map { AnySContent(SIdentifiableContent(content($0), id: $0[keyPath: id])) }
    }
}

// MARK: - temporary flag for data updating content container
// TODO: Remove this when the framework is handling updates.
protocol DataPublisher {
    var _dataIDSubject: CurrentValueSubject<[AnyHashable], Never> { get }
}
extension SForEach: DataPublisher {
    var _dataIDSubject: CurrentValueSubject<[AnyHashable], Never> {
        .init([data.map({ element in
            AnyHashable(element[keyPath: id])
        })])
    }
}
