//
//  BrowseResponse.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation

public struct BrowseResponse: Decodable {
    public let result: String
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}
