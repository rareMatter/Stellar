//
//  AnySIdentifiableContent.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Foundation

protocol AnySIdentifiableContent {
    var anyIdentifier: AnyHashable { get }
    var anyContent: AnySContent { get }
}
