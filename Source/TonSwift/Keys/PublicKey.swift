//
//  PublicKey.swift
//
//  Created by Sun on 2023/6/22.
//

import Foundation

// MARK: - PublicKey

public struct PublicKey: Key, Codable {
    // MARK: Properties

    public let data: Data

    // MARK: Lifecycle

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
