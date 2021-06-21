public protocol SSDPClient {
    /// Discover services
    /// - Parameters:
    ///   - target: Search target
    ///   - timeout: timeout in seconds
    /// - Returns: Array of search results
    func discover(target: SSDPSearchTarget, timeout: Int) async throws -> [SSDPSearchResponse]
}

public extension SSDPClient {
    func discover(target: SSDPSearchTarget = .all, timeout: Int = 5) async throws -> [SSDPSearchResponse] {
        try await discover(target: target, timeout: timeout)
    }
}
