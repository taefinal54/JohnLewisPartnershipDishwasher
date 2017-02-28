//
//  WebservicesHelper.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 24/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import UIKit
import Alamofire

class WebServicesHelper: NSObject {
    static fileprivate let URL = "https://api.johnlewis.com/v1/"
    static fileprivate let API_KEY = "key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
    static fileprivate let ROUTE_PRODUCT = "products/"
        

    ///search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20
    static func getProductGrid(productType: String) -> String {
        return URL + ROUTE_PRODUCT + "search?q=" + productType + "&" + API_KEY + "&pageSize=20"
    }
    
    // GET https://api.johnlewis.com/v1/products/1913267?key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb
    static func getProductPage(productID: String) -> String{
        return URL + ROUTE_PRODUCT + productID + "?" + API_KEY
    }
}
