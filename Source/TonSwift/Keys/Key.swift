//
//  Key.swift
//
//  Created by Sun on 2023/6/22.
//

import Foundation

// MARK: - Key

public protocol Key {
    var data: Data { get }
    var hexString: String { get }
}

extension Key {
    public var hexString: String { data.hexString() }
}
