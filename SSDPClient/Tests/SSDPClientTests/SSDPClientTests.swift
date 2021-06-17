import XCTest
@testable import SSDPClient

final class SSDPClientTests: XCTestCase {
    // illegal
    func testExample() async throws {
        let client = NIOSSDPClient()
        do {
        let result = try await client.discover()
            print(result)
            XCTAssertNotNil(result)
        } catch {
            XCTFail()
            print(error)
        }
    }
}
