//
//  WalletV1.swift
//
//  Created by Sun on 2023/3/25.
//

import BigInt
import Foundation
import TweetNacl

// MARK: - WalletContractV1Revision

public enum WalletContractV1Revision {
    case r1
    case r2
    case r3
}

// MARK: - WalletV1

public final class WalletV1: WalletContract {
    // MARK: Properties

    public let workchain: Int8
    public let stateInit: StateInit
    public let publicKey: Data
    public let revision: WalletContractV1Revision

    // MARK: Lifecycle

    public init(workchain: Int8, publicKey: Data, revision: WalletContractV1Revision) throws {
        self.workchain = workchain
        self.publicKey = publicKey
        self.revision = revision
        
        let bocString =
            switch revision {
            case .r1:
                "te6cckEBAQEARAAAhP8AIN2k8mCBAgDXGCDXCx/tRNDTH9P/0VESuvKhIvkBVBBE+RDyovgAAdMfMSDXSpbTB9QC+wDe0aTIyx/L/8ntVEH98Ik="
            
            case .r2:
                "te6cckEBAQEAUwAAov8AIN0gggFMl7qXMO1E0NcLH+Ck8mCBAgDXGCDXCx/tRNDTH9P/0VESuvKhIvkBVBBE+RDyovgAAdMfMSDXSpbTB9QC+wDe0aTIyx/L/8ntVNDieG8="
            
            case .r3:
                "te6cckEBAQEAXwAAuv8AIN0gggFMl7ohggEznLqxnHGw7UTQ0x/XC//jBOCk8mCBAgDXGCDXCx/tRNDTH9P/0VESuvKhIvkBVBBE+RDyovgAAdMfMSDXSpbTB9QC+wDe0aTIyx/L/8ntVLW4bkI="
            }
        
        let cell = try Cell.fromBoc(src: Data(base64Encoded: bocString)!)[0]
        let data = try Builder().store(uint: UInt64(0), bits: 32) // Seqno
        try data.store(data: publicKey)
        
        stateInit = try StateInit(code: cell, data: data.endCell())
    }

    // MARK: Functions

    public func createTransfer(args: WalletTransferData, messageType _: MessageType = .ext) throws -> WalletTransfer {
        let signingMessage = try Builder().store(uint: args.seqno, bits: 32)
        
        if let message = args.messages.first {
            try signingMessage.store(uint: UInt64(args.sendMode.rawValue), bits: 8)
            try signingMessage.store(ref: Builder().store(message))
        }
        
        return WalletTransfer(signingMessage: signingMessage, signaturePosition: .front)
    }
}
