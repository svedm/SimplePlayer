import XCTest
@testable import SSDPClient

final class SSDPClientTests: XCTestCase {
    // illegal
    func testExample() async throws {
        let client: SSDPClient = NIOSSDPClient()
        do {
            let result = try await client.discover(target: .rootDevice, timeout: 5)
            print(result)
            XCTAssertNotNil(result)
        } catch {
            XCTFail(error.localizedDescription)
            print(error)
        }
    }
}
