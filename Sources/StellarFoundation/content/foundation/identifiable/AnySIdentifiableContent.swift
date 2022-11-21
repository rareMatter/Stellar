//
//  AnySIdentifiableContent.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

public
protocol AnySIdentifiableContent {
    var anyIdentifier: AnyHashable { get }
    var anyContent: AnySContent { get }
}
