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
        XCTAssertEqual(transport.requests.count, 1)
        XCTAssertEqual(transport.requests.first?.url, service.config.rpcURL)
        XCTAssertTrue(transport.requests.first?.bodyString.contains("eth_call") == true)
        XCTAssertTrue(transport.requests.first?.bodyString.contains(service.config.contractAddress) == true)
        XCTAssertTrue(transport.requests.first?.bodyString.contains("0x0fb0764d") == true)
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
        XCTAssertEqual(transport.requests.count, 1)
        XCTAssertEqual(transport.requests.first?.url, service.config.rpcURL)
        XCTAssertTrue(transport.requests.first?.bodyString.contains("0x0fb0764d") == true)
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
        XCTAssertEqual(transport.requests.count, 2)
        XCTAssertEqual(transport.requestURLs, [service.config.rpcURL, service.config.rpcURL])
        XCTAssertTrue(transport.requests.first?.bodyString.contains("0x0fb0764d") == true)
        XCTAssertTrue(transport.requests.dropFirst().first?.bodyString.contains("0x70a08231") == true)
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
        XCTAssertEqual(transport.requests.count, 1)
        XCTAssertEqual(transport.requests.first?.url, service.config.rpcURL)
        XCTAssertNotNil(result.lastCheckedAt)
    }
}

private final class StubAchievementRPCTransport: AchievementRPCTransport {
    struct RecordedRequest {
        let body: Data
        let url: URL

        var bodyString: String {
            String(decoding: body, as: UTF8.self)
        }
    }

    private(set) var requests: [RecordedRequest] = []
    private var responses: [Result<Data, Error>]

    init(responses: [Result<Data, Error>]) {
        self.responses = responses
    }

    func send(requestBody: Data, to url: URL) async throws -> Data {
        requests.append(RecordedRequest(body: requestBody, url: url))
        guard !responses.isEmpty else {
            throw StubError.unexpectedRequest(callIndex: requests.count)
        }
        return try responses.removeFirst().get()
    }

    var requestURLs: [URL] {
        requests.map(\.url)
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
    case unexpectedRequest(callIndex: Int)
}
