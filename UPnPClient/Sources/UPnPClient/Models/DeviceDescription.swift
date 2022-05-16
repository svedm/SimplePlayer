//
//  DeviceDescription.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation

public struct DeviceDescription: Decodable {
    public var urlBase: URL?
    public let device: Device
    
    enum CodingKeys: String, CodingKey {
        case urlBase = "URLBase"
        case device = "device"
    }
}
