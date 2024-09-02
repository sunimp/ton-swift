//
//  PrivateKey.swift
//
//  Created by Sun on 2023/6/22.
//

import Foundation

public struct PrivateKey: Key, Equatable, Codable {
    // MARK: Properties

    public let data: Data

    // MARK: Lifecycle

    public init(data: Data) {
        self.data = data
    }
}
