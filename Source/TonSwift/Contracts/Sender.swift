//
//  Sender.swift
//
//  Created by Sun on 2023/3/7.
//

import BigInt
import Foundation

// MARK: - SenderArguments

public struct SenderArguments {
    let value: BigUInt
    let to: Address
    let sendMode: SendMode
    let bounce: Bool
    let stateInit: StateInit?
    let body: Cell
}

// MARK: - Sender

public struct Sender {
    let address: Address?
    let send: (SenderArguments) async throws -> Void
}
