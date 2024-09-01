import BigInt
import Foundation
import TweetNacl

// MARK: - WalletIdBeta

public struct WalletIdBeta {
    public let walletVersion: Int8 = 0
    public let subwalletNumber: Int32 = 0
    public let networkGlobalId: Int32
    public let workchain: Int8
  
    public init(networkGlobalId: Int32, workchain: Int8) {
        self.networkGlobalId = networkGlobalId
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
        walletId: WalletIdBeta,
        plugins: Set<Address> = []
    ) {
        let code = try! Cell.fromBase64(
            src: "te6cckEBAQEAIwAIQgLkzzsvTG1qYeoPK1RH0mZ4WyavNjfbLe7mvNGqgm80Eg3NjhE="
        )
        super.init(code: code, seqno: seqno, workchain: workchain, publicKey: publicKey, walletId: walletId, plugins: plugins)
    }
}

// MARK: - WalletV5BetaContract

/// Internal WalletV5 implementation. Use specific revision `WalletV5R1` instead.
public class WalletV5BetaContract: WalletContract {
    public let seqno: Int64
    public let workchain: Int8
    public let publicKey: Data
    public let walletId: WalletIdBeta
    public let plugins: Set<Address>
    public let code: Cell
    
    fileprivate init(
        code: Cell,
        seqno: Int64 = 0,
        workchain: Int8 = 0,
        publicKey: Data,
        walletId: WalletIdBeta,
        plugins: Set<Address> = []
    ) {
        self.code = code
        self.seqno = seqno
        self.workchain = workchain
        self.publicKey = publicKey
        
        self.walletId = walletId
        
        self.plugins = plugins
    }
    
    func storeWalletId() -> Builder {
        try! Builder()
            .store(int: walletId.networkGlobalId, bits: 32)
            .store(int: walletId.workchain, bits: 8)
            .store(uint: walletId.walletVersion, bits: 8)
            .store(uint: walletId.subwalletNumber, bits: 32)
    }
    
    public var stateInit: StateInit {
        let data = try! Builder()
            .store(uint: 0, bits: 33) // initial seqno = 0
            .store(storeWalletId())
            .store(data: publicKey)
            .store(bit: 0)
            .endCell()
        
        return StateInit(code: code, data: data)
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
                .store(ref: try Builder().store(message))
        }
        
        return latestCell
    }
    
    private func storeOutListExtended(messages: [MessageRelaxed], sendMode: UInt64) throws -> Builder {
        try Builder()
            .store(uint: 0, bits: 1)
            .store(ref: storeOutList(messages: messages, sendMode: sendMode))
    }
    
    public func createTransfer(args: WalletTransferData, messageType: MessageType = .ext) throws -> WalletTransfer {
        guard args.messages.count <= 255 else {
            throw TonError.custom("Maximum number of messages in a single transfer is 255")
        }
        
        let signingMessage = try Builder()
            .store(uint: messageType.opCode, bits: 32)
            .store(storeWalletId())
        
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
}
