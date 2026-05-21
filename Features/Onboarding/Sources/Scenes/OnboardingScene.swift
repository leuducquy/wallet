// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Style
import Components

public struct OnboardingScene: OverlayView {
   
    
    private let model: OnboardingViewModel

    public init(model: OnboardingViewModel) {
        self.model = model
    }

    public var content: some View {
        ZStack {
            // Background
//            Image("splashscreen")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack(alignment: .center, spacing: 24) {
                  
                    PrimaryGradientButton(title:  model.createWalletTitle, isDisabled: false) {
                        model.onCreateWallet()
                    }
                    .padding(.horizontal, 10)

                    
//                    StateButton(
//                        text: model.createWalletTitle,
//                        action: model.onCreateWallet,
//                      
//                        
//                    )
                    PrimaryGradientButton(title:  model.importWalletTitle, isDisabled: false) {
                        model.onImportWallet()
                    }
                    .padding(.horizontal, 10)
                   
                }
                .frame(maxWidth: .scene.button.maxWidth)
                .padding(.scene.bottom * 6)
            }
            
            .frame(maxWidth: .infinity)
            
            .navigationTitle(model.title)
        }.overlay(
            LogoView()
        )
    }
}
