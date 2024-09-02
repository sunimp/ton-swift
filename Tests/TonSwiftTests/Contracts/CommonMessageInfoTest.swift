//
//  CommonMessageInfoTest.swift
//
//  Created by Sun on 2023/3/13.
//

@testable import TonSwift
import XCTest

final class CommonMessageInfoTest: XCTestCase {
    func testCommonMessageInfo() throws {
        // should serialize external-in messages
        let msg1 = try CommonMsgInfo.externalInInfo(
            info: .init(
                src: ExternalAddress.mock(seed: "src"),
                dest: Address.mock(workchain: 0, seed: "dest"),
                importFee: Coins(0)
            )
        )
        
        let cell1 = try Builder().store(msg1).endCell()
        let msg2: CommonMsgInfo = try cell1.beginParse().loadType()
        let cell2 = try Builder().store(msg2).endCell()
        XCTAssertEqual(cell1, cell2)
    }
}
