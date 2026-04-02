import Foundation

struct AchievementVerificationConfig {
    let rpcURL: URL
    let contractAddress: String
    let demoWalletAddress: String
    let badgeName: String
    let chainName: String

    static let demo = AchievementVerificationConfig(
        rpcURL: URL(string: "https://ethereum-sepolia-rpc.publicnode.com")!,
        contractAddress: "0x6BC8C77525F41B0A9F786c9a45477F799995adaC",
        demoWalletAddress: "0x7A12bfaF17Ce2FDbCD2053b0C0cC9Bf920690E0c",
        badgeName: "SugarSwap Badge",
        chainName: "Sepolia"
    )
}
