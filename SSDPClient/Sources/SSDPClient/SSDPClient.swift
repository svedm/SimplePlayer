public protocol SSDPClient {
    func discover() async throws -> [SSDPSearchResponse]
}
