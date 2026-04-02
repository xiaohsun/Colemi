import XCTest
@testable import Colemi

final class AchievementVerificationServiceTests: XCTestCase {
    func test_verifyAchievement_returnsVerified_whenHasAchievementReturnsTrue() async {
        let config = makeCustomConfig()
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
        XCTAssertNotNil(result.lastCheckedAt)
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
        XCTAssertNotNil(result.lastCheckedAt)
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

    func test_verifyAchievement_returnsLocked_whenBalanceOfReturnsZero_afterHasAchievementCannotBeDecoded() async {
        let config = AchievementVerificationConfig.demo
        let transport = StubAchievementRPCTransport(
            responses: [
                .success(StubPayload.result("0x")),
                .success(StubPayload.result("0x" + String(repeating: "0", count: 64)))
            ]
        )
        let service = AchievementVerificationService(
            config: config,
            transport: transport
        )

        let result = await service.verifyAchievement()

        XCTAssertEqual(result.state, .locked)
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
        assertRequest(
            transport.requests.first,
            matches: config,
            selector: "0x0fb0764d"
        )
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
    XCTAssertEqual(decoded?.call.to, config.contractAddress, file: file, line: line)
    XCTAssertEqual(decoded?.blockTag, "latest", file: file, line: line)
    XCTAssertEqual(
        decoded?.call.data,
        expectedFullCalldata(selector: selector, config: config),
        file: file,
        line: line
    )
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
    let call: Call
    let blockTag: String

    private enum CodingKeys: String, CodingKey {
        case method
        case params
    }

    struct Call: Decodable {
        let to: String
        let data: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        method = try container.decode(String.self, forKey: .method)

        var params = try container.nestedUnkeyedContainer(forKey: .params)
        call = try params.decode(Call.self)
        blockTag = try params.decode(String.self)
    }
}

private func expectedFullCalldata(
    selector: String,
    config: AchievementVerificationConfig
) -> String {
    let normalizedWalletAddress = config.demoWalletAddress
        .lowercased()
        .replacingOccurrences(of: "0x", with: "")
    return selector + String(repeating: "0", count: 24) + normalizedWalletAddress
}

private func makeCustomConfig() -> AchievementVerificationConfig {
    AchievementVerificationConfig(
        rpcURL: URL(string: "https://rpc.example.test")!,
        contractAddress: "0x1234567890ABCDEF1234567890ABCDEF12345678",
        demoWalletAddress: "0xAbCdEf0123456789ABCDEF0123456789ABCDEF01"
    )
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
