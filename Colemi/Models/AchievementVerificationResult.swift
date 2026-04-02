import Foundation

enum AchievementVerificationState: Equatable {
    case loading
    case verified
    case locked
    case unavailable
}

struct AchievementVerificationResult: Equatable {
    let state: AchievementVerificationState
    let badgeName: String
    let chainName: String
    let contractAddress: String
    let lastCheckedAt: Date?

    static func loading(config: AchievementVerificationConfig) -> AchievementVerificationResult {
        AchievementVerificationResult(
            state: .loading,
            badgeName: config.badgeName,
            chainName: config.chainName,
            contractAddress: config.contractAddress,
            lastCheckedAt: nil
        )
    }

    static func verified(config: AchievementVerificationConfig, checkedAt: Date) -> AchievementVerificationResult {
        AchievementVerificationResult(
            state: .verified,
            badgeName: config.badgeName,
            chainName: config.chainName,
            contractAddress: config.contractAddress,
            lastCheckedAt: checkedAt
        )
    }

    static func locked(config: AchievementVerificationConfig, checkedAt: Date?) -> AchievementVerificationResult {
        AchievementVerificationResult(
            state: .locked,
            badgeName: config.badgeName,
            chainName: config.chainName,
            contractAddress: config.contractAddress,
            lastCheckedAt: checkedAt
        )
    }

    static func unavailable(config: AchievementVerificationConfig, checkedAt: Date) -> AchievementVerificationResult {
        AchievementVerificationResult(
            state: .unavailable,
            badgeName: config.badgeName,
            chainName: config.chainName,
            contractAddress: config.contractAddress,
            lastCheckedAt: checkedAt
        )
    }

    var cellStatusText: String {
        switch state {
        case .loading:
            return "Checking"
        case .verified:
            return "Verified"
        case .locked:
            return "Locked"
        case .unavailable:
            return "Unavailable"
        }
    }

    var popupStatusText: String {
        switch state {
        case .loading:
            return "Verifying on-chain..."
        case .verified:
            return "Verified On-Chain"
        case .locked:
            return "Locked"
        case .unavailable:
            return "Verification unavailable"
        }
    }

    var shortContractAddress: String {
        let prefix = contractAddress.prefix(6)
        let suffix = contractAddress.suffix(4)
        return "\(prefix)...\(suffix)"
    }

    var lastCheckedText: String {
        switch state {
        case .loading:
            return "In progress"
        case .locked where lastCheckedAt == nil:
            return "Not checked"
        default:
            guard let lastCheckedAt else {
                return "Not checked"
            }
            return Self.lastCheckedFormatter.string(from: lastCheckedAt)
        }
    }

    private static let lastCheckedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()
}
