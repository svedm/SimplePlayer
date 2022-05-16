//
//  Device.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation

public struct Device: Decodable {
    public let friendlyName: String
    public let udn: String
    public let serviceList: ServiceList
    public let iconList: IconList
    
    public var bestIcon: String? {
        iconList.icons
            .sorted { $0.width > $1.width }
            .first
            .map { $0.url }
    }
    
    enum CodingKeys: String, CodingKey {
        case friendlyName = "friendlyName"
        case udn = "UDN"
        case serviceList = "serviceList"
        case iconList = "iconList"
    }
    
    public struct IconList: Decodable {
        public let icons: [Icon]
        
        enum CodingKeys: String, CodingKey {
            case icons = "icon"
        }
    }
    
    public struct Icon: Decodable {
        public let mimetype: String
        public let width: Int
        public let height: Int
        public let depth: Int
        public let url: String
    }
    
    public struct ServiceList: Decodable {
        public let services: [Service]
        
        enum CodingKeys: String, CodingKey {
            case services = "service"
        }
    }
    
    public struct Service: Decodable {
        public let serviceType: String
        public let serviceId: String
        public let controlURL: String
        public let eventSubURL: String
        public let scpdURL: String

        public var knownType: Kind? {
            Kind(rawValue: serviceId)
        }
        
        public var version: Int? {
            serviceType.split(separator: ":").last.map(String.init).flatMap(Int.init)
        }

        enum CodingKeys: String, CodingKey {
            case serviceType = "serviceType"
            case serviceId = "serviceId"
            case controlURL = "controlURL"
            case eventSubURL = "eventSubURL"
            case scpdURL = "SCPDURL"
        }

        public enum Kind: String {
            case contentDirectory = "urn:upnp-org:serviceId:ContentDirectory"
        }
    }
}
