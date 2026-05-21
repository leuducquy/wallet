// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Style
import Components
import Primitives
import PrimitivesComponents
import struct Staking.StakeValidatorViewModel
import struct Staking.ValidatorView
import Foundation
struct AmountScene: View {
    @FocusState private var focusedField: Bool
    @State private var keyboardHeight: CGFloat = 0
   
    private var model: AmountSceneViewModel

    public init(model: AmountSceneViewModel) {
        self.model = model
    }
   
    var body: some View {
        @Bindable var model = model
        ZStack {
            BackGroundView().ignoresSafeArea()
        
        List {
            CurrencyInputValidationView(
                model: $model.amountInputModel,
                config: model.inputConfig,
                infoAction: model.infoAction(for:)
            ).listRowBackground(Color.clear)
            .padding(.top, .medium)
            .listGroupRowStyle()
            .disabled(model.isInputDisabled)
            .focused($focusedField)

            if model.isBalanceViewEnabled {
                Section {
                    AssetBalanceView(
                        image: model.assetImage,
                        title: model.assetName,
                        balance: model.balanceText,
                        secondary: {
                            Button(action: model.onSelectMaxButton) {
                                Text(model.maxTitle)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white) 
                            }
                            .buttonStyle(
                                .listEmpty(
                                    paddingHorizontal: .medium,
                                    paddingVertical: .small
                                )
                            )
                            .fixedSize()
                        }
                    )
                }.listRowBackground(Color.clear)
            }

            if let infoText = model.infoText {
                Section {
                    Button(action: model.onSelectReservedFeesInfo) {
                        HStack {
                            Images.System.info
                                .foregroundStyle(Colors.gray)
                                .frame(width: .list.image, height: .list.image)
                            Text(infoText)
                                .textStyle(.calloutSecondary)
                        }
                    }
                }.listRowBackground(Color.clear)
            }

            switch model.type {
            case .transfer, .deposit, .withdraw:
                EmptyView()
            case .stake, .stakeUnstake, .stakeRedelegate, .stakeWithdraw:
                if let viewModel = model.stakeValidatorViewModel {
                    Section(header: Text(model.validatorTitle)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .textCase(nil)         ) {
                        if model.isSelectValidatorEnabled {
                            NavigationCustomLink(
                                with: ValidatorView(model: viewModel),
                                action: model.onSelectCurrentValidator
                            )
                        } else {
                            ValidatorView(model: viewModel)
                        }
                    }.listRowBackground(Color.clear)
                }
            case .freeze:
                if model.isSelectResourceEnabled {
                    Section {
                        Picker("", selection: $model.selectedResource) {
                            ForEach(model.availableResources) { resource in
                                Text(resource.title,).tag(resource).textStyle(.whiteText)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }.listRowBackground(Color.clear)
                    .cleanListRow()
                }
            case .perpetual:
                if model.isPerpetualLeverageEnabled {
                    Section {
                        NavigationCustomLink(
                            with: ListItemView(
                                title: model.leverageTitle,
                                subtitle: model.leverageText,
                                subtitleStyle: model.leverageTextStyle
                            ),
                            action: model.onSelectLeverage
                        )
                    }.listRowBackground(Color.clear)
                }
                if model.isAutocloseEnabled {
                    Section {
                        NavigationCustomLink(
                            with: ListItemView(
                                title: model.autocloseTitle,
                                subtitle: model.autocloseText.subtitle,
                                subtitleExtra: model.autocloseText.subtitleExtra
                            ),
                            action: model.onSelectAutoclose
                        )
                    }.listRowBackground(Color.clear)
                }
            }
        }
        .safeAreaView {
            StateButton(
                text: model.continueTitle,
                type: .primary(model.actionButtonState),
                action: model.onSelectNextButton
            )
            .frame(maxWidth: .scene.button.maxWidth)
            .padding(.bottom, .scene.bottom)
        }
        .contentMargins([.top], .zero, for: .scrollContent)
        .listSectionSpacing(.custom(.medium))
        .frame(maxWidth: .infinity)
        .navigationTitle(model.title)
        .onAppear(perform: model.onAppear)
        .onChange(of: model.focusField, onChangeFocus)
        } .onReceive(
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillChangeFrameNotification
            )
        ) { notification in
            if let frame = notification
                .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {

                keyboardHeight = max(
                    0,
                    UIScreen.main.bounds.height - frame.origin.y
                )
            }
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: keyboardHeight + 150)
        }
                .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
    }
}

// MARK: - Actions

extension AmountScene {
    private func onChangeFocus(_ _: Bool, _ newField: Bool) {
        focusedField = newField
    }
}
