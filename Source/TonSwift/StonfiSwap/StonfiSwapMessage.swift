import BigInt
import Foundation

public enum StonfiSwapMessage {
    /// Jetton --> Jetton swap message
    public static func internalMessage(
        userWalletAddress: Address,
        minAskAmount: BigUInt,
        offerAmount: BigUInt,
        jettonFromWalletAddress: Address,
        jettonToWalletAddress: Address,
        referralAddress: Address? = nil,
        forwardAmount: BigUInt,
        attachedAmount: BigUInt
    ) throws -> MessageRelaxed {
        let queryId = UInt64(Date().timeIntervalSince1970)
        
        let stonfiSwapData = StonfiSwapData(
            assetToSwap: jettonToWalletAddress,
            minAskAmount: minAskAmount,
            userWalletAddress: userWalletAddress,
            referralAddress: referralAddress
        )
        
        let stonfiSwapCell = try Builder().store(stonfiSwapData).endCell()
        
        let jettonTransferData = JettonTransferData(
            queryId: queryId,
            amount: offerAmount,
            toAddress: try! Address.parse(STONFI_CONSTANTS.RouterAddress),
            responseAddress: userWalletAddress,
            forwardAmount: forwardAmount,
            forwardPayload: stonfiSwapCell,
            customPayload: nil
        )
        
        return MessageRelaxed.internal(
            to: jettonFromWalletAddress,
            value: attachedAmount,
            bounce: true,
            body: try Builder().store(jettonTransferData).endCell()
        )
    }
}

