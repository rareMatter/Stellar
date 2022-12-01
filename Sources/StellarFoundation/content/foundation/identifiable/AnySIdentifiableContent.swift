//
//  AnySIdentifiableContent.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

public
protocol AnySIdentifiableContent {
    var anyIdentifier: any Hashable { get }
    var anyContent: any SContent { get }
}
