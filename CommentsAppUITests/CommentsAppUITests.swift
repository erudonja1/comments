//
//  CommentsAppUITests.swift
//  CommentsAppUITests
//
//  Created by Elvis on 11/11/21.
//

import XCTest

class CommentsAppUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }

    override func tearDownWithError() throws { }

    func testFirstItemOpened() throws {
        let app = XCUIApplication()
        app.launch()

        let firstRow = app.tables.firstMatch.cells.firstMatch
        let title: String = firstRow.label.first?.description ?? ""
        firstRow.tap()

        XCTAssertEqual(app.alerts.element.title.description, title)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
