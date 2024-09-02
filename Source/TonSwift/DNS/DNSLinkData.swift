//
//  DNSLinkData.swift
//
//  Created by Sun on 2024/5/27.
//

import BigInt
import Foundation

public struct DNSLinkData: CellCodable {
    // MARK: Properties

    public let queryID: UInt64
    public let linkAddress: Address?

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> DNSLinkData {
        try slice.skip(32)
        let queryID = try slice.loadUint(bits: 64)
        try slice.skip(256)
        var address: Address?
        if let ref = try slice.loadMaybeRef() {
            let slice = try ref.toSlice()
            try slice.skip(16)
            address = try slice.loadType()
        }
        return DNSLinkData(queryID: queryID, linkAddress: address)
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(uint: OpCodes.CHANGE_DNS_RECORD, bits: 32)
        try builder.store(uint: queryID, bits: 64)
        try builder.store(
            biguint: BigUInt("e8d44050873dba865aa7c170ab4cce64d90839a34dcfd6cf71d14e0205443b1b", radix: 16) ?? 0,
            bits: 256
        )
        if let linkAddress {
            try builder.storeMaybe(
                ref: Builder()
                    .store(uint: 0x9FD3, bits: 16)
                    .store(AnyAddress(linkAddress))
                    .store(uint: 0, bits: 8)
            )
        }
    }
}
