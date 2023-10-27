
//
//  TheMovieDBDemoUITests.swift
//  TheMovieDBDemoUITests
//
//  Created by Khanh Vo on 27/10/2023.
//

import XCTest

final class TheMovieDBDemoUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSearch() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.searchFields["Titanic, Spider Man, ..."]
        searchField.tap()
        
        app.keys["S"].tap()
        app.keys["p"].tap()
        app.keys["i"].tap()
        app.keys["d"].tap()
        app.keys["e"].tap()
        app.keys["r"].tap()
        
        app.tables.cells.firstMatch.tap()
        app.navigationBars["Movie"].children(matching: .button).element.tap()

        searchField.buttons["Clear text"].tap()
        
        searchField.tap()
        
        app.tables.cells.firstMatch.swipeUp()
    }
}
