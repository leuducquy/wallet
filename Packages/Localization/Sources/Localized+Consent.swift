// Copyright (c). Gem Wallet. All rights reserved.

import Foundation

public extension Localized {
    enum Consent {
        public static let policies = text("consent.policies", fallback: "I have read and agree to the Terms of Service and Privacy Policy.")
        public static let acceptAndConfirm = text("consent.accept_and_confirm", fallback: "Accept and Confirm")
        public static let swapTitle = text("consent.swap.title", fallback: "Swap Risks")
        public static let swapMessage = text(
            "consent.swap.message",
            fallback: "The amount you receive can change within your slippage limit. Network fees may apply even if the swap fails. Review the minimum received and fees before you confirm. Completed swaps cannot be reversed."
        )
        public static let stakeTitle = text("consent.stake.title", fallback: "Staking Risks")
        public static let stakeMessage = text(
            "consent.stake.message",
            fallback: "Staking can lock your assets, and unstaking may require a waiting period. Rewards can change, and some networks penalize validator misbehavior by reducing staked funds. Review the action and network fee before you confirm."
        )

        private static func text(_ key: String, fallback: String) -> String {
            Bundle.module.localizedString(forKey: key, value: fallback, table: nil)
        }
    }
}
