//
//  Tuple.swift
//
//  Created by Sun on 2023/3/7.
//

import BigInt
import Foundation

public enum Tuple {
    case tuple(items: [Tuple])
    case null
    case int(value: BigInt)
    case nan
    case cell(cell: Cell)
    case slice(cell: Cell)
    case builder(cell: Cell)
}
