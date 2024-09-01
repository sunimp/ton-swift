//
//  PublicKey.swift
//
//
//  Created by Grigory on 22.6.23..
//

import Foundation

// MARK: - PublicKey

public struct PublicKey: Key, Codable {
    public let data: Data
    
    public init(data: Data) {
        self.data = data
    }
}

// MARK: CellCodable

extension PublicKey: CellCodable {
    public func storeTo(builder: Builder) throws {
        try builder.store(data: data)
    }
    
    public static func loadFrom(slice: Slice) throws -> PublicKey {
        try slice.tryLoad { s in
            let data = try s.loadBytes(.publicKeyLength)
            return PublicKey(data: data)
        }
    }
}

extension Int {
    fileprivate static let publicKeyLength = 32
}
