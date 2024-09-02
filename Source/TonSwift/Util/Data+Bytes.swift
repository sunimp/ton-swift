//
//  Data+Bytes.swift
//
//  Created by Sun on 2023/3/3.
//

import Foundation

extension Data {
    var bytes: Data {
        Data(map { UInt8($0) })
    }
}
