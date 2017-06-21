//
//  SnapshotUITests.swift
//  SnapshotUITests
//
//  Created by Heberti Almeida on 2017-06-19.
//  Copyright © 2017 Adventech. All rights reserved.
//

import XCTest
import SimulatorStatusMagic

class SnapshotUITests: XCTestCase {
    fileprivate let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        SDStatusBarManager.sharedInstance().enableOverrides()

        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        SDStatusBarManager.sharedInstance().disableOverrides()
    }

    func testScreenshots() {
        app.buttons["continueWithoutLogin"].tap()
        app.buttons["loginAnonimousOptionYes"].tap()

        // Quarterly
        snapshot("01Quarterly")

        // Lesson
        app.buttons["openLesson"].tap()
        snapshot("02Lesson")

        // Read
        app.buttons["readLesson"].tap()
        snapshot("03Reading")

        // Verse
        let verseRegex = "(?:\\d|I{1,3})?\\s?\\w{2,}\\.?\\s*\\d{1,}\\:\\d{1,}-?,?\\d{0,2}(?:,\\d{0,2}){0,2}"
        let verses = app.collectionViews.webViews.staticTexts.matching(NSPredicate(format: "label MATCHES %@", verseRegex))
        XCTAssert(verses.count > 0, "No verses match with Regex")
        verses.element(boundBy: 0).tap()
        snapshot("04Verse")
        app.buttons["dismissBibleVerse"].tap()

        // Theme
        app.buttons["themeSettings"].tap()
        snapshot("05Theme")
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).tap()

        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.buttons["openSettings"].tap()
        app.tables.cells.otherElements.matching(identifier: "logOut").element.tap()
    }
}