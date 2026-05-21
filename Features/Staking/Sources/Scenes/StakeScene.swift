// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Store
import Primitives
import Components
import Localization
import InfoSheet
import PrimitivesComponents

public struct StakeScene: View {
    private let model: StakeSceneViewModel

    public init(model: StakeSceneViewModel) {
        self.model = model
    }

    public var body: some View {
        ScrollView {
            
                LazyVStack(alignment: .leading, spacing: 12) {
                    stakeInfoSection
                    if model.showManage {
                        stakeSection
                    }
                    if model.showTronResources {
                        resourcesSection
                    }
                    delegationsSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical,16).tint(.white)
                .refreshable {
                    await model.fetch()
                }
                .navigationTitle(model.title)
                .taskOnce {
                    Task {
                        await model.fetch()
                    }
                }
            }.background(BackGroundView())
            .padding(.top,100)
                    .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
        
    }
}

// MARK: - UI Components

extension StakeScene {
    private var stakeSection: some View {
        Section(   header: Text(Localized.Common.manage)
            .textStyle(.whiteText) 
            .frame(maxWidth: .infinity, alignment: .center)
           ) {
            if model.showStake {
                NavigationLink(value: model.stakeDestination) {
                    ListItemView(title: model.stakeTitle, )
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .enabled(model.isStakeEnabled).tint(.white)
                
               
            }
            
            if model.showFreeze {
                NavigationLink(value: model.freezeDestination) {
                    ListItemView(title: model.freezeTitle)
                }
            }

            if model.showUnfreeze {
                NavigationLink(value: model.unfreezeDestination) {
                    ListItemView(title: model.unfreezeTitle)
                }
            }

            if model.canClaimRewards {
                NavigationLink(value: model.claimRewardsDestination) {
                    ListItemView(
                        title: model.claimRewardsTitle,
                        subtitle: model.claimRewardsText
                    )
                }
            }
        }
    }

    private var delegationsSection: some View {
        Section(header: Text(model.delegationsSectionTitle)
            .textStyle(.whiteText)
            .frame(maxWidth: .infinity, alignment: .center)) {
            switch model.delegationsState {
            case .noData:
                EmptyContentView(model: model.emptyContentModel)
                    .cleanListRow()
            case .loading:
                ListItemLoadingView()
                    .id(UUID())
            case .data(let delegations):
                ForEach(delegations) { delegation in
                   
                    NavigationLink(value: delegation.navigationDestination) {
                        StakeDelegationView(delegation: delegation)
                    } .tint(.clear)
                }
              
            case .error(let error):
                ListItemErrorView(errorTitle: Localized.Errors.errorOccured, error: error)
            }
        }.textStyle(.whiteText)
    }

    private var stakeInfoSection: some View {
        Section(model.assetTitle) {
            ListItemView(
                title: model.stakeAprTitle,
                titleStyle: .whiteText,
                subtitle: model.stakeAprValue,
                infoAction: model.onAprInfo,
                
            )
            ListItemView(
                title: model.lockTimeTitle,
                subtitle: model.lockTimeValue,
                infoAction: model.onLockTimeInfo
            )
            if let minAmountValue = model.minAmountValue {
                ListItemView(title: model.minAmountTitle, subtitle: minAmountValue)
            }
        }.textStyle(.whiteText,)
    }

    private var resourcesSection: some View {
        Section(model.resourcesTitle) {
            ListItemView(
                title: model.energyTitle,
                subtitle: model.energyText
            )

            ListItemView(
                title: model.bandwidthTitle,
                subtitle: model.bandwidthText
            )
        }.textStyle(.whiteText)
        
    }
}
