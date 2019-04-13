//
//  MeditationUITests.swift
//  MeditationUITests
//
//  Created by Joey Tawadrous on 19/08/2018.
//  Copyright © 2018 Joey Tawadrous. All rights reserved.
//

import XCTest

class MeditationUITests: XCTestCase {
        
    override func setUp() {
		super.setUp()
		
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		// UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
		XCUIApplication().launch()
		
		let app = XCUIApplication()
		setupSnapshot(app)
		app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
		let app = XCUIApplication()
		
		snapshot("Meditation")
		
		
		
		app.buttons["GO"].tap()
		snapshot("RunMeditation")
		
//		XCUIDevice.shared.press(XCUIDevice.Button.home)
		
//		let scrollViewsQuery = app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"Home screen icons\"]",".otherElements[\"SBFolderScalingView\"].scrollViews",".scrollViews"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
//		scrollViewsQuery.otherElements.containing(.icon, identifier:"Watch").element.swipeRight()
//
//		let element = app.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
//		element/*@START_MENU_TOKEN@*/.press(forDuration: 2.3);/*[[".tap()",".press(forDuration: 2.3);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//		element/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//		app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.tables.buttons["Insert Meditation Fox"]/*[[".otherElements[\"Home screen icons\"]",".otherElements[\"SBFolderScalingView\"].scrollViews.otherElements.tables",".cells[\"Meditation Fox\"].buttons[\"Insert Meditation Fox\"]",".buttons[\"Insert Meditation Fox\"]",".scrollViews.otherElements.tables"],[[[-1,4,2],[-1,1,2],[-1,0,1]],[[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
//		scrollViewsQuery.otherElements.navigationBars["UITableView"].buttons["Done"].tap()
//		app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.scrollViews["WGMajorListViewControllerView"].otherElements.buttons["Show More"]/*[[".otherElements[\"Home screen icons\"]",".otherElements[\"SBFolderScalingView\"].scrollViews.otherElements.scrollViews[\"WGMajorListViewControllerView\"].otherElements",".otherElements[\"WGWidgetPlatterView\"].buttons[\"Show More\"]",".buttons[\"Show More\"]",".scrollViews.otherElements.scrollViews[\"WGMajorListViewControllerView\"].otherElements"],[[[-1,4,2],[-1,1,2],[-1,0,1]],[[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
//
//		snapshot("TodayWidget")
    }
    
}
