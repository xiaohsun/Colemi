import XCTest
@testable import Colemi

final class AchievementVerificationServiceTests: XCTestCase {
    func test_verifyAchievement_returnsVerified_whenHasAchievementReturnsTrue() async {
        let config = AchievementVerificationConfig.demo
        let transport = StubAchievementRPCTransport(
            responses: [
                .success(StubPayload.result("0x" + String(repeating: "0", count: 63) + "1"))
            ]
        )
        let service = AchievementVerificationService(
            config: config,
            transport: transport
        )

        let result = await service.verifyAchievement()

        XCTAssertEqual(result.state, .verified)
        XCTAssertEqual(transport.requests.count, 1)
        XCTAssertEqual(transport.requests.first?.url, config.rpcURL)
        assertRequest(
            transport.requests.first,
            matches: config,
            selector: "0x0fb0764d"
        )
    }

    func test_verifyAchievement_returnsLocked_whenHasAchievementReturnsFalse() async {
        let config = AchievementVerificationConfig.demo
        let transport = StubAchievementRPCTransport(
            responses: [
                .success(StubPayload.result("0x" + String(repeating: "0", count: 64)))
            ]
        )
        let service = AchievementVerificationService(
            config: config,
            transport: transport
        )

        let result = await service.verifyAchievement()

        XCTAssertEqual(result.state, .locked)
        XCTAssertEqual(transport.requests.count, 1)
        XCTAssertEqual(transport.requests.first?.url, config.rpcURL)
        assertRequest(
            transport.requests.first,
            matches: config,
            selector: "0x0fb0764d"
        )
        XCTAssertNotNil(result.lastCheckedAt)
    }

    func test_verifyAchievement_fallsBackToBalanceOf_whenHasAchievementCannotBeDecoded() async {
        let config = AchievementVerificationConfig.demo
        let transport = StubAchievementRPCTransport(
            responses: [
                .success(StubPayload.result("0x")),
                .success(StubPayload.result("0x" + String(repeating: "0", count: 63) + "2"))
            ]
        )
        let service = AchievementVerificationService(
            config: config,
            transport: transport
        )

        let result = await service.verifyAchievement()

        XCTAssertEqual(result.state, .verified)
        XCTAssertEqual(transport.requests.count, 2)
        XCTAssertEqual(transport.requestURLs, [config.rpcURL, config.rpcURL])
        assertRequest(
            transport.requests.first,
            matches: config,
            selector: "0x0fb0764d"
        )
        assertRequest(
            transport.requests.dropFirst().first,
            matches: config,
            selector: "0x70a08231"
        )
    }

    func test_verifyAchievement_returnsUnavailable_whenRpcFails() async {
        let config = AchievementVerificationConfig.demo
        let transport = StubAchievementRPCTransport(
            responses: [
                .failure(StubError.transport)
            ]
        )
        let service = AchievementVerificationService(
            config: config,
            transport: transport
        )

        let result = await service.verifyAchievement()

        XCTAssertEqual(result.state, .unavailable)
        XCTAssertEqual(transport.requests.count, 1)
        XCTAssertEqual(transport.requests.first?.url, config.rpcURL)
        XCTAssertNotNil(result.lastCheckedAt)
    }
}

private func assertRequest(
    _ recordedRequest: StubAchievementRPCTransport.RecordedRequest?,
    matches config: AchievementVerificationConfig,
    selector: String,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    guard let recordedRequest else {
        XCTFail("Expected a recorded request", file: file, line: line)
        return
    }

    let decoded = try? JSONDecoder().decode(JSONRPCRequest.self, from: recordedRequest.body)
    XCTAssertNotNil(decoded, file: file, line: line)
    XCTAssertEqual(decoded?.method, "eth_call", file: file, line: line)
    XCTAssertEqual(decoded?.params.first?.to, config.contractAddress, file: file, line: line)
    XCTAssertTrue(decoded?.params.first?.data.hasPrefix(selector) == true, file: file, line: line)
}

private final class StubAchievementRPCTransport: AchievementRPCTransport {
    struct RecordedRequest {
        let body: Data
        let url: URL
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

private struct JSONRPCRequest: Decodable {
    let method: String
    let params: [Call]

    struct Call: Decodable {
        let to: String
        let data: String
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
