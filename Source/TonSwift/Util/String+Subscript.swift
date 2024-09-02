//
//  String+Subscript.swift
//
//  Created by Sun on 2023/2/1.
//

import Foundation

extension String {
    public subscript(_ idx: Int) -> Character {
        self[index(startIndex, offsetBy: idx)]
    }
}
