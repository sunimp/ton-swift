//
//  Integers.swift
//
//  Created by Sun on 2023/3/28.
//

import BigInt
import Foundation

/// All APIs that take bit as a parameter or return a bit are expressed using typealias `Bit` based on `Int`.
/// An API that produces `Bit` guarantees that it is in range `[0,1]`.
public typealias Bit = Int

// MARK: - Unary

/// Represents unary integer encoding: `0` for 0, `10` for 1, `110` for 2, `1{n}0` for n.
public struct Unary: CellCodable {
    // MARK: Properties

    public let value: Int

    // MARK: Lifecycle

    init(_ v: Int) {
        value = v
    }

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> Self {
        var v = 0
        while try slice.loadBit() == 1 {
            v += 1
        }
        return Unary(v)
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(bit: 1, repeat: value)
        try builder.store(bit: 0)
    }
}

// MARK: - Bool + CellCodable, StaticSize

extension Bool: CellCodable, StaticSize {
    public static var bitWidth = 1
        
    public func storeTo(builder: Builder) throws {
        try builder.store(bit: self)
    }
    
    public static func loadFrom(slice: Slice) throws -> Self {
        try slice.loadBoolean()
    }
}

// MARK: - UInt256

/// 256-bit unsigned integer
public struct UInt256: Hashable, CellCodable, StaticSize {
    // MARK: Static Properties

    public static var bitWidth = 256

    // MARK: Properties

    public var value: BigUInt

    // MARK: Lifecycle

    init(biguint: BigUInt) {
        value = biguint
    }

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(biguint: slice.loadUintBig(bits: bitWidth))
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(uint: value, bits: Self.bitWidth)
    }
}

// MARK: - UInt8 + CellCodable, StaticSize

// Unsigned short integers

extension UInt8: CellCodable, StaticSize {
    public static var bitWidth = 8
    
    public func storeTo(builder: Builder) throws {
        try builder.store(uint: self, bits: Self.bitWidth)
    }
    
    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(slice.loadUint(bits: bitWidth))
    }
}

// MARK: - UInt16 + CellCodable, StaticSize

extension UInt16: CellCodable, StaticSize {
    public static var bitWidth = 16
    
    public func storeTo(builder: Builder) throws {
        try builder.store(uint: self, bits: Self.bitWidth)
    }
    
    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(slice.loadUint(bits: bitWidth))
    }
}

// MARK: - UInt32 + CellCodable, StaticSize

extension UInt32: CellCodable, StaticSize {
    public static var bitWidth = 32
    
    public func storeTo(builder: Builder) throws {
        try builder.store(uint: self, bits: Self.bitWidth)
    }
    
    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(slice.loadUint(bits: bitWidth))
    }
}

// MARK: - UInt64 + CellCodable, StaticSize

extension UInt64: CellCodable, StaticSize {
    public static var bitWidth = 64
    
    public func storeTo(builder: Builder) throws {
        try builder.store(uint: self, bits: Self.bitWidth)
    }
    
    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(slice.loadUint(bits: bitWidth))
    }
}

// MARK: - Int8 + CellCodable, StaticSize

// Signed short integers

extension Int8: CellCodable, StaticSize {
    public static var bitWidth = 8
    
    public func storeTo(builder: Builder) throws {
        try builder.store(int: self, bits: Self.bitWidth)
    }
    
    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(slice.loadInt(bits: bitWidth))
    }
}

// MARK: - Int16 + CellCodable, StaticSize

extension Int16: CellCodable, StaticSize {
    public static var bitWidth = 16
    
    public func storeTo(builder: Builder) throws {
        try builder.store(int: self, bits: Self.bitWidth)
    }
    
    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(slice.loadInt(bits: bitWidth))
    }
}

// MARK: - Int32 + CellCodable, StaticSize

extension Int32: CellCodable, StaticSize {
    public static var bitWidth = 32
    
    public func storeTo(builder: Builder) throws {
        try builder.store(int: self, bits: Self.bitWidth)
    }
    
    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(slice.loadInt(bits: bitWidth))
    }
}

// MARK: - Int64 + CellCodable, StaticSize

extension Int64: CellCodable, StaticSize {
    public static var bitWidth = 64
    
    public func storeTo(builder: Builder) throws {
        try builder.store(int: self, bits: Self.bitWidth)
    }
    
    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(slice.loadInt(bits: bitWidth))
    }
}

// MARK: - VarUInt248

//
// Dynamically-sized integers
//

/// Up-to-31-byte (248-bit) unsigned integer (5-bit length prefix)
public struct VarUInt248: Hashable, CellCodable {
    // MARK: Properties

    public var value: BigUInt

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(value: slice.loadVarUintBig(limit: 32))
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(varuint: value, limit: 32)
    }
}

// MARK: - VarUInt120

/// Up-to-15-byte (120-bit) unsigned integer (4-bit length prefix)
public struct VarUInt120: Hashable, CellCodable {
    // MARK: Properties

    public var value: BigUInt

    // MARK: Static Functions

    public static func loadFrom(slice: Slice) throws -> Self {
        try Self(value: slice.loadVarUintBig(limit: 16))
    }

    // MARK: Functions

    public func storeTo(builder: Builder) throws {
        try builder.store(varuint: value, limit: 16)
    }
}

// MARK: - IntCoder

public struct IntCoder: TypeCoder {
    // MARK: Nested Types

    public typealias T = BigInt

    // MARK: Properties

    public let bits: Int

    // MARK: Lifecycle

    public init(bits: Int) {
        self.bits = bits
    }

    // MARK: Functions

    public func storeValue(_ src: T, to builder: Builder) throws {
        try builder.store(int: src, bits: bits)
    }
    
    public func loadValue(from src: Slice) throws -> T {
        try src.loadIntBig(bits: bits)
    }
}

// MARK: - UIntCoder

public struct UIntCoder: TypeCoder {
    // MARK: Nested Types

    public typealias T = BigUInt

    // MARK: Properties

    public let bits: Int

    // MARK: Lifecycle

    public init(bits: Int) {
        self.bits = bits
    }

    // MARK: Functions

    public func storeValue(_ src: T, to builder: Builder) throws {
        try builder.store(uint: src, bits: bits)
    }
    
    public func loadValue(from src: Slice) throws -> T {
        try src.loadUintBig(bits: bits)
    }
}

// MARK: - VarUIntCoder

/// Encodes variable-length integers using `limit` bound on integer size in _bytes_.
/// Therefore, `VarUIntCoder(32)` can represent 248-bit integers (lengths 0...31 bytes).
/// TL-B:
/// ```
/// var_uint$_ {n:#} len:(#< n) value:(uint (len * 8)) = VarUInteger n;
/// var_int$_  {n:#} len:(#< n) value:(int (len * 8))  = VarInteger n;
/// ```
public struct VarUIntCoder: TypeCoder {
    // MARK: Nested Types

    public typealias T = BigUInt

    // MARK: Properties

    public let limit: Int

    // MARK: Lifecycle

    public init(limit: Int) {
        self.limit = limit
    }

    // MARK: Functions

    public func storeValue(_ src: T, to builder: Builder) throws {
        try builder.store(varuint: src, limit: limit)
    }
    
    public func loadValue(from src: Slice) throws -> T {
        try src.loadVarUintBig(limit: limit)
    }
}
