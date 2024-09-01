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
