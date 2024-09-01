import BigInt
import Foundation

// MARK: - WalletContract

/// All wallets implement a compatible interface for sending messages
public protocol WalletContract: Contract {
    func createTransfer(args: WalletTransferData, messageType: MessageType) throws -> WalletTransfer
}

// MARK: - MessageType

/// Message type (external | internal) to sign. Is using in v5 wallet contract
public enum MessageType {
    case int, ext
    
    var opCode: Int32 {
        switch self {
        case .int: OpCodes.SIGNED_INTERNAL
        case .ext: OpCodes.SIGNED_EXTERNAL
        }
    }
}

// MARK: - WalletTransferData

public struct WalletTransferData {
    public let seqno: UInt64
    public let messages: [MessageRelaxed]
    public let sendMode: SendMode
    public let timeout: UInt64?
    
    public init(
        seqno: UInt64,
        messages: [MessageRelaxed],
        sendMode: SendMode,
        timeout: UInt64?
    ) {
        self.seqno = seqno
        self.messages = messages
        self.sendMode = sendMode
        self.timeout = timeout
    }
}

// MARK: - SignaturePosition

public enum SignaturePosition {
    case front, tail
}

// MARK: - WalletTransfer

public struct WalletTransfer {
    public let signingMessage: Builder
    public let signaturePosition: SignaturePosition
    
    public init(signingMessage: Builder, signaturePosition: SignaturePosition) {
        self.signingMessage = signingMessage
        self.signaturePosition = signaturePosition
    }
    
    public func signMessage(signer: WalletTransferSigner) throws -> Data {
        try signer.signMessage(signingMessage.endCell().hash())
    }
}
