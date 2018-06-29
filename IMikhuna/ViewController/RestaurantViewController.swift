//
//  RestaurantViewController.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 26/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "Cell"

class MenuCell:UITableViewCell{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    func updateView(from menu: Menu) {
        nameLabel.text = menu.name
        priceLabel.text = String(menu.price)
    }
}
class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userId : String = ""
    var token : String = ""
    var sessionStore = SessionStore()
    var restaurant : Subscription?
    var menus : [Menu] = []
    var currentItemIndex: Int = 0
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = sessionStore.storeSession?.userId as! String
        token = sessionStore.storeSession?.token as! String
        restaurantLabel.text = restaurant?.name
        addressLabel.text = restaurant?.address
        updateData()
        // Do any additional setup after loading the view.
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell
        
        cell.updateView(from: menus[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentItemIndex = indexPath.row
        performSegue(withIdentifier: "showMakeOrder", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMakeOrder" {
            let makeOrderViewController = ( segue.destination as! UINavigationController).viewControllers.first as! MakeOrderViewController
            makeOrderViewController.restaurant = restaurant
            makeOrderViewController.menu = menus[currentItemIndex]
        }
    }
    func updateData() {
        let headers: HTTPHeaders = [
            "token": token
        ]
        Alamofire.request("http://mikhunaservices.us-east-2.elasticbeanstalk.com/api/restaurants/\(restaurant?.restaurantId as! String)/menus",
            headers: headers)
            .validate()
            .responseJSON(completionHandler: { response in
                switch (response.result) {
                case .success(let value):
                    let json = JSON(value)
                    if json["status"].stringValue == "error" {
                        print("Response Error: \(json["message"].stringValue)")
                        return
                    }
                    self.menus = Menu.buildAll(from: json["result"].arrayValue)
                    self.menuTableView.reloadData()
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    break
                }
            })
    }
}
