// Copyright (c). Gem Wallet. All rights reserved.

import XCTest

extension XCUIApplication {
    
    var isOnboarding: Bool {
        buttons["Create a New Wallet"].exists
    }

    func acceptTerms() {
        if buttons["Agree and Continue"].exists {
            switches.allElementsBoundByIndex.forEach { $0.tap() }
            buttons["Agree and Continue"].firstMatch.tap()
        }
    }

    func tapContinue() {
        buttons["Continue"].firstMatch.tap()
    }

    func tapBack() {
        navigationBars.buttons.element(boundBy: 0).tap()
    }

    func getWords() -> [String] {
        (0..<12).map { staticTexts["word_\($0)"].label }
    }
    
    func openWallets() {
        let settings = buttons["Settings"].firstMatch
        XCTAssertTrue(settings.waitForExistence(timeout: 30))
        settings.tap()

        let wallets = buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Wallets")).firstMatch
        XCTAssertTrue(wallets.waitForExistence(timeout: 5))
        wallets.tap()
    }
    
    func logout() {
        if isOnboarding == false {
            openWallets()
            // WalletsScene
            buttons["gearshape"].firstMatch.tap()
            // WalletDetailScene
            buttons["Delete"].firstMatch.tap()
            // Delete confirmation alert
            let confirmDelete = alerts.buttons["Delete"].firstMatch
            XCTAssertTrue(confirmDelete.waitForExistence(timeout: 10))
            confirmDelete.tap()
            XCTAssertTrue(buttons["Create a New Wallet"].firstMatch.waitForExistence(timeout: 15))
        }
    }
}
