// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Style
import Components
import Localization
import Primitives

public struct WalletHeaderView: View {
    private let model: any HeaderViewModel
    private var showTwoButton : Bool = false
    @Binding var isHideBalanceEnalbed: Bool

    private let onHeaderAction: HeaderButtonAction?
    private let onInfoAction: VoidAction

    public init(
        model: any HeaderViewModel,
        isHideBalanceEnalbed: Binding<Bool>,
        onHeaderAction: HeaderButtonAction?,
        onInfoAction: VoidAction,
        showTwoButton: Bool = false
    ) {
        self.model = model
        _isHideBalanceEnalbed = isHideBalanceEnalbed
        self.onHeaderAction = onHeaderAction
        self.onInfoAction = onInfoAction
        self.showTwoButton = showTwoButton
    }

    public var body: some View {
        VStack() {
            if let assetImage = model.assetImage {
                AssetImageView(
                    assetImage: assetImage,
                    size: .image.semiLarge
                )
                .padding(.bottom, .space12)
            }
            ZStack {
                if model.allowHiddenBalance {
                    PrivacyToggleView(
                        model.title,
                        isEnabled: $isHideBalanceEnalbed
                    )
                } else {
                    Text(model.title).textStyle(.whiteText)
                }
            }
            .numericTransition(for: model.title)
            .minimumScaleFactor(0.5)
            .font(.system(size: 42))
            .fontWeight(.semibold)
            .foregroundStyle(Colors.white)
            .lineLimit(1)
            .padding(.bottom, .space10)

            if let subtitle = model.subtitle {
                PrivacyText(
                    subtitle,
                    isEnabled: isEnabled
                )
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundStyle(Colors.white)
                .numericTransition(for: model.subtitle)
                .padding(.bottom, .space10)
            }

            switch model.isWatchWallet {
            case true:
                Button {
                    onInfoAction?()
                } label: {
                    HStack {
                        Images.System.eye

                        Text(Localized.Wallet.Watch.Tooltip.title)
                            .foregroundColor(Colors.black)
                            .font(.callout).tint(Colors.white)

                        Images.System.info
                            .tint(Colors.white)
                    }
                    .padding()
                    .background(Colors.grayDarkBackground)
                    .cornerRadius(.medium)
                    .padding(.top, .space10)
                }

            case false:
                HeaderButtonsView(buttons:showTwoButton ? [model.buttons[0],model.buttons[1]] : model.buttons, action: onHeaderAction)
                    .padding(.top, .space8)
            }
        }
    }

    private var isEnabled: Binding<Bool> {
        return model.allowHiddenBalance ? $isHideBalanceEnalbed : .constant(false)
    }
}

// MARK: - Previews

#Preview {
    let model = WalletHeaderViewModel(
        walletType: .multicoin,
        value: 1_000,
        currencyCode: Currency.usd.rawValue,
        bannerEventsViewModel: HeaderBannerEventViewModel(events: [])
    )

    WalletHeaderView(
        model: model,
        isHideBalanceEnalbed: .constant(false),
        onHeaderAction: .none,
        onInfoAction: .none, showTwoButton: false
    )
}
