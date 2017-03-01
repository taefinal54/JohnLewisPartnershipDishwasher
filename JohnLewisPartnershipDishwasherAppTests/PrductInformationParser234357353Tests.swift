//
//  PrductInformationParser234357353Tests.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 01/03/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import XCTest

@testable import JohnLewisPartnershipDishwasherApp
class PrductInformationParser234357353Tests: XCTestCase {
    
    var prductInformationParser:PrductInformationParser!
    var session:URLSession! = nil

    
    override func setUp() {
        super.setUp()
        session = URLSession(configuration: URLSessionConfiguration.default)

        WebServices.sharedInstance.HTTPRequest(session:session, url: WebServicesHelper.getProductPage(productID: "1913470")) { responseDictionary in
            self.prductInformationParser = PrductInformationParser(with: responseDictionary)
            XCTAssertNotNil(responseDictionary, "XCTAssertNotNil not nil")
        }

        sleep(5)
    }
    
    override func tearDown() {
        super.tearDown()
        session.invalidateAndCancel()
        prductInformationParser = nil
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGetTitle(){
        XCTAssertTrue(prductInformationParser.getTitle() == "Bosch SMV53M40GB Fully Integrated Dishwasher")
    }
    
    func testGetNowPrice(){
        XCTAssertTrue(prductInformationParser.getNowPrice() == "449.00")
    }
    
    func testGetURLs(){
        let urls = ["//johnlewis.scene7.com/is/image/JohnLewis/234326372?",
                    "//johnlewis.scene7.com/is/image/JohnLewis/234326372alt1?",
                    "//johnlewis.scene7.com/is/image/JohnLewis/234326372alt10?",
                    "//johnlewis.scene7.com/is/image/JohnLewis/234326372alt2?",
                    "//johnlewis.scene7.com/is/image/JohnLewis/234326372alt3?",
                    "//johnlewis.scene7.com/is/image/JohnLewis/234326372alt9?"]
        XCTAssertTrue(prductInformationParser.getURLs() == urls)

    }
    
    func testGetServices(){
        XCTAssertTrue(prductInformationParser.getServices() == "2 year guarantee included")
    }
    
    func testgetDisplaySpecialOffer(){
        XCTAssertTrue(prductInformationParser.getdisplaySpecialOffer() == "Save £50 until 09.03.17 (Was £499 from 08.02.17 - 23.02.17)")
    }
    
    func testGetProductCode(){
        XCTAssertTrue(prductInformationParser.getProductCode() == "88701205")
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
