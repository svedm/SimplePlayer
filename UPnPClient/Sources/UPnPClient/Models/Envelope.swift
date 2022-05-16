//
//  Envelope.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation

public struct Envelope: Decodable {
    public let body: Body
    
    enum CodingKeys: String, CodingKey {
        case body = "Body"
    }
    
    public struct Body: Decodable {
        public let browseResponse: BrowseResponse
        
        enum CodingKeys: String, CodingKey {
            case browseResponse = "BrowseResponse"
        }
    }
}
