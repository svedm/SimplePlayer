//
//  UnknownCodingKey.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation

/// Best XML decoding debug tool :(
struct UnknownCodingKey: CodingKey {
    init?(stringValue: String) { self.stringValue = stringValue }
    let stringValue: String

    init?(intValue: Int) { return nil }
    var intValue: Int? { return nil }
}
