//
//  NFTTransferData.swift
//
//  Created by Sun on 2023/8/26.
//

import BigInt
import Foundation

public struct NFTTransferData: CellCodable {
    // MARK: Properties

    public let queryID: UInt64
    public let newOwnerAddress: Address
    public let responseAddress: Address
    public let forwardAmount: BigUInt
    public let forwardPayload: Cell?

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> NFTTransferData {
        try slice.skip(32)
        let queryID = try slice.loadUint(bits: 64)
        let newOwnerAddress: Address = try slice.loadType()
        let responseAddress: Address = try slice.loadType()
        try slice.skip(1)
        let forwardAmount = try slice.loadCoins().amount
        let hasPayloadCell = try slice.loadBoolean()
        var forwardPayload: Cell?
        if hasPayloadCell, let payloadCell = try slice.loadMaybeRef() {
            forwardPayload = payloadCell
        }
        return NFTTransferData(
            queryID: queryID,
            newOwnerAddress: newOwnerAddress,
            responseAddress: responseAddress,
            forwardAmount: forwardAmount,
            forwardPayload: forwardPayload
        )
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(uint: OpCodes.NFT_TRANSFER, bits: 32) // transfer op
        try builder.store(uint: queryID, bits: 64)
        try builder.store(AnyAddress(newOwnerAddress))
        try builder.store(AnyAddress(responseAddress))
        try builder.store(bit: false) // null custom_payload
        try builder.store(coins: Coins(forwardAmount.magnitude))
        try builder.store(bit: forwardPayload != nil) // forward_payload in this slice - false, separate cell - true
        try builder.storeMaybe(ref: forwardPayload)
    }
}
