// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Components
import Primitives
import GRDBQuery
import Store
import Style
import Localization
import PrimitivesComponents

public struct WalletsScene: View {
    @Environment(\.dismiss) private var dismiss

    @State private var model: WalletsSceneViewModel

    public init(model: WalletsSceneViewModel) {
        _model = State(initialValue: model)
    }

    public var body: some View {
        ZStack {
            BackGroundView()
        
        List {
            Section {
                Button(
                    action: model.onSelectCreateWallet,
                    label: {
                        HStack {
                            Images.Wallets.create
                            Text(Localized.Wallet.createNewWallet)
                        }.foregroundColor(.white)
                    }
                )
                Button(
                    action: model.onSelectImportWallet,
                    label: {
                        HStack {
                            Images.Wallets.import
                            Text(Localized.Wallet.importExistingWallet)
                        }.foregroundColor(.white)
                    }
                )
            }.listRowBackground(Color.clear)

            if !model.pinnedWallets.isEmpty {
                Section {
                    ForEach(model.pinnedWallets) {
                        WalletListItemView(
                            wallet: $0,
                            currentWalletId: model.currentWalletId,
                            onSelect: { model.onSelect(wallet: $0, dismiss: dismiss) },
                            onEdit: model.onEdit,
                            onPin: model.onPin,
                            onDelete: model.onDelete
                        )
                    }
                    .onMove(perform: model.onMovePinned)
                } header: {
                    HStack {
                        Images.System.pin
                        Text(Localized.Common.pinned)
                    }
                }.listRowBackground(Color.clear)
            }

            Section {
                ForEach(model.wallets) {
                    WalletListItemView(
                        wallet: $0,
                        currentWalletId: model.currentWalletId,
                        onSelect: { model.onSelect(wallet: $0, dismiss: dismiss) },
                        onEdit: model.onEdit,
                        onPin: model.onPin,
                        onDelete: model.onDelete
                    )
                }
                .onMove(perform: model.onMove)
            }.listRowBackground(Color.clear)
        }.safeAreaInset(edge: .top) {
            Color.clear.frame(height: 100)
        }
        .contentMargins(.top, .scene.top, for: .scrollContent)
        .alertSheet($model.isPresentingAlertMessage)
        .alert(
            Localized.Common.deleteConfirmation(model.walletDelete?.name ?? ""),
            presenting: $model.walletDelete,
            sensoryFeedback: .warning,
            actions: { wallet in
                Button(
                    Localized.Common.delete,
                    role: .destructive,
                    action: { Task { await model.onDeleteConfirmed(wallet: wallet) } }
                )
            }
        )
        .navigationBarTitle(model.title)
        .observeQuery(
            request: .constant(model.pinnedWalletsRequest),
            value: $model.pinnedWallets
        )
        .observeQuery(
            request: .constant(model.walletsRequest),
            value: $model.wallets
        )
    }
            .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
    }
}

