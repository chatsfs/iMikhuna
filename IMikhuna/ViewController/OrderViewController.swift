//
//  OrderViewController.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 25/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "Cell"

class SaleCell:UITableViewCell{
    
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    
    func updateView(from menu: JSON) {
        print(menu)
        print("celda")
        firstLabel.text = menu["dishes"][0]["name"].stringValue
        secondLabel.text = menu["dishes"][1]["name"].stringValue
    }
}
class OrderViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var token : String = ""
    var sessionStore = SessionStore()
    var order : Order?
    var sales : [JSON] = []
    var currentItemIndex: Int = 0

    @IBOutlet weak var restaurantLabel: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var pickUpHourLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        token = sessionStore.storeSession?.token as! String
        updateData()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sales.count
    }
    
    @IBAction func DoneAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SaleCell
        
        cell.updateView(from: sales[indexPath.row])
        return cell
    }
    
    func updateData() {
        let headers: HTTPHeaders = [
            "token": token
        ]
        
        Alamofire.request("http://mikhunaservices.us-east-2.elasticbeanstalk.com/api/sales/\(order?.saleId as! String)/user",
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
                    self.sales = json["result"]["listMenu"].arrayValue
                    self.restaurantLabel.text = json["result"]["restaurantName"].stringValue
                    self.pickUpHourLabel.text = json["result"]["pickUpHour"].stringValue
                    print(self.sales)
                    self.menuTableView.reloadData()
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    break
                }
            })
    }
}
