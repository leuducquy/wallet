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

