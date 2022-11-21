//
//  SStateObject.swift
//  
//
//  Created by Jesse Spencer on 10/3/21.
//

import Combine

@propertyWrapper
public
struct SStateObject<ObjectType: ObservableObject>: SDynamicProperty {
    
    public
    var wrappedValue: ObjectType {
        (getter?() as? SObservedObject.Wrapper)?.root ??
        initial()
    }
    
    let initial: () -> ObjectType
    var getter: (() -> Any)?
    
    public
    init(wrappedValue initial: @autoclosure @escaping () -> ObjectType) {
        self.initial = initial
    }
    
    public
    var projectedValue: SObservedObject<ObjectType>.Wrapper {
        getter?() as? SObservedObject.Wrapper ??
        SObservedObject.Wrapper(root: initial())
    }
}

extension SStateObject: SObservedProperty {
    var objectWillChange: AnyPublisher<(), Never> {
        wrappedValue
            .objectWillChange
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

// TODO: Needs SValueStorage conformance.
extension SStateObject {
    var anyInitialValue: Any {
        SObservedObject.Wrapper(root: initial())
    }
}
