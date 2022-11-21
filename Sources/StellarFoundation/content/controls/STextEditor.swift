//
//  STextEditor.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

public
struct STextEditor: SPrimitiveContent {
    @SBinding var text: String
    let placeholderText: String
    let onTextChange: (String) -> Void
    
    public
    init(text: SBinding<String>,
         placeholderText: String = "",
         onTextChange: @escaping (String) -> Void) {
        self._text = text
        self.placeholderText = placeholderText
        self.onTextChange = onTextChange
    }
}
