//
//  Dish.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 28/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import Foundation
import SwiftyJSON

class Dish {
    var dishId : String
    var name : String
    var stock : Int
    var urlImage : String
    var typeDishId: Int
    
    init(dishId : String, name: String, stock: Int, urlImage: String, typeDishId:Int) {
        self.dishId=dishId
        self.name = name
        self.stock = stock
        self.urlImage = urlImage
        self.typeDishId = typeDishId
    }
    
    convenience init (from jsonMenu: JSON){
        self.init(dishId: jsonMenu["dishId"].stringValue,
                  name: jsonMenu["name"].stringValue,
                  stock: jsonMenu["stock"].intValue,
                  urlImage: jsonMenu["urlImage"].stringValue,
                  typeDishId: jsonMenu["typeDishId"].intValue)
    }
    
    public static func buildAll(from jsonMenu: [JSON]) -> [Dish] {
        let count = jsonMenu.count
        var menus: [Dish] = []
        for i in 0 ..< count {
            menus.append(Dish(from: JSON(jsonMenu[i])))
        }
        return menus
    }
}
