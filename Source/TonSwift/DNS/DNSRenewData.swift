//
//  DNSRenewData.swift
//
//  Created by Sun on 2024/6/12.
//

import BigInt
import Foundation

public struct DNSRenewData: CellCodable {
    // MARK: Properties

    public let queryID: UInt64

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> DNSRenewData {
        try slice.skip(32)
        let queryID = try slice.loadUint(bits: 64)
        try slice.skip(256)
        return DNSRenewData(queryID: queryID)
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(uint: OpCodes.CHANGE_DNS_RECORD, bits: 32)
        try builder.store(uint: queryID, bits: 64)
        try builder.store(uint: 0, bits: 256)
    }
}
