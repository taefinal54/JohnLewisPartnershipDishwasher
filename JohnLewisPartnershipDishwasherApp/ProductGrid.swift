//
//  ProductGrid.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 24/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import Foundation

class ProductGrid{

    var title: String!
    var price: String!
    var image: String!
    var productId: String!
    
    init(productId: String!, title: String!, price: String!, image: String!) {
        self.title = title
        self.price = price
        self.image = "https:" + image
        self.productId =  productId
    }
    
}
