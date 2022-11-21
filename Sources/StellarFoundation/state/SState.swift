//
//  SState.swift
//  
//
//  Created by Jesse Spencer on 10/5/21.
//

protocol ValueStorage {
    var getter: (() -> Any)? { get set }
    var anyInitialValue: Any { get }
}

protocol WritableValueStorage: ValueStorage {
    // TODO: Needs Transaction param.
    var setter: ((Any) -> ())? { get set }
}

@propertyWrapper
public
struct SState<Value>: SDynamicProperty {
    
    private
    let initialValue: Value
    
    var anyInitialValue: Any { initialValue }
    
    var getter: (() -> Any)?
    // TODO: Needs Transaction param.
    var setter: ((Any) -> ())?
    
    public
    init(wrappedValue value: Value) {
        initialValue = value
    }
    
    public
    var wrappedValue: Value {
        get { getter?() as? Value ?? initialValue }
        nonmutating set { setter?(newValue) }
    }
    
    public
    var projectedValue: SBinding<Value> {
        guard let getter = getter, let setter = setter else {
            fatalError("\(#function) not available outside of `body`")
        }
        
        return .init(
            get: { getter() as! Value },
            set: { newValue in
                setter(newValue)
            }
        )
    }
}

extension SState: WritableValueStorage {}

public
extension SState
where Value: ExpressibleByNilLiteral {
    @inlinable
    init() { self.init(wrappedValue: nil) }
}
