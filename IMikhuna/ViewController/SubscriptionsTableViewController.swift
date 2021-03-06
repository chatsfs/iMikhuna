//
//  SubscriptionsTableViewController.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 26/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "Cell"

class HeadlineCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var openHour: UILabel!
    
    
    func updateView(from subscription: Subscription) {
        nameLabel.text = subscription.name
        addressLabel.text = subscription.address
        openHour.text = subscription.openHour
    }
    
}

class SubscriptionsTableViewController: UITableViewController {
    var userId : String = ""
    var token : String = ""
    var sessionStore = SessionStore()
    var subscriptions : [Subscription] = []
    var currentItemIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = sessionStore.storeSession?.userId as! String
        token = sessionStore.storeSession?.token as! String
        updateData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subscriptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HeadlineCell

        // Configure the cell...
        cell.updateView(from: subscriptions[indexPath.row])
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurant" {
            let restaurantViewController = ( segue.destination as! UINavigationController).viewControllers.first as! RestaurantViewController
            restaurantViewController.restaurant = subscriptions[currentItemIndex]
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentItemIndex = indexPath.row
        self.performSegue(withIdentifier: "showRestaurant", sender: self)
    }
    @IBAction func signOutAction(_ sender: Any) {
        sessionStore.logout()
        self.dismiss(animated: true)
    }
    

    func updateData() {
        let headers: HTTPHeaders = [
            "token": token
        ]
        Alamofire.request("http://mikhunaservices.us-east-2.elasticbeanstalk.com/api/users/\(userId)/subscriptions",
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
                    self.subscriptions = Subscription.buildAll(from: json["result"].arrayValue)
                    self.tableView!.reloadData()
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    break
                }
            })
    }

}
