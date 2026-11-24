// Copyright (c). Gem Wallet. All rights reserved.

import Foundation
import SwiftUI
import Style
import Localization
import Components
import Primitives

struct AcceptTermsScene: View {
    @State private var model: AcceptTermsViewModel
    
    init(model: AcceptTermsViewModel) {
        self.model = model
    }

    var body: some View {
        List {
            CalloutView(style: .header(title: model.message))
                .cleanListRow()
            
            Section {
                SafariNavigationLink(url: model.termsAndServicesURL) {
                    Text(Localized.Settings.termsOfServices)
                }
                SafariNavigationLink(url: model.privacyPolicyURL) {
                    Text(Localized.Settings.privacyPolicy)
                }
            }

            ForEach($model.items) { $item in
                Section {
                    Toggle(isOn: $item.isConfirmed) {
                        Text(item.message)
                            .textStyle(item.style)
                    }
                    .accessibilityIdentifier(item.id)
                    .toggleStyle(CheckboxStyle(position: .left))
                }
            }
        }
        .safeAreaView {
            StateButton(
                text: Localized.Onboarding.AcceptTerms.continue,
                type: .primary(model.state),
                action: model.onAccept
            )
            .frame(maxWidth: .scene.button.maxWidth)
            .padding(.bottom, .scene.bottom)
        }
        .contentMargins([.top], .extraSmall, for: .scrollContent)
        .listSectionSpacing(.custom(.medium))
        .navigationTitle(model.title)
        .toolbarTitleDisplayMode(.inline)
    }
}
