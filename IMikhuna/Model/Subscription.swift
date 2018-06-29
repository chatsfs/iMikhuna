//
//  Subscription.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 28/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import Foundation
import SwiftyJSON

class Subscription {
    var restaurantId : String
    var name : String
    var address : String
    var openHour : String
    
    init(restaurantId : String, name: String, address: String, openHour: String) {
        self.restaurantId=restaurantId
        self.name = name
        self.address = address
        self.openHour = openHour
    }
    
    convenience init (from jsonSubscription: JSON){
        self.init(restaurantId: jsonSubscription["restaurantId"].stringValue,
                  name: jsonSubscription["name"].stringValue,
                  address: jsonSubscription["address"].stringValue,
                  openHour: jsonSubscription["openHour"].stringValue)
    }
    
    public static func buildAll(from jsonSubscription: [JSON]) -> [Subscription] {
        let count = jsonSubscription.count
        var subscriptions: [Subscription] = []
        for i in 0 ..< count {
            subscriptions.append(Subscription(from: JSON(jsonSubscription[i])))
        }
        return subscriptions
    }
}
