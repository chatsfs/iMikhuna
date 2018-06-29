//
//  Order.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 28/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import Foundation
import SwiftyJSON

class Order {
    var saleId : String
    var restaurantName : String
    var cost : Int
    var pickUpHour : String
    
    init(saleId : String, restaurantName: String, cost: Int, pickUpHour: String) {
        self.saleId = saleId
        self.restaurantName = restaurantName
        self.cost = cost
        self.pickUpHour = pickUpHour
    }
    
    convenience init (from jsonSubscription: JSON){
        print(jsonSubscription["cost"].intValue)
        self.init(saleId: jsonSubscription["saleId"].stringValue,
                  restaurantName: jsonSubscription["restaurantName"].stringValue,
                  cost: jsonSubscription["cost"].intValue,
                  pickUpHour: jsonSubscription["pickUpHour"].stringValue)
    }
    
    public static func buildAll(from jsonOrder: [JSON]) -> [Order] {
        let count = jsonOrder.count
        var orders: [Order] = []
        for i in 0 ..< count {
            orders.append(Order(from: JSON(jsonOrder[i])))
        }
        return orders
    }
}
