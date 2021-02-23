//
//  Destination.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/16/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation

/// A place in the app that can be navigated to from a `Location`.
public
protocol Destination: DestinationIdentifiable {
    
    /*
    associatedtype Location
    var location: Location { get set }
    */

    func makePresentationData() -> NLPresentationData
}

protocol Location {
    associatedtype Renderable
    var renderable: Renderable { get }
}
extension Location where Renderable: ViewController {
    
}

protocol LocationStyle {
    
}


