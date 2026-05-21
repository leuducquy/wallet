// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Primitives
import Components
import Style
import PrimitivesComponents
import Localization

public struct AssetScene: View {
    private let model: AssetSceneViewModel

    public init(model: AssetSceneViewModel) {
        self.model = model
    }

    public var body: some View {
        ZStack {
            
          BackGroundView()
            
            List {
                Section { } header: {
                    WalletHeaderView(
                        model: model.assetHeaderModel,
                        isHideBalanceEnalbed: .constant(false),
                        onHeaderAction: model.onSelectHeader,
                        onInfoAction: model.onSelectWalletHeaderInfo,
                        showTwoButton: true,
                    )
                    .padding(.top, .small)
                    .padding(.bottom, .medium)
                }.padding(.top, 100)
                .cleanListRow()
                .listRowBackground(Color.clear)
                
//                if let banner = model.assetBannerViewModel.allBanners.first {
//                    Section {
//                        BannerView(
//                            banner: banner,
//                            action: model.onSelectBanner
//                        ) .listRowBackground(Color.clear)
//                    }
//                    .listRowInsets(.zero)
//                    .listRowBackground(Color.clear)
//                }
//                
                if model.showStatus {
                    Section {
                        AssetStatusView(model: model.scoreViewModel, action: model.onSelectTokenStatus)
                    } .listRowBackground(Color.clear)
                }
                
                if model.showManageToken {
                    Section(header: Text(Localized.Common.manage)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)) {
                        NavigationCustomLink(with:
                                                ListItemView(
                                                    title: model.pinText,
                                                    imageStyle: .list(assetImage: AssetImage(placeholder: model.pinImage))
                                                )
                        ) {
                            model.onSelectPin()
                        }
                        NavigationCustomLink(with:
                                                ListItemView(
                                                    title: model.enableText,
                                                    imageStyle: .list(assetImage: AssetImage(placeholder: model.enableImage))
                                                )
                        ) {
                            model.onSelectEnable()
                        }
                    } .listRowBackground(Color.clear)
                }
                
                Section {
                    PriceListItemView(model: model.priceItemViewModel)
                        .accessibilityIdentifier("price")
                        .listRowBackground(Color.clear)

                    
//                    if model.showPriceAlerts {
//                        NavigationLink(
//                            value: Scenes.AssetPriceAlert(asset: model.assetData.asset),
//                            label: {
//                                ListItemView(
//                                    title: model.priceAlertsViewModel.priceAlertsTitle,
//                                    subtitle: model.priceAlertsViewModel.priceAlertCount
//                                )
//                            }
//                        )
//                    }
                    
                    if model.canOpenNetwork {
                        NavigationLink(
                            value: Scenes.Asset(asset: model.assetModel.asset.chain.asset),
                            label: { networkView }
                        ).listRowBackground(Color.clear)
                    } else {
                        networkView
                    }
                }
                
                if model.showBalances {
                    Section() {
                        ListItemView(
                            title: model.assetDataModel.availableBalanceTitle,
                            subtitle: model.assetDataModel.availableBalanceTextWithSymbol
                        ) .listRowBackground(Color.clear)
                        
                        if model.showStakedBalance {
                            stakeView .listRowBackground(Color.clear)
                        }
                        
                        if model.showReservedBalance, let url = model.reservedBalanceUrl {
                            SafariNavigationLink(url: url) {
                                ListItemView(
                                    title: model.assetDataModel.reservedBalanceTitle,
                                    subtitle: model.assetDataModel.reservedBalanceTextWithSymbol
                                )
                            }
                        }
                        
                    }header: {
                        Text(model.balancesTitle)
                            .font(.body)
                            .foregroundColor(.white)
                          
                            .padding(.top, 8)
                            .background(Color.clear)
                    }
                } else if model.assetDataModel.isStakeEnabled {
                    stakeViewEmpty
                        .listRowInsets(.assetListRowInsets).listRowBackground(Color.clear)
                }
                
                if model.showResources {
                    Section() {
                        ListItemView(
                            title: model.energyTitle,
                            subtitle: model.assetDataModel.energyText
                        ) .listRowBackground(Color.clear)
                        
                        ListItemView(
                            title: model.bandwidthTitle,
                            subtitle: model.assetDataModel.bandwidthText
                        ) .listRowBackground(Color.clear)
                    }header: {
                        Text(model.resourcesTitle)
                            .font(.body)
                            .foregroundColor(.white)
                          
                            .padding(.top, 8)
                            .background(Color.clear)
                    }
                }
                
                if model.showTransactions {
                    TransactionsList(
                        explorerService: model.explorerService,
                        model.transactions,
                        currency: model.assetDataModel.currencyCode
                    )
                    .listRowInsets(.assetListRowInsets)
                    .listRowBackground(Color.clear)
                } else {
//                    Section {
//                        Spacer()
//                        EmptyContentView(model: model.emptyContentModel)
//                            .padding(.bottom, .extraLarge)
//                    }
//                    .cleanListRow()
                }
            }
            .refreshable {
                await model.fetch()
            }
            .taskOnce(model.fetchOnce)
            .listSectionSpacing(.compact)
            .navigationTitle(model.title)
            .contentMargins([.top], .small, for: .scrollContent)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - UI Components

extension AssetScene {
    private var networkView: some View {
        ListItemImageView(
            title: model.networkTitle,
            subtitle: model.networkText,
            assetImage: model.networkAssetImage,
            imageSize: .list.image,
            
            
        ) .listRowBackground(Color.clear)
    }

    private var stakeView: some View {
        NavigationCustomLink(
            with: ListItemView(title: model.stakeTitle, subtitle: model.assetDataModel.stakeBalanceTextWithSymbol),
            action: { model.onSelectHeader(.stake) }
        )
        .accessibilityIdentifier("stake")
    }
    
    private var stakeViewEmpty: some View {
        NavigationCustomLink(
            with: HStack(spacing: .space6) {
                EmojiView(color: Colors.clear, emoji: "🏅")
                    .frame(size: .image.asset)
                ListItemView(
                    title: model.stakeTitle,
                    subtitle: model.stakeAprText,
                    subtitleStyle: TextStyle(font: .callout, color: Colors.green)
                )
            },
            action: { model.onSelectHeader(.stake) }
        )
    }
}
