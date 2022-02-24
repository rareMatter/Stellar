//
//  SSearchBar.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SSearchBar: SPrimitiveContent {
    @SBinding var text: String
    let placeholderText: String
    let onSearch: (String) -> Void
    let onSearchEnded: () -> Void
}
