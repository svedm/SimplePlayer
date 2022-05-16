//
//  DIDLLite.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation
import XMLCoder

public struct DIDLLite: Decodable {
    public let containers: [Container]
    public let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case containers = "container"
        case items = "item"
    }
    
    public struct Container: Decodable, DynamicNodeDecoding {
        public var id: String
        public let title: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case title = "title"
        }
        
        public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
            switch key {
            case CodingKeys.id:
                return .attribute
            default:
                return .element
            }
        }
    }
    
    public struct Item: Decodable, DynamicNodeDecoding {
        public let id: String
        public let title: String
        public let res: [Resource]
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case title = "title"
            case res = "res"
        }
        
        public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
            switch key {
            case CodingKeys.id:
                return .attribute
            default:
                return .element
            }
        }
    }
}
