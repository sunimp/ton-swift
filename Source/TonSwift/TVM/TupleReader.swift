//
//  TupleReader.swift
//
//  Created by Sun on 2023/3/7.
//

import BigInt
import Foundation

public class TupleReader {
    // MARK: Properties

    private var items: [Tuple]

    // MARK: Computed Properties

    public var remaining: Int {
        items.count
    }

    // MARK: Lifecycle

    public init(items: [Tuple]) {
        self.items = items
    }

    // MARK: Functions

    public func peek() throws -> Tuple {
        guard !items.isEmpty else {
            throw TonError.custom("EOF")
        }
        return items[0]
    }
    
    @discardableResult
    public func pop() throws -> Tuple {
        guard !items.isEmpty else {
            throw TonError.custom("EOF")
        }
        return items.remove(at: 0)
    }
    
    public func skip(num: Int = 1) throws -> TupleReader {
        for _ in 0 ..< num {
            try pop()
        }
        return self
    }
    
    public func readBigNumber() throws -> BigInt {
        let popped = try pop()
        guard case let .int(value) = popped else {
            throw TonError.custom("Not a number")
        }
        
        return value
    }
    
    public func readBigNumberOpt() throws -> BigInt? {
        let popped = try pop()
        if case .null = popped {
            return nil
        }
        
        guard case let .int(value) = popped else {
            throw TonError.custom("Not a number")
        }
        
        return value
    }
    
    public func readNumber() throws -> UInt64 {
        try UInt64(readBigNumber())
    }
    
    public func readNumberOpt() throws -> UInt64? {
        guard let r = try readBigNumberOpt() else {
            return nil
        }
        
        return UInt64(r)
    }
    
    public func readBoolean() throws -> Bool {
        let res = try readNumber()
        return res != 0
    }
    
    public func readBooleanOpt() throws -> Bool? {
        guard let res = try readNumberOpt() else {
            return nil
        }
        
        return res != 0
    }
    
    public func readAddress() throws -> Address {
        try readCell().beginParse().loadType()
    }
    
    public func readAddressOpt() throws -> Address? {
        guard let cell = try readCellOpt() else {
            return nil
        }
        
        let a: AnyAddress = try cell.beginParse().loadType()
        return try a.asInternal()
    }
    
    public func readCell() throws -> Cell {
        let popped = try pop()
        if case let .cell(cell) = popped {
            return cell
        } else if case let .slice(cell) = popped {
            return cell
        } else if case let .builder(cell) = popped {
            return cell
        }
        
        throw TonError.custom("Not a cell: \(popped)")
    }
    
    public func readCellOpt() throws -> Cell? {
        let popped = try pop()
        if case .null = popped {
            return nil
        }
        
        if case let .cell(cell) = popped {
            return cell
        } else if case let .slice(cell) = popped {
            return cell
        } else if case let .builder(cell) = popped {
            return cell
        }
        
        throw TonError.custom("Not a cell: \(popped)")
    }
    
    public func readTuple() throws -> [Tuple] {
        let popped = try pop()
        guard case let .tuple(items) = popped else {
            throw TonError.custom("Not a tuple")
        }
        
        return items
    }
    
    public func readTupleOpt() throws -> [Tuple]? {
        let popped = try pop()
        if case .null = popped {
            return nil
        }
        
        guard case let .tuple(items) = popped else {
            throw TonError.custom("Not a tuple")
        }
        
        return items
    }
    
    public func readBuffer() throws -> Data {
        let s = try readCell().beginParse()
        if s.remainingRefs != 0 {
            throw TonError.custom("Not a buffer")
        }
        if s.remainingBits % 8 != 0 {
            throw TonError.custom("Not a buffer")
        }
        
        return try s.loadBytes(s.remainingBits / 8)
    }
    
    public func readBufferOpt() throws -> Data? {
        let popped = try peek()
        if case .null = popped {
            return nil
        }
        
        let s = try readCell().beginParse()
        if s.remainingRefs != 0 {
            throw TonError.custom("Not a buffer")
        }
        if s.remainingBits % 8 != 0 {
            throw TonError.custom("Not a buffer")
        }
        
        return try s.loadBytes(s.remainingBits / 8)
    }
    
    public func readString() throws -> String {
        let s = try readCell().beginParse()
        return try s.loadSnakeString()
    }
    
    public func readStringOpt() throws -> String? {
        let popped = try peek()
        if case .null = popped {
            return nil
        }
        
        let s = try readCell().beginParse()
        return try s.loadSnakeString()
    }
}
