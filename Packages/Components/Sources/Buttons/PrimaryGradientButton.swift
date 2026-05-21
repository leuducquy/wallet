// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
public extension LinearGradient {
    static let primary = LinearGradient(
        colors: [
            Color(hex: "#FF3CF0"),
            Color(hex: "#7B2CFF"),
            Color(hex: "#0014FF")
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}
public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
public struct PrimaryGradientButton: View {
    public let title: String
    public let isDisabled: Bool
    public let action: () -> Void

    public init(
        title: String,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient.primary
                        .opacity(isDisabled ? 0.4 : 1)
                )
                .clipShape(Capsule())
        }
        .disabled(isDisabled)
    }
}
