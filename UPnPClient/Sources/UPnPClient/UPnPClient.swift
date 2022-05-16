import Foundation

public protocol UPnPClient {
    func discoverDevices(timeout: Int) async throws -> [DeviceDescription]
    func getContentDirectory(url: URL) async throws -> ContentDirectory
    func browse(url: URL, serviceVersion: Int, objectID: String) async throws -> DIDLLite
}
