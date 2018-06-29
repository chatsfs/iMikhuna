//
//  OrdersTableViewController.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 26/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "Cell"

class OrderCell: UITableViewCell {
    
    @IBOutlet var restaurantLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var pickUpHour: UILabel!
    
    
    func updateView(from order: Order) {
        restaurantLabel.text = order.restaurantName
        costLabel.text = String(order.cost)
        pickUpHour.text = order.pickUpHour
    }
    
}


class OrdersTableViewController: UITableViewController {
    var userId : String = ""
    var token : String = ""
    var sessionStore = SessionStore()
    var orders : [Order] = []
    var currentItemIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = sessionStore.storeSession?.userId as! String
        token = sessionStore.storeSession?.token as! String
        updateData()
    }
    @IBAction func signOutAction(_ sender: Any) {
        sessionStore.logout()
        self.dismiss(animated: true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! OrderCell

        // Configure the cell...
        cell.updateView(from: orders[indexPath.row])
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOrderDetails" {
            let restaurantViewController = ( segue.destination as! UINavigationController).viewControllers.first as! OrderViewController
            restaurantViewController.order = orders[currentItemIndex]
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentItemIndex = indexPath.row
        self.performSegue(withIdentifier: "showOrderDetails", sender: self)
    }
    
    func updateData() {
        let headers: HTTPHeaders = [
            "token": token
        ]
        Alamofire.request("http://mikhunaservices.us-east-2.elasticbeanstalk.com/api/users/\(userId)/orders",
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
                    print("salio")
                    self.orders = Order.buildAll(from: json["result"].arrayValue)
                    self.tableView!.reloadData()
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    break
                }
            })
    }

}
