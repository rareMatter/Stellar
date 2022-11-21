//
//  SObservedObject.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Combine

@propertyWrapper
public
struct SObservedObject<ObjectType>: SDynamicProperty
where ObjectType: ObservableObject {
    
    @dynamicMemberLookup
    public
    struct Wrapper {
        let root: ObjectType
        
        public
        subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> SBinding<Subject> {
            .init {
                self.root[keyPath: keyPath]
            } set: {
                self.root[keyPath: keyPath] = $0
            }
        }
    }
    
    public
    var wrappedValue: ObjectType { projectedValue.root }
    
    public
    init(wrappedValue: ObjectType) {
        projectedValue = Wrapper(root: wrappedValue)
    }
    
    public
    let projectedValue: Wrapper
}

// MARK: property observing

protocol SObservedProperty: SDynamicProperty {
    var objectWillChange: AnyPublisher<(), Never> { get }
}

extension SObservedObject: SObservedProperty {
    
    var objectWillChange: AnyPublisher<(), Never> {
        wrappedValue
            .objectWillChange
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
