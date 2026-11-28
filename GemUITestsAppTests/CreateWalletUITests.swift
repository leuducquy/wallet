// Copyright (c). Gem Wallet. All rights reserved.

import XCTest

@MainActor
final class CreateWalletUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    func testCreateWalletAndVerifyRecoveryPhrase() throws {
        let app = XCUIApplication()
        setupPermissionHandler()
        app.launch()
        app.logout()

        // OnboardingScene
        app.buttons["Create a New Wallet"].firstMatch.tap()

        // AcceptTermsScene
        app.acceptTerms()

        XCTAssertFalse(app.buttons["Continue"].firstMatch.isEnabled)
        app.switches["securityAcknowledgment"].tap()
        app.tapContinue()

        // ShowSecretDataScene
        let words = app.getWords()
        app.tapContinue()

        // VerifyPhraseWalletScene
        for word in words {
            let choice = app.buttons.matching(identifier: word).allElementsBoundByIndex.first(where: \.isEnabled)
            try XCTUnwrap(choice).tap()
        }
        XCTAssertTrue(app.buttons["Continue"].firstMatch.isEnabled)
        app.tapContinue()

        // SettingsScene
        app.openWallets()

        // WalletsScene
        app.buttons["gearshape"].firstMatch.tap()

        // WalletDetailScene
        app.buttons["Show Secret Phrase"].firstMatch.tap()

        XCTAssertFalse(app.buttons["Continue"].firstMatch.isEnabled)
        app.switches["securityAcknowledgment"].tap()
        app.tapContinue()

        // ShowSecretDataScene
        let displayedWords = app.getWords()
        XCTAssertEqual(words, displayedWords)
    }
}
