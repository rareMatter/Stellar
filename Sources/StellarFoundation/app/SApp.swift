//
//  SApp.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/16/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

/// A description of your app. A type conforming to this protocol defines the app entry point using the `@main` attribute, declared on the conforming type. There should be only one type which uses `@main` and conforms to this protocol.
public
protocol SApp {
    
    associatedtype Body : SScene
    
    // TODO: @MainActor.
    @SSceneBuilder
    var body: Self.Body { get }
    
    init()
    
    // TODO: @MainActor
    static
    func main() -> Void
}
