//
//  NavigatorFactoryContaining.swift
//  Stellar
//
//  Created by Jesse Spencer on 1/7/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation

/// A convenience protocol for objects which contain a navigator factory. A default implementation is provided for syntax sugar.
public
protocol NavigatorFactoryContaining {
    var navigatorFactory: NavigatorFactory { get }
}
public
extension NavigatorFactoryContaining {
    /// Creates a new navigator using the factory.
    var navigator: AnyNavigator<NLDestination> {
        navigatorFactory.makeNavigator()
    }
}
