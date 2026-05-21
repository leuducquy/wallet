// Copyright (c). Gem Wallet. All rights reserved.

import Foundation
import SwiftUI
import Style
import Components

public struct StakeDelegationView: View {

    private let delegation: StakeDelegationViewModel

    public init(delegation: StakeDelegationViewModel) {
        self.delegation = delegation
    }

    public var body: some View {
        ListItemView(
           title: delegation.validatorText,
           titleStyle: .whiteText,
           titleExtra: delegation.stateText,
           titleStyleExtra: delegation.stateStyle,
           subtitle: delegation.balanceText,
           subtitleStyle: .whiteText,
           subtitleExtra: delegation.fiatValueText,
           subtitleStyleExtra: .whiteText,
           imageStyle: .asset(assetImage: delegation.validatorImage)
           
           
        )
    }
}
