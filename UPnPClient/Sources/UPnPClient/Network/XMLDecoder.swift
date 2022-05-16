//
//  XMLDecoder.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation
import XMLCoder

final class XMLDecoder: ResponseDecoder {
    private let xmlDecoder = XMLCoder.XMLDecoder()
    
    init() {
        xmlDecoder.shouldProcessNamespaces = true
    }

    func decode<T: Decodable>(data: Data) throws -> T {
        try xmlDecoder.decode(T.self, from: data)
    }
}
