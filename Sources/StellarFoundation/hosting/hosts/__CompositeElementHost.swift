//
//  __CompositeElementHost.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

final
class __CompositeElementHost: _MutableCompositeElementHost {

    var element: CompositeElement
    var state: CompositeElementState
    
    var mutableState: CompositeElementState {
        get { state }
        set { state = newValue }
    }
    
    init(element: CompositeElement, state: CompositeElementState = .init()) {
        self.element = element
        self.state = state
    }
    
    func render(with context: RenderContext, enqueueUpdate: @autoclosure @escaping () -> Void) -> RenderOutput {
        processCompositeElement(renderContext: context, enqueueUpdate: enqueueUpdate)
        // TODO: schedule post-render callbacks to handle appearance actions and update preferences.
        /*
         reconciler.afterCurrentRender { [weak self] in
         guard let self = self else { return }
         
         }
         */
        return .init(renderedElement: nil, children: [element._body], modifiers: .init())
    }
    
    func update(with context: RenderContext, enqueueUpdate: @autoclosure @escaping () -> Void) -> RenderOutput {
        // TODO: Handle transaction.
        // TODO: Update variadic views.
        processCompositeElement(renderContext: context, enqueueUpdate: enqueueUpdate)
        return .init(renderedElement: nil, children: [element._body], modifiers: .init())
    }
    
    func dismantle(with context: RenderContext) {
        /* TODO: Move to reconciler.
         // TODO: transaction.
         
         // unmount children
         children.forEach { childHost in
         // TODO: view traits.
         //            host.viewTraits = viewTraits
         childHost.unmount(in: reconciler,
         parentTask: parentTask)
         }
         
         // TODO: Call appearance action.
         */
    }
    
    /// Updates the host's environment and inspects the hosted element at the key path to set up the host's value storage and transient subscriptions.
    private
    func processCompositeElement(renderContext: RenderContext, enqueueUpdate: @escaping () -> Void) {
        #warning("Environment should be updated before this runs.")
        
        var stateIdx = 0
        let elementUpdateResult = updateDynamicProperties(in: element)
        element = elementUpdateResult.updatedElement
        
        state.transientSubscriptions = []
        
        for property in elementUpdateResult.dynamicProperties {
            // set up state and subscriptions
            if property.type is ValueStorage.Type {
                initStorage(id: stateIdx, for: property) { [weak self] newValue in
                    guard let self else { return }
                    self.mutableState.storage[stateIdx] = newValue
                    enqueueUpdate()
                }
                stateIdx += 1
            }
            if property.type is SObservedProperty.Type {
                guard let observedProperty = property.get(from: element) as? SObservedProperty else { fatalError() }
                observedProperty
                    .objectWillChange
                    .sink { _ in
                        enqueueUpdate()
                    }
                    .store(in: &mutableState.transientSubscriptions)
            }
        }
    }
    
    private
    func initStorage(id: Int,
                     for property: PropertyInfo,
                     enqueueStorageUpdate: @escaping (Any) -> Void) {
        var storage = property.get(from: element) as! ValueStorage
        
        if mutableState.storage.count == id {
            mutableState.storage.append(storage.anyInitialValue)
        }
        
        if storage.getter == nil {
            storage.getter = { [weak self] in
                guard let self else { return }
                return self.mutableState.storage[id]
            }
            
            guard var writableStorage = storage as? WritableValueStorage else {
                property.set(value: storage, on: &element)
                return
            }
            
            // TODO: Need Transaction param.
            writableStorage.setter = { enqueueStorageUpdate($0) }
            
            property.set(value: writableStorage, on: &element)
        }
    }
    
    /// Recursively extracts all `SDynamicProperty` conforming properties from the type.
    ///
    /// Recursion is used to extract nested dynamic properties.
    ///
    /// Environment values may also be injected during this process.
    func updateDynamicProperties(in element: CompositeElement) -> (updatedElement: CompositeElement, dynamicProperties: [PropertyInfo]) {
        var elementCopy: Any = element
        var props: [PropertyInfo] = []
        recursivelyUpdateDynamicProps(in: &elementCopy, dynamicProps: &props)
        guard let updatedElement = elementCopy as? CompositeElement else { fatalError() }
        return (updatedElement, props)
    }
    func recursivelyUpdateDynamicProps(in source: inout Any, dynamicProps: inout [PropertyInfo]) {
        // TODO: This does not allow for non-dynamic properties to contain nested dynamic properties. As written, only dynamic properties will be checked for nested dynamic properties. Is this proper behavior?
        // TODO: Should this be silently skipping properties?
        guard let sourceTypeInfo = typeInfo(of: getType(source)) else {
            // TODO: If type info cannot be determined, it's likely that a class type was provided and the client should be informed in some way.
            return
        }
        
        for property in sourceTypeInfo.properties
        where property.type is SDynamicProperty.Type {
            dynamicProps.append(property)
            
            var propertyValue = property.get(from: source)
            guard var dynamicProperty = propertyValue as? SDynamicProperty else { fatalError() }
            
            recursivelyUpdateDynamicProps(in: &propertyValue, dynamicProps: &dynamicProps)
            
            dynamicProperty.update()
            property.set(value: dynamicProperty, on: &source)
        }
    }
}
