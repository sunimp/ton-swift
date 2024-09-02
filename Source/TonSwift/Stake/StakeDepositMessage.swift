//
//  StakeDepositMessage.swift
//
//  Created by Sun on 2024/7/25.
//

import BigInt
import Foundation

public enum StakeDepositMessage {
    public static func whalesInternalMessage(
        queryID: BigUInt,
        poolAddress: Address,
        amount: BigUInt,
        forwardAmount: BigUInt,
        bounce: Bool = true
    ) throws
        -> MessageRelaxed {
        let body = Builder()
        try body.store(uint: OpCodes.WHALES_DEPOSIT, bits: 32)
        try body.store(uint: queryID, bits: 64)
        try body.store(coins: Coins(forwardAmount.magnitude))
    
        return try MessageRelaxed.internal(
            to: poolAddress,
            value: amount,
            bounce: bounce,
            body: body.asCell()
        )
    }
  
    public static func liquidTFInternalMessage(
        queryID: BigUInt,
        poolAddress: Address,
        amount: BigUInt,
        bounce: Bool = true
    ) throws
        -> MessageRelaxed {
        let body = Builder()
        try body.store(uint: OpCodes.LIQUID_TF_DEPOSIT, bits: 32)
        try body.store(uint: queryID, bits: 64)
        try body.store(uint: 0x000000000005B7CE, bits: 64)
    
        return try MessageRelaxed.internal(
            to: poolAddress,
            value: amount,
            bounce: bounce,
            body: body.asCell()
        )
    }
  
    public static func tfInternalMessage(
        queryID _: BigUInt,
        poolAddress: Address,
        amount: BigUInt,
        bounce: Bool = true
    ) throws
        -> MessageRelaxed {
        let body = Builder()
        try body.store(uint: 0, bits: 32)
        try body.writeSnakeData(Data("d".utf8))
    
        return try MessageRelaxed.internal(
            to: poolAddress,
            value: amount,
            bounce: bounce,
            body: body.asCell()
        )
    }
}
