//
//  WebServicesHelper.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 28/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import XCTest
@testable import JohnLewisPartnershipDishwasherApp

class WebServicesHelperTests: XCTestCase {

    var productGridURL:String!
    var productURL:String!
    var productURL12345:String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        productGridURL = "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20"
        productURL = "https://api.johnlewis.com/v1/products/1485769?key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
        productURL12345 = "https://api.johnlewis.com/v1/products/12345?key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"

        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        productURL = nil
        productGridURL = nil
    }
    
    
    func testGetProductGridWithTelevision() {
        XCTAssertFalse(WebServicesHelper.getProductGrid(productType: "television") == productGridURL)
    }

    func testGetProductGridWithDishwasher() {
        XCTAssertTrue(WebServicesHelper.getProductGrid(productType: "dishwasher") == productGridURL)
    }
    
    func testGetProductGridWithID1485769() {
        XCTAssertTrue(WebServicesHelper.getProductPage(productID: "1485769") == productURL)
    }
    
    func testGetProductGridWithID12345() {
        XCTAssertFalse(WebServicesHelper.getProductPage(productID: "1485769") == productURL12345)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
