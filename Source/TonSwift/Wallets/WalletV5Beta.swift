//
//  WalletV5Beta.swift
//
//  Created by Sun on 2024/6/13.
//

import BigInt
import Foundation
import TweetNacl

// MARK: - WalletIDBeta

public struct WalletIDBeta {
    // MARK: Properties

    public let walletVersion: Int8 = 0
    public let subwalletNumber: Int32 = 0
    public let networkGlobalID: Int32
    public let workchain: Int8

    // MARK: Lifecycle

    public init(networkGlobalID: Int32, workchain: Int8) {
        self.networkGlobalID = networkGlobalID
        self.workchain = workchain
    }
}

// MARK: - WalletV5Beta

/// WARNING: WalletW5 contract is still in beta. use at your own risk
public class WalletV5Beta: WalletV5BetaContract {
    public init(
        seqno: Int64 = 0,
        workchain: Int8 = 0,
        publicKey: Data,
        walletID: WalletIDBeta,
        plugins: Set<Address> = []
    ) {
        let code = try! Cell.fromBase64(
            src: "te6cckEBAQEAIwAIQgLkzzsvTG1qYeoPK1RH0mZ4WyavNjfbLe7mvNGqgm80Eg3NjhE="
        )
        super.init(
            code: code,
            seqno: seqno,
            workchain: workchain,
            publicKey: publicKey,
            walletID: walletID,
            plugins: plugins
        )
    }
}

// MARK: - WalletV5BetaContract

/// Internal WalletV5 implementation. Use specific revision `WalletV5R1` instead.
public class WalletV5BetaContract: WalletContract {
    // MARK: Properties

    public let seqno: Int64
    public let workchain: Int8
    public let publicKey: Data
    public let walletID: WalletIDBeta
    public let plugins: Set<Address>
    public let code: Cell

    // MARK: Computed Properties

    public var stateInit: StateInit {
        let data = try! Builder()
            .store(uint: 0, bits: 33) // initial seqno = 0
            .store(storeWalletID())
            .store(data: publicKey)
            .store(bit: 0)
            .endCell()
        
        return StateInit(code: code, data: data)
    }

    // MARK: Lifecycle

    fileprivate init(
        code: Cell,
        seqno: Int64 = 0,
        workchain: Int8 = 0,
        publicKey: Data,
        walletID: WalletIDBeta,
        plugins: Set<Address> = []
    ) {
        self.code = code
        self.seqno = seqno
        self.workchain = workchain
        self.publicKey = publicKey
        
        self.walletID = walletID
        
        self.plugins = plugins
    }

    // MARK: Functions

    public func createTransfer(args: WalletTransferData, messageType: MessageType = .ext) throws -> WalletTransfer {
        guard args.messages.count <= 255 else {
            throw TonError.custom("Maximum number of messages in a single transfer is 255")
        }
        
        let signingMessage = try Builder()
            .store(uint: messageType.opCode, bits: 32)
            .store(storeWalletID())
        
        if args.seqno == 0 {
            // 32 bits with 1
            try signingMessage.store(uint: 0xFFFFFFFF, bits: 32)
        } else {
            let defaultTimeout = UInt64(Date().timeIntervalSince1970) + 60 // Default timeout: 60 seconds
            try signingMessage.store(uint: args.timeout ?? defaultTimeout, bits: 32)
        }
        
        try signingMessage
            .store(uint: args.seqno, bits: 32)
            .store(
                storeOutListExtended(
                    messages: args.messages,
                    sendMode: UInt64(args.sendMode.rawValue)
                )
            )
        
        return WalletTransfer(signingMessage: signingMessage, signaturePosition: .tail)
    }

    func storeWalletID() -> Builder {
        try! Builder()
            .store(int: walletID.networkGlobalID, bits: 32)
            .store(int: walletID.workchain, bits: 8)
            .store(uint: walletID.walletVersion, bits: 8)
            .store(uint: walletID.subwalletNumber, bits: 32)
    }
    
    func pluginsCompact() -> Set<CompactAddress> {
        Set(plugins.map { a in CompactAddress(a) })
    }

    /// out_list_empty$_ = OutList 0;
    /// out_list$_ {n:#} prev:^(OutList n) action:OutAction
    /// = OutList (n + 1);
    private func storeOutList(messages: [MessageRelaxed], sendMode: UInt64) throws -> Builder {
        var latestCell = Builder()
        for message in messages {
            latestCell = try Builder()
                .store(uint: OpCodes.OUT_ACTION_SEND_MSG_TAG, bits: 32)
                .store(uint: sendMode, bits: 8)
                .store(ref: latestCell)
                .store(ref: Builder().store(message))
        }
        
        return latestCell
    }
    
    private func storeOutListExtended(messages: [MessageRelaxed], sendMode: UInt64) throws -> Builder {
        try Builder()
            .store(uint: 0, bits: 1)
            .store(ref: storeOutList(messages: messages, sendMode: sendMode))
    }
}
