// Copyright (c). Gem Wallet. All rights reserved.

import Foundation
import SwiftUI
import Style
import Components
import Localization
import Primitives

struct SecurityReminderScene: View {
    @State private var model: SecurityReminderViewModel
    @State private var isAcknowledged = false
    
    init(model: SecurityReminderViewModel) {
        self.model = model
    }
    
    var body: some View {
        List {
            CalloutView(style: .header(title: model.message))
                .cleanListRow()

            ForEach(model.items) { item in
                Section {
                    ListItemView(
                        title: TextValue(text: item.title, style: .whiteText),
                        titleExtra: TextValue(text: item.subtitle, style: .whiteText),
                        imageStyle: item.image
                    )
                }
                .listRowBackground(Color.clear)
            }

            Section {
                Toggle(isOn: $isAcknowledged) {
                    Text(model.checkmarkTitle)
                        .foregroundStyle(.white)
                }
                .accessibilityIdentifier("securityAcknowledgment")
                .toggleStyle(CheckboxStyle(position: .left))
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .background {
            Image("splashscreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .safeAreaView {
            PrimaryGradientButton(title: model.buttonTitle, isDisabled: !isAcknowledged) {
                guard isAcknowledged else { return }
                model.onNext()
            }
            .padding(.horizontal, Spacing.medium)
            .frame(maxWidth: .scene.button.maxWidth)
            .padding(.bottom, .scene.bottom)
        }
        .contentMargins([.top], .extraSmall, for: .scrollContent)
        .listSectionSpacing(.custom(.medium))
        .navigationTitle(model.title)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    SecurityReminderScene(
        model: SecurityReminderViewModelDefault(
            title: Localized.Wallet.New.title,
            onNext: {}
        )
    )
}
