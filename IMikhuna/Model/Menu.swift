//
//  Menu.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 28/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//
import Foundation
import SwiftyJSON

class Menu {
    var menuId : String
    var name : String
    var price : Int
    var state : String
    
    init(menuId : String, name: String, price: Int, state: String) {
        self.menuId=menuId
        self.name = name
        self.price = price
        self.state = state
    }
    
    convenience init (from jsonMenu: JSON){
        self.init(menuId: jsonMenu["menuId"].stringValue,
                  name: jsonMenu["name"].stringValue,
                  price: jsonMenu["price"].intValue,
                  state: jsonMenu["state"].stringValue)
    }
    
    public static func buildAll(from jsonMenu: [JSON]) -> [Menu] {
        let count = jsonMenu.count
        var menus: [Menu] = []
        for i in 0 ..< count {
            menus.append(Menu(from: JSON(jsonMenu[i])))
        }
        return menus
    }
}
