//
//  CurrencyCollection.swift
//
//  Created by Sun on 2023/3/13.
//

import BigInt
import Foundation

/// Implements ExtraCurrencyCollection per TLB schema:
///
/// ```
/// extra_currencies$_ dict:(HashmapE 32 (VarUInteger 32)) = ExtraCurrencyCollection;
/// ```
public typealias ExtraCurrencyCollection = [UInt32: VarUInt248]

// MARK: - CurrencyCollection

/// Implements CurrencyCollection per TLB schema:
///
/// ```
/// currencies$_ grams:Grams other:ExtraCurrencyCollection = CurrencyCollection;
/// ```
public struct CurrencyCollection: CellCodable {
    // MARK: Properties

    public let coins: Coins
    public let other: ExtraCurrencyCollection

    // MARK: Lifecycle

    init(coins: Coins, other: ExtraCurrencyCollection = [:]) {
        self.coins = coins
        self.other = other
    }

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> CurrencyCollection {
        let coins = try slice.loadCoins()
        let other: ExtraCurrencyCollection = try slice.loadType()
        return CurrencyCollection(coins: coins, other: other)
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(coins: coins)
        try builder.store(other)
    }
}
