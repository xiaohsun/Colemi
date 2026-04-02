import Foundation

protocol AchievementRPCTransport {
    func send(requestBody: Data, to url: URL) async throws -> Data
}

struct URLSessionAchievementRPCTransport: AchievementRPCTransport {
    func send(requestBody: Data, to url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AchievementVerificationError.invalidHTTPResponse
        }

        return data
    }
}

enum AchievementVerificationError: Error {
    case invalidHTTPResponse
    case invalidAddress
    case rpcError
    case invalidResult
}

final class AchievementVerificationService {
    private let config: AchievementVerificationConfig
    private let transport: AchievementRPCTransport

    init(
        config: AchievementVerificationConfig = .demo,
        transport: AchievementRPCTransport = URLSessionAchievementRPCTransport()
    ) {
        self.config = config
        self.transport = transport
    }

    func verifyAchievement() async -> AchievementVerificationResult {
        let checkedAt = Date()

        do {
            if let hasAchievement = try await fetchHasAchievement() {
                return hasAchievement
                    ? .verified(config: config, checkedAt: checkedAt)
                    : .locked(config: config, checkedAt: checkedAt)
            }
        } catch AchievementVerificationError.rpcError {
            do {
                let hasBalance = try await fetchBalanceOf()
                return hasBalance
                    ? .verified(config: config, checkedAt: checkedAt)
                    : .locked(config: config, checkedAt: checkedAt)
            } catch {
                return .unavailable(config: config, checkedAt: checkedAt)
            }
        } catch {
            return .unavailable(config: config, checkedAt: checkedAt)
        }

        do {
            let hasBalance = try await fetchBalanceOf()
            return hasBalance
                ? .verified(config: config, checkedAt: checkedAt)
                : .locked(config: config, checkedAt: checkedAt)
        } catch {
            return .unavailable(config: config, checkedAt: checkedAt)
        }
    }

    private func fetchHasAchievement() async throws -> Bool? {
        let result = try await call(selector: "0x0fb0764d")
        guard let result else {
            return nil
        }

        return decodeBoolWord(result)
    }

    private func fetchBalanceOf() async throws -> Bool {
        let result = try await call(selector: "0x70a08231")
        guard let result else {
            throw AchievementVerificationError.invalidResult
        }

        return try decodeBalanceWord(result)
    }

    private func call(selector: String) async throws -> String? {
        let encodedWalletAddress = try encodedWalletAddress(config.demoWalletAddress)
        let payload = JSONRPCRequest(
            jsonrpc: "2.0",
            id: 1,
            method: "eth_call",
            params: [
                .call(
                    to: config.contractAddress,
                    data: selector + encodedWalletAddress
                ),
                .tag("latest")
            ]
        )

        let requestBody = try JSONEncoder().encode(payload)
        let data = try await transport.send(requestBody: requestBody, to: config.rpcURL)
        let response = try JSONDecoder().decode(JSONRPCResponse.self, from: data)

        if response.error != nil {
            throw AchievementVerificationError.rpcError
        }

        return response.result
    }

    private func encodedWalletAddress(_ address: String) throws -> String {
        let normalizedAddress = address
            .replacingOccurrences(of: "0x", with: "")
            .lowercased()

        guard normalizedAddress.count == 40, normalizedAddress.allSatisfy(\.isHexDigit) else {
            throw AchievementVerificationError.invalidAddress
        }

        return String(repeating: "0", count: 24) + normalizedAddress
    }

    private func decodeBoolWord(_ hex: String) -> Bool? {
        let cleanedHex = hex.replacingOccurrences(of: "0x", with: "").lowercased()
        guard cleanedHex.count == 64 else {
            return nil
        }

        if cleanedHex == String(repeating: "0", count: 64) {
            return false
        }

        if cleanedHex == String(repeating: "0", count: 63) + "1" {
            return true
        }

        return nil
    }

    private func decodeBalanceWord(_ hex: String) throws -> Bool {
        let cleanedHex = hex.replacingOccurrences(of: "0x", with: "").lowercased()
        guard cleanedHex.count == 64, cleanedHex.allSatisfy(\.isHexDigit) else {
            throw AchievementVerificationError.invalidResult
        }

        return cleanedHex.contains(where: { $0 != "0" })
    }
}

private struct JSONRPCRequest: Encodable {
    let jsonrpc: String
    let id: Int
    let method: String
    let params: [JSONRPCParam]
}

private enum JSONRPCParam: Encodable {
    case call(to: String, data: String)
    case tag(String)

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .call(to, data):
            try container.encode(["to": to, "data": data])
        case let .tag(tag):
            try container.encode(tag)
        }
    }
}

private struct JSONRPCResponse: Decodable {
    let result: String?
    let error: JSONRPCResponseError?
}

private struct JSONRPCResponseError: Decodable {
    let code: Int
    let message: String
}
