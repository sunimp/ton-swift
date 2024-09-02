//
//  JettonTransferData.swift
//
//  Created by Sun on 2023/7/12.
//

import BigInt
import Foundation

public struct JettonTransferData: CellCodable {
    // MARK: Properties

    public let queryID: UInt64
    public let amount: BigUInt
    public let toAddress: Address
    public let responseAddress: Address
    public let forwardAmount: BigUInt
    public let forwardPayload: Cell?
    public var customPayload: Cell?

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> JettonTransferData {
        _ = try slice.loadUint(bits: 32)
        let queryID = try slice.loadUint(bits: 64)
        let amount = try slice.loadCoins().amount
        let toAddress: Address = try slice.loadType()
        let responseAddress: Address = try slice.loadType()
        let customPayload = try slice.loadMaybeRef()
        let forwardAmount = try slice.loadCoins().amount
        let forwardPayload = try slice.loadMaybeRef()
   
        return JettonTransferData(
            queryID: queryID,
            amount: amount,
            toAddress: toAddress,
            responseAddress: responseAddress,
            forwardAmount: forwardAmount,
            forwardPayload: forwardPayload,
            customPayload: customPayload
        )
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(uint: OpCodes.JETTON_TRANSFER, bits: 32)
        try builder.store(uint: queryID, bits: 64)
        try builder.store(coins: Coins(amount.magnitude))
        try builder.store(AnyAddress(toAddress))
        try builder.store(AnyAddress(responseAddress))
        try builder.storeMaybe(ref: customPayload)
        try builder.store(coins: Coins(forwardAmount.magnitude))
        try builder.storeMaybe(ref: forwardPayload)
    }
}
