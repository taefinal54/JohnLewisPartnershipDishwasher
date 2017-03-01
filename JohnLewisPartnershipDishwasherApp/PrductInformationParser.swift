//
//  ProductParser.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 01/03/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import Foundation

class PrductInformationParser{
    
    var responseDictionary: [String: AnyObject]!

    init(with responseDictionary: [String:AnyObject]) {
        self.responseDictionary = responseDictionary
    }
    
    func getTitle() -> String {
        guard let title = responseDictionary["title"] as? String else {
            print("Could not get title from JSON")
            return ""
        }
        return title
    }
    
    func getNowPrice() -> String {
        
        guard let price = responseDictionary["price"] as? [String:AnyObject] else {
            print("Could not get price from JSON")
            return ""
        }
        
        guard let nowPrice = price["now"] as? String else {
            print("Could not get now price title from JSON")
            return ""
        }
        
        return nowPrice
    }
    
    func getURLs() -> [String] {
        guard let skus = responseDictionary["skus"] as? [[String:AnyObject]] else {
            print("Could not get skus from JSON")
            return [String]()
        }
        
        let media = skus[0]["media"] as? [String:AnyObject]
        guard let images = media?["images"] as? [String:AnyObject] else {
            print("Could not get skus media images from JSON")
            return [String]()
        }
        
        guard let urls = images["urls"] as? [String] else {
            print("Could not get images urls from JSON")
            return [String]()
        }
        
        return urls
    }
    
    func getServices() -> String {
        guard let additionalServices = responseDictionary["additionalServices"] as? [String:AnyObject] else {
            print("Could not get todo title from JSON")
            return ""
        }
        
        guard let includedServices = additionalServices["includedServices"] as? [String] else {
            print("Could not get additionalServices from JSON")
            return ""
        }
        
        let servicesStr = includedServices[0]
        return servicesStr
    }
    
    func getdisplaySpecialOffer() -> String {
        guard let displaySpecialOffer = responseDictionary["displaySpecialOffer"] as? String else {
            print("Could not get displaySpecialOffer from JSON")
            return ""
        }
        return displaySpecialOffer
    }
    
    
    func getProductInformation() -> String {
        
        if responseDictionary == nil{
            return ""
        }
        
        guard let details = responseDictionary["details"] as? [String:AnyObject] else {
            print("Could not get details from JSON")
            return ""
        }
        
        guard let productInformation = details["productInformation"] as? String else {
            print("Could not get productInformation from JSON")
            return ""
        }
        
        return productInformation
    }
    
    func getProductCode() -> String {
        if responseDictionary == nil{
            return ""
        }
        
        guard let code = responseDictionary["code"] as? String else {
            print("Could not get product code from JSON")
            return ""
        }
        return code
    }
}

