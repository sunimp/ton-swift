//
//  ExternalAddress.swift
//
//  Created by Sun on 2023/3/3.
//

import Foundation

// MARK: - ExternalAddress

/// External address TL-B definition:
/// ```
/// addr_extern$01 len:(## 9) external_address:(bits len) = MsgAddressExt;
/// ```
public struct ExternalAddress {
    // MARK: Properties

    private(set) var value: Bitstring

    // MARK: Lifecycle

    public init(value: Bitstring) {
        self.value = value
    }

    // MARK: Static Functions

    public static func mock(seed: String) throws -> Self {
        let value = Bitstring(data: Data(seed.utf8).sha256())
        return ExternalAddress(value: value)
    }

    // MARK: Functions

    public func toString() -> String {
        "External<\(value.length):\(value.toString())>"
    }
}

// MARK: CellCodable

extension ExternalAddress: CellCodable {
    public func storeTo(builder: Builder) throws {
        try builder.store(uint: 1, bits: 2)
        try builder.store(uint: value.length, bits: 9)
        try builder.store(bits: value)
    }
    
    public static func loadFrom(slice: Slice) throws -> ExternalAddress {
        try slice.tryLoad { s in
            let type = try s.loadUint(bits: 2)
            if type != 1 {
                throw TonError.custom("Invalid ExternalAddress")
            }
            
            let bits = try Int(s.loadUint(bits: 9))
            let data = try s.loadBits(bits)
            
            return ExternalAddress(value: data)
        }
    }
}
