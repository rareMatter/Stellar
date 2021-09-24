//
//  SDynamicSizeNotifier.swift
//
//
//  Created by Jesse Spencer on 3/12/21.
//

import Combine

/// Content which can change size dynamically (i.e. for a user to enter any number of lines of text) which will publish messages after the change occurs.
protocol SDynamicSizeNotifier {
    var sizeDidChangePublisher: AnyPublisher<Any, Never> { get }
}
