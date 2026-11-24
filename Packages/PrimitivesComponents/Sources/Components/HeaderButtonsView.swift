// Copyright (c). Gem Wallet. All rights reserved.

import Foundation
import SwiftUI
import Components
import Primitives
import Style

public typealias HeaderButtonAction = @MainActor @Sendable (HeaderButtonType) -> Void

public struct HeaderButtonsView: View {
    private let buttons: [HeaderButton]
    private let action: HeaderButtonAction?
    private let onManageAction: (@MainActor () -> Void)?

    var maxWidth: CGFloat {
        buttons.count + (onManageAction == nil ? 0 : 1) > 3 ? 84 : 94
    }

    public init(
        buttons: [HeaderButton],
        action: HeaderButtonAction? = nil,
        onManageAction: (@MainActor () -> Void)? = nil
    ) {
        self.buttons = buttons
        self.action = action
        self.onManageAction = onManageAction
    }

    public var body: some View {
        HStack(alignment: .center, spacing: .extraSmall) {
            ForEach(buttons) { button in
                if button.type != .buy {
                    buttonView(for: button)
                }
            }
            if let onManageAction {
                RoundButton(title: "Add Coin", image: Images.System.plus) {
                    onManageAction()
                }
                .frame(maxWidth: maxWidth)
            }
        }
    }

    @ViewBuilder
    private func buttonView(for button: HeaderButton) -> some View {
        Group {
            switch button.viewType {
            case .button:
                RoundButton(
                    title: button.title,
                    image: button.image,
                    isEnabled: button.isEnabled
                ) {
                    action?(button.type)
                }
            case let .menuButton(title, items):
                AdaptiveActionMenu(
                    title: title,
                    items: items,
                    label: {
                        RoundButton(
                            title: button.title,
                            image: button.image,
                            isEnabled: button.isEnabled,
                            action: {} // action empty, handled by menu
                        )
                    }
                )
            }
        }
        .accessibilityIdentifier(button.id)
        .frame(maxWidth: maxWidth, alignment: .center)
    }
}

// MARK: - Previews

#Preview {
    let buttons = HeaderButtonType.allCases.map({ HeaderButton(type: $0, isEnabled: true) })
    return VStack {
        Spacer()
        HeaderButtonsView(buttons: buttons, action: nil)
        Spacer()
    }
}
