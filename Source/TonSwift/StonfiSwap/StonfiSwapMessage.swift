//
//  StonfiSwapMessage.swift
//
//  Created by Sun on 2024/5/7.
//

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
    ) throws
        -> MessageRelaxed {
        let queryID = UInt64(Date().timeIntervalSince1970)
        
        let stonfiSwapData = StonfiSwapData(
            assetToSwap: jettonToWalletAddress,
            minAskAmount: minAskAmount,
            userWalletAddress: userWalletAddress,
            referralAddress: referralAddress
        )
        
        let stonfiSwapCell = try Builder().store(stonfiSwapData).endCell()
        
        let jettonTransferData = JettonTransferData(
            queryID: queryID,
            amount: offerAmount,
            toAddress: try! Address.parse(STONFI_CONSTANTS.RouterAddress),
            responseAddress: userWalletAddress,
            forwardAmount: forwardAmount,
            forwardPayload: stonfiSwapCell,
            customPayload: nil
        )
        
        return try MessageRelaxed.internal(
            to: jettonFromWalletAddress,
            value: attachedAmount,
            bounce: true,
            body: Builder().store(jettonTransferData).endCell()
        )
    }
}
