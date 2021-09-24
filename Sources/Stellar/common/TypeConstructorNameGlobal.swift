//
//  TypeConstructorNameGlobal.swift
//  
//
//  Created by Jesse Spencer on 5/17/21.
//

import Foundation

/// Creates a string of the type's constructor name which excludes any generic type parameters.
///
/// This function is useful to compare instances of generic types without concern for their dynamic type.
func typeConstructorName(_ type: Any.Type) -> String {
    String(String(reflecting: type).prefix { $0 != "<" })
}
