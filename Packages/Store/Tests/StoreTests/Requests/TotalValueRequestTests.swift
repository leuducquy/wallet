// Copyright (c). Gem Wallet. All rights reserved.

import Testing
import Store
import StoreTestKit
import Primitives
import PrimitivesTestKit

struct TotalValueRequestTests {
    @Test
    func newPriceUsesWalletCurrency() throws {
        let db = DB.mockAssets()
        let currency = "VND"
        try FiatRateStore.mock(db: db).add([FiatRate(symbol: currency, rate: 25_000)])
        try PriceStore.mock(db: db).updatePrice(price: .mock(assetId: Chain.tron.assetId, price: 0.3), currency: currency)

        let value = try db.dbQueue.read {
            try TotalValueRequest(walletId: .empty, balanceType: .wallet).fetch($0)
        }

        #expect(value == 15_000)
    }
}
