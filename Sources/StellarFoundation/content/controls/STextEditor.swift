//
//  STextEditor.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

public
struct STextEditor: SPrimitiveContent {
    @SBinding public var text: String
    public let placeholderText: String
    public let onTextChange: (String) -> Void
    
    public
    init(text: SBinding<String>,
         placeholderText: String = "",
         onTextChange: @escaping (String) -> Void) {
        self._text = text
        self.placeholderText = placeholderText
        self.onTextChange = onTextChange
    }
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
