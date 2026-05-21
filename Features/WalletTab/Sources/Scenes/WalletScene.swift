// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Components
import Primitives
import Store
import Style
import InfoSheet
import PrimitivesComponents
import Localization
import Components
public struct WalletScene: View {
    private var model: WalletSceneViewModel

    public init(model: WalletSceneViewModel) {
        self.model = model
    }

    public var body: some View {
        @Bindable var preferences = model.observablePreferences

        ZStack {
        
            BackGroundView()

           
            List {
                Section { } header: {
                    WalletHeaderView(
                      
                        model: model.walletHeaderModel,
                        isHideBalanceEnalbed: $preferences.isHideBalanceEnabled,
                        onHeaderAction: model.onHeaderAction,
                        onInfoAction: model.onSelectWatchWalletInfo,
                        showTwoButton: true,
                    )
                    .padding(.top, 100)
                }
                .cleanListRow()

                Section {
                    Button(action: model.onSelectManage) {
                        HStack(spacing: 6) {
                            Images.System.plus
                            
                            Text("Add Coin")
                                .foregroundColor(Colors.black)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, .small)
                    }
                    .buttonStyle(.borderless)
                    .tint(.green)
                    
                }
                .listRowBackground(Colors.listStyleColor)
                .cleanListRow()

                if model.showPerpetuals {
                    Section {
                        PerpetualsPreviewView(wallet: model.wallet)
                    } header: {
                        HeaderNavigationLinkView(
                            title: model.perpetualsTitle,
                            destination: Scenes.Perpetuals()
                        )
                    }
                }

                if let banner = model.walletBannersModel.allBanners.first {
                    Section {
                        BannerView(
                            banner: banner,
                            action: model.onBanner
                        )
                    }
                    .listRowInsets(.zero)
                }

                if model.showPinnedSection {
                    Section {
                        WalletAssetsList(
                            assets: model.sections.pinned,
                            currencyCode: model.currencyCode,
                            onHideAsset: model.onHideAsset,
                            onPinAsset: model.onPinAsset,
                            onCopyAddress: model.onCopyAddress,
                            showBalancePrivacy: $preferences.isHideBalanceEnabled
                        )
                        .listRowInsets(.assetListRowInsets).cleanListRow()
                    } header: {
                        HStack {
                            model.pinImage
                            Text(model.pinnedTitle)
                        }
                    }
                }

                Section {
                    HStack {
                        Spacer()
                        Button(action: model.onSelectManage) {
                            Images.System.plus
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 40, height: 40)
                        .background(Colors.green)
                        .cornerRadius(12)
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, .small)
                }
                .listRowBackground(Colors.listStyleColor)
                .cleanListRow()

                Section {
                    WalletAssetsList(
                        assets: model.sections.assets,
                        currencyCode: model.currencyCode,
                        onHideAsset: model.onHideAsset,
                        onPinAsset: model.onPinAsset,
                        onCopyAddress: model.onCopyAddress,
                        showBalancePrivacy: $preferences.isHideBalanceEnabled
                    )
                    .listRowInsets(.assetListRowInsets) .background(Color.clear).cleanListRow()
                }
//                footer: {
//                    ListButton(
//                        title: model.manageTokenTitle,
//                        image: model.manageImage,
//                        action: model.onSelectManage
//                    )
//                    .padding(.medium)
//                    .frame(maxWidth: .infinity)
//                }
            }.padding(.bottom, 100)
                .ignoresSafeArea(.keyboard)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            
        }
        .refreshable {
            model.fetch()
        }
        .taskOnce {
            model.fetch()
        }
    }
}

