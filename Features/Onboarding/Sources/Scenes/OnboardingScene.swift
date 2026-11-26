// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Style
import Components

public struct OnboardingScene: View {
    private let model: OnboardingViewModel

    public init(model: OnboardingViewModel) {
        self.model = model
    }

    public var body: some View {
        VStack {
            Spacer()

            VStack(spacing: Spacing.large) {
                PrimaryGradientButton(title: model.createWalletTitle, isDisabled: false) {
                    model.onCreateWallet()
                }

                PrimaryGradientButton(title: model.importWalletTitle, isDisabled: false) {
                    model.onImportWallet()
                }
            }
            .frame(maxWidth: .scene.button.maxWidth)
            .padding(.horizontal, Spacing.medium)
            .padding(.bottom, Spacing.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            GeometryReader { geometry in
                Image("splashscreen")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
        .overlay {
            LogoView()
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
        .navigationTitle(model.title)
    }
}
