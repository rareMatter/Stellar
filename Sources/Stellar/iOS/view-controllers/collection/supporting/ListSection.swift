//
//  ListSection.swift
//  
//
//  Created by Jesse Spencer on 10/8/21.
//

import Foundation
import Combine

struct ListSection: Hashable, Identifiable {
    
    var id: Int
    
    let rowProvider: () -> UIKitRenderableContent
    let headerProvider: () -> UIKitRenderableContent
    let footerProvider: () -> UIKitRenderableContent
    
    let dataSubject: CurrentValueSubject<[AnyHashable], Never> = .init([])
    
    var cancellables: Set<AnyCancellable> = .init()
    
    init<Data>(id: Int,
               dataSubject: CurrentValueSubject<Data, Never>,
               rowProvider: @escaping () -> UIKitRenderableContent,
               headerProvider: @escaping () -> UIKitRenderableContent,
               footerProvider: @escaping () -> UIKitRenderableContent)
    where Data : RandomAccessCollection,
    Data.Element : Hashable {
        self.id = id
        self.rowProvider = rowProvider
        self.headerProvider = headerProvider
        self.footerProvider = footerProvider
        
        dataSubject.map { data in
            data.map { hashable in
                AnyHashable(hashable)
            }
        }
        .sink { [self] anyHashables in
            self.dataSubject.value = anyHashables
        }
        .store(in: &cancellables)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        dataSubject.value.forEach { hasher.combine($0) }
    }
    
    static func == (lhs: ListSection, rhs: ListSection) -> Bool {
        lhs.id == rhs.id &&
        lhs.dataSubject.value == rhs.dataSubject.value
    }
}
