//
//  ContractTest.swift
//
//  Created by Sun on 2023/3/3.
//

@testable import TonSwift
import XCTest

final class СontractAddressTest: XCTestCase {
    func testСontractAddress() throws {
        // should resolve address correctly
        
        let stateInit = try StateInit(
            code: Builder().store(uint: 1, bits: 8).endCell(),
            data: Builder().store(uint: 2, bits: 8).endCell()
        )
        let addr = try OpaqueContract(workchain: 0, stateInit: stateInit).address()
        XCTAssertEqual(addr, try Address.parse("EQCSY_vTjwGrlvTvkfwhinJ60T2oiwgGn3U7Tpw24kupIhHz"))
    }
}
