//
//  TonError.swift
//
//  Created by Sun on 2023/1/28.
//

import Foundation

// MARK: - TonError

public enum TonError: Error, Equatable {
    case indexOutOfBounds(Int)
    case offsetOutOfBounds(Int)
    case custom(String)
    case varUIntOutOfBounds(limit: Int, actualBits: Int)
}

// MARK: CustomDebugStringConvertible

extension TonError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .indexOutOfBounds(index):
            "Index \(index) is out of bounds"
            
        case let .offsetOutOfBounds(offset):
            "Offset \(offset) is out of bounds"
        
        case let .varUIntOutOfBounds(limit, actualBits):
            "VarUInteger is out of bounds: the (VarUInt \(limit)) specifies max size \((limit - 1) * 8) bits long, but the actual number is \(actualBits) bits long"
            
        case let .custom(text):
            text
        }
    }
}
