// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Components
import Style

public struct SecurityScene: View {
    @State private var model: SecurityViewModel

    public init(model: SecurityViewModel) {
        self.model = model
    }

    public var body: some View {
        ZStack {
            BackGroundView()
       
        List {
            Section {
                Toggle(model.authenticationTitle, isOn: $model.isEnabled)
                    .toggleStyle(AppToggleStyle()).textStyle(.whiteText)

                if model.isEnabled {
                    Picker(model.lockPeriodTitle, selection: $model.lockPeriod) {
                        ForEach(model.allLockPeriods) {
                            Text($0.title).textStyle(.whiteText)
                        }
                    }
                    .pickerStyle(.menu)

                    Toggle(model.privacyLockTitle, isOn: $model.isPrivacyLockEnabled)
                        .toggleStyle(AppToggleStyle()).textStyle(.whiteText)
                }
            } footer: {
                Text(model.authenticationFooter).textStyle(.whiteText)
            }.listRowBackground(Color.clear)

            Section {
                Toggle(model.hideBalanceTitle, isOn: $model.isHideBalanceEnabled)
                    .toggleStyle(AppToggleStyle()).textStyle(.whiteText)
            }.listRowBackground(Color.clear)
        }.padding(.top,100)
                .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
        .contentMargins(.top, .scene.top, for: .scrollContent)
        .onChange(of: model.isEnabled, onToggleBiometrics)
        .onChange(of: model.isPrivacyLockEnabled, onToggleSecurityLock)
        .alertSheet($model.isPresentingAlertMessage)
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    }
}

// MARK: - Actions

extension SecurityScene {
    private func onToggleBiometrics() {
        Task {
            await model.toggleBiometrics()
        }
    }

    private func onToggleSecurityLock() {
        model.togglePrivacyLock()
    }
}

#Preview {
    SecurityScene(model: .init())
}
