//
//  StakeWithdrawMessage.swift
//
//  Created by Sun on 2024/7/25.
//

import BigInt
import Foundation

public enum StakeWithdrawMessage {
    public static func whalesInternalMessage(
        queryID: BigUInt,
        poolAddress: Address,
        amount: BigUInt,
        withdrawFee: BigUInt,
        forwardAmount: BigUInt,
        bounce: Bool = true
    ) throws
        -> MessageRelaxed {
        let body = Builder()
        try body.store(uint: OpCodes.WHALES_WITHDRAW, bits: 32)
        try body.store(uint: queryID, bits: 64)
        try body.store(coins: Coins(forwardAmount.magnitude))
        try body.store(coins: Coins(amount.magnitude))
    
        return try MessageRelaxed.internal(
            to: poolAddress,
            value: withdrawFee,
            bounce: bounce,
            body: body.asCell()
        )
    }
  
    public static func liquidTFInternalMessage(
        queryID: BigUInt,
        amount: BigUInt,
        withdrawFee: BigUInt,
        jettonWalletAddress: Address,
        responseAddress: Address,
        bounce: Bool = true
    ) throws
        -> MessageRelaxed {
        let customPayload = Builder()
        try customPayload.store(uint: 1, bits: 1)
        try customPayload.store(uint: 0, bits: 1)
    
        let body = Builder()
        try body.store(uint: OpCodes.LIQUID_TF_BURN, bits: 32)
        try body.store(uint: queryID, bits: 64)
        try body.store(coins: Coins(amount.magnitude))
        try body.store(AnyAddress(responseAddress))
        try body.storeMaybe(ref: customPayload.endCell())
    
        return try MessageRelaxed.internal(
            to: jettonWalletAddress,
            value: withdrawFee,
            bounce: bounce,
            body: body.asCell()
        )
    }
  
    public static func tfInternalMessage(
        queryID _: BigUInt,
        poolAddress: Address,
        amount _: BigUInt,
        withdrawFee: BigUInt,
        bounce: Bool = true
    ) throws
        -> MessageRelaxed {
        let body = Builder()
        try body.store(uint: 0, bits: 32)
        try body.writeSnakeData(Data("w".utf8))
    
        return try MessageRelaxed.internal(
            to: poolAddress,
            value: withdrawFee,
            bounce: bounce,
            body: body.asCell()
        )
    }
}
