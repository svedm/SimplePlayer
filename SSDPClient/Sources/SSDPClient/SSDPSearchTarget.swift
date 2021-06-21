//
//  SSDPSearchTarget.swift
//  SSDPClient
//
//  Created by Svetoslav on 21.06.2021.
//

public enum SSDPSearchTarget {
    case all
    case rootDevice
    case deviceUUID(String)

    var stringValue: String {
        switch self {
            case .all:
                return "ssdp:all"
            case .rootDevice:
                return "upnp:rootdevice"
            case .deviceUUID(let uuid):
                return "uuid:" + uuid
        }
    }
}
