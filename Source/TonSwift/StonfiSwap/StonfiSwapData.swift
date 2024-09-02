//
//  StonfiSwapData.swift
//
//  Created by Sun on 2024/5/7.
//

import BigInt
import Foundation

public struct StonfiSwapData: CellCodable {
    // MARK: Properties

    public let assetToSwap: Address
    public let minAskAmount: BigUInt
    public let userWalletAddress: Address
    public let referralAddress: Address?

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> StonfiSwapData {
        _ = try slice.loadUint(bits: 32)
        let assetToSwap: Address = try slice.loadType()
        let minAskAmount = try slice.loadCoins().amount
        
        let userWalletAddress: Address = try slice.loadType()
        let withReferral = try slice.loadBoolean()
      
        var referralAddress: Address? = nil
        if withReferral {
            referralAddress = try slice.loadType()
        }

        return StonfiSwapData(
            assetToSwap: assetToSwap,
            minAskAmount: minAskAmount,
            userWalletAddress: userWalletAddress,
            referralAddress: referralAddress
        )
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(uint: OpCodes.STONFI_SWAP, bits: 32)
        try builder.store(AnyAddress(assetToSwap))
        try builder.store(coins: Coins(minAskAmount.magnitude))
        try builder.store(AnyAddress(userWalletAddress))

        if referralAddress != nil {
            try builder.store(bit: true)
            try builder.store(AnyAddress(referralAddress))
        } else {
            try builder.store(bit: false)
        }
    }
}
