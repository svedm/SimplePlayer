//
//  Resource.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation
import XMLCoder

public class Resource: Decodable, DynamicNodeDecoding {
    public let protocolInfo: String
    public let value: String
    
    public var kind: Kind? {
        Kind(string: protocolInfo)
    }

    public enum Kind {
        case video
        case audio
        case image
        
        init?(string: String) {
            if string.contains("video") {
                self = .video
            } else if string.contains("audio") {
                self = .audio
            } else if string.contains("image") {
                self = .image
            } else {
                return nil
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case protocolInfo = "protocolInfo"
        case value = ""
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.protocolInfo:
            return .attribute
        default:
            return .element
        }
    }
}
