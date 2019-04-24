//
//  Item.swift
//  EbayApp
//
//  Created by Deyi Kong on 4/23/19.
//  Copyright © 2019 Deyi Kong. All rights reserved.
//

import Foundation

class Item {
    let imageUrl:String
    let title:String
    let price: Double
    let shippingCost:Double
    let zipcode:Int
    var inWishList:Bool
    private let conditionId:String
    
    
    init(imageUrl: String,
         title: String,
         price: Double,
         shippingCost: Double,
         zipcode: Int,
         conditionId: String,
         inWishList: Bool = false) {
        self.imageUrl = imageUrl
        self.title = title
        self.price = price
        self.shippingCost = shippingCost
        self.zipcode = zipcode
        self.conditionId = conditionId
        self.inWishList = inWishList
    }
    
    var condition: String {
        get{
            switch conditionId {
            case "1000":
                return "NEW"
            case _ where ["2000", "2500"].contains(conditionId):
                return "REFURBISHED"
            case _ where ["3000", "4000", "5000", "6000"].contains(conditionId):
                return "USED"
            default:
                return "NA"
            }
        }
    }
}
