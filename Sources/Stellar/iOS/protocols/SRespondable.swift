//
//  SRespondable.swift
//  Stellar
//
//  Created by Jesse Spencer on 11/11/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Combine

/// Content which can respond and allows control and observation of its response.
protocol SRespondable {
    
    /// The current state of the responder.
    var responderStatus: ResponderState.Status { get }
    
    /// This publisher sends the `UIResponder` instance which has changed its reponse state.
    var responderStatusPublisher: AnyPublisher<ResponderState, Never> { get }
    
    /// Tells the conformer to become the responder and returns whether it successfully responded or not.
    func becomeResponder() -> Bool
    
    /// Tells the conformer to stop responding and returns whether it successfully stopped or not.
    func stopResponding() -> Bool
}

struct ResponderState {
    let responder: SRespondable
    let sendingResponder: Any
    let status: Status
    
    enum Status {
        case responding,
             resigned
    }
    
    /// Returns a new instance with the sender property replaced using the provided sender.
    func replacingSenderWith(_ newSender: Any) -> Self {
        ResponderState(responder: responder,
                       sendingResponder: newSender,
                       status: status)
    }
}
extension ResponderState {
    
    static
    func responding(responder: SRespondable, sendingResponder: Any) -> Self {
        .init(responder: responder, sendingResponder: sendingResponder, status: .responding)
    }
    
    static
    func resigned(responder: SRespondable, sendingResponder: Any) -> Self {
        .init(responder: responder, sendingResponder: sendingResponder, status: .resigned)
    }
}
