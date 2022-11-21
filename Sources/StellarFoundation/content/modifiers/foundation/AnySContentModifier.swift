//
//  AnySContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

public
struct AnySContentModifier: SContentModifier {
    
    /// The type of the wrapped `SContentModifier`.
    public
    let type: Any.Type
    
    public
    let typeConstructorName: String
    
    /// The type-erased modifier.
    public
    let modifier: Any
    
    /// The type of the `body` of the wrapped `SContentModifier`.
    public
    let bodyType: Any.Type
    
    private
    let bodyProvider: (Content) -> AnySContent
    
    public
    init<Modifier>(_ erasingModifier: Modifier)
    where Modifier : SContentModifier {
        if let anyModifier = erasingModifier as? AnySContentModifier {
            self = anyModifier
        }
        else {
            type = Modifier.self
            typeConstructorName = StellarFoundation.typeConstructorName(Modifier.self)
            modifier = erasingModifier
            bodyType = Modifier.Body.self
            bodyProvider = { contentModifierProxy in
                guard let modifier = contentModifierProxy.modifier.modifier as? Modifier else { fatalError() }
                let proxy = _SContentModifierProxy(modifier: modifier, content: contentModifierProxy.content)
                return AnySContent(erasingModifier
                                    .body(content: proxy))
            }
        }
    }
    
    public
    func body(content: Content) -> some SContent {
        bodyProvider(content)
    }
}
extension AnySContentModifier: Equatable, Hashable {
    
    public static func ==(lhs: AnySContentModifier, rhs: AnySContentModifier) -> Bool {
        lhs.typeConstructorName == rhs.typeConstructorName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(typeConstructorName)
    }
}
