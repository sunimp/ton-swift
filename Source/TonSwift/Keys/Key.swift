//
//  Key.swift
//
//
//  Created by Grigory on 22.6.23..
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
