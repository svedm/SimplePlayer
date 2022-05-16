//
//  BaseUPnPClient.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation
import SSDPClient

public class BaseUPnPClient: UPnPClient {
    private let ssdpClient: SSDPClient = NIOSSDPClient()
    private let decoder = XMLDecoder()
    private lazy var httpClient: NetworkClient = HTTPNetworkClient(decoder: decoder)
    
    public enum Error: Swift.Error {
        case encoding
        case decoding
    }
    
    public init() {
    }
    
    /// Discover UPnP devices
    /// - Parameter timeout: search timeout in second, default value: 3
    public func discoverDevices(timeout: Int) async throws -> [DeviceDescription] {
        let ssdpDevices = try await ssdpClient.discover(target: .rootDevice, timeout: timeout)
        return try await withThrowingTaskGroup(of: DeviceDescription.self) { group in
            for url in ssdpDevices.map({ $0.location }) {
                group.addTask {
                    var device: DeviceDescription = try await self.httpClient.get(url: url)
                    if device.urlBase == nil {
                        device.urlBase = Self.makeBaseURL(from: url)
                    }
                    return device
                }
            }
            
            var result: [DeviceDescription] = []
            for try await device in group {
                result.append(device)
            }
            
            return result
        }
    }
    
    public func getContentDirectory(url: URL) async throws -> ContentDirectory {
        try await httpClient.get(url: url)
    }
    
    public func browse(url: URL, serviceVersion: Int, objectID: String) async throws -> DIDLLite {
        let requestXML = """
            <?xml version="1.0"?>
            <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
              <s:Body>
                <u:Browse xmlns:u="urn:schemas-upnp-org:service:ContentDirectory:\(serviceVersion)">
                  <ObjectID>\(objectID)</ObjectID>
                  <BrowseFlag>BrowseDirectChildren</BrowseFlag>
                  <Filter>*</Filter>
                  <StartingIndex>0</StartingIndex>
                  <RequestedCount>0</RequestedCount>
                  <SortCriteria></SortCriteria>
                </u:Browse>
              </s:Body>
            </s:Envelope>
            """
        let headers = [
            "SOAPACTION": "urn:schemas-upnp-org:service:ContentDirectory:\(serviceVersion)#Browse",
            "Content-Type": "text/xml; charset=utf-8"
        ]
        
        guard let data = requestXML.data(using: .utf8) else { throw Error.encoding }
        
        let result: Envelope = try await httpClient.post(url: url, data: data, headers: headers)

        guard let xmlData = result.body.browseResponse.result.data(using: .utf8) else { throw Error.decoding }
        let didl: DIDLLite = try decoder.decode(data: xmlData)
        
        return didl
    }
    
    private static func makeBaseURL(from url: URL) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.path = ""
        return components?.url
    }
}
