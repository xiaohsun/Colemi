import XCTest
@testable import Colemi

final class AchievementVerificationServiceTests: XCTestCase {
    func test_verifyAchievement_returnsVerified_whenHasAchievementReturnsTrue() async {
        let transport = StubAchievementRPCTransport(
            responses: [
                .success(StubPayload.result("0x" + String(repeating: "0", count: 63) + "1"))
            ]
        )
        let service = AchievementVerificationService(
            config: .demo,
            transport: transport
        )

        let result = await service.verifyAchievement()

        XCTAssertEqual(result.state, .verified)
        XCTAssertEqual(transport.requestCount, 1)
    }

    func test_verifyAchievement_returnsLocked_whenHasAchievementReturnsFalse() async {
        let transport = StubAchievementRPCTransport(
            responses: [
                .success(StubPayload.result("0x" + String(repeating: "0", count: 64)))
            ]
        )
        let service = AchievementVerificationService(
            config: .demo,
            transport: transport
        )

        let result = await service.verifyAchievement()

        XCTAssertEqual(result.state, .locked)
        XCTAssertEqual(transport.requestCount, 1)
        XCTAssertNotNil(result.lastCheckedAt)
    }

    func test_verifyAchievement_fallsBackToBalanceOf_whenHasAchievementCannotBeDecoded() async {
        let transport = StubAchievementRPCTransport(
            responses: [
                .success(StubPayload.result("0x")),
                .success(StubPayload.result("0x" + String(repeating: "0", count: 63) + "2"))
            ]
        )
        let service = AchievementVerificationService(
            config: .demo,
            transport: transport
        )

        let result = await service.verifyAchievement()

        XCTAssertEqual(result.state, .verified)
        XCTAssertEqual(transport.requestCount, 2)
    }

    func test_verifyAchievement_returnsUnavailable_whenRpcFails() async {
        let transport = StubAchievementRPCTransport(
            responses: [
                .failure(StubError.transport)
            ]
        )
        let service = AchievementVerificationService(
            config: .demo,
            transport: transport
        )

        let result = await service.verifyAchievement()

        XCTAssertEqual(result.state, .unavailable)
        XCTAssertEqual(transport.requestCount, 1)
        XCTAssertNotNil(result.lastCheckedAt)
    }
}

private final class StubAchievementRPCTransport: AchievementRPCTransport {
    private(set) var requestCount: Int = 0
    private var responses: [Result<Data, Error>]

    init(responses: [Result<Data, Error>]) {
        self.responses = responses
    }

    func send(requestBody: Data, to url: URL) async throws -> Data {
        requestCount += 1
        return try responses.removeFirst().get()
    }
}

private enum StubPayload {
    static func result(_ hex: String) -> Data {
        """
        {"jsonrpc":"2.0","id":1,"result":"\(hex)"}
        """.data(using: .utf8)!
    }
}

private enum StubError: Error {
    case transport
}
