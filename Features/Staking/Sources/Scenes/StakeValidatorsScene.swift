// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI
import Components
import Style
import Primitives
import PrimitivesComponents

public struct StakeValidatorsScene: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var model: StakeValidatorsViewModel

    public init(model: StakeValidatorsViewModel) {
        _model = State(wrappedValue: model)
    }

    public var body: some View {
        ZStack {
            BackGroundView()
        
        List {
            ForEach(model.list) { section in
                Section( header: Text(section.section)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .textCase(nil)) {
                    ForEach(section.values) { value in
                        ValidatorSelectionView(value: value, selection: model.currentValidator?.id) {
                            model.selectValidator?($0)
                            dismiss()
                        }
                        .contextMenu(model.contextMenu(for: value.value))
                    }
                }.listRowBackground(Color.clear)
            }
        }
        .navigationTitle(model.title)
        .safariSheet(url: $model.isPresentingUrl)
        }.safeAreaInset(edge: .top) {
            Color.clear
                .frame(height: 100)
        }
            .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
    }
}
