//
//  WalletTransferSigner.swift
//
//  Created by Sun on 2023/11/18.
//

import Foundation
import TweetNacl

// MARK: - WalletTransferSignerError

public enum WalletTransferSignerError: Swift.Error {
    case failedToSignMessage
}

// MARK: - WalletTransferSigner

public protocol WalletTransferSigner {
    func signMessage(_ message: Data) throws -> Data
}

// MARK: - WalletTransferSecretKeySigner

public struct WalletTransferSecretKeySigner: WalletTransferSigner {
    // MARK: Properties

    private let secretKey: Data

    // MARK: Lifecycle

    public init(secretKey: Data) {
        self.secretKey = secretKey
    }

    // MARK: Functions

    public func signMessage(_ message: Data) throws -> Data {
        do {
            return try NaclSign.signDetached(message: message, secretKey: secretKey)
        } catch {
            throw WalletTransferSignerError.failedToSignMessage
        }
    }
}

// MARK: - WalletTransferEmptyKeySigner

public struct WalletTransferEmptyKeySigner: WalletTransferSigner {
    // MARK: Lifecycle

    public init() { }

    // MARK: Functions

    public func signMessage(_: Data) throws -> Data {
        guard let data = String(repeating: "0", count: .signatureBytesCount).data(using: .utf8) else {
            throw WalletTransferSignerError.failedToSignMessage
        }
        return data
    }
}

extension Int {
    fileprivate static let signatureBytesCount = 64
}
