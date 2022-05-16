//
//  ResponseDecoder.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation

protocol ResponseDecoder {
    func decode<T: Decodable>(data: Data) throws -> T
}
