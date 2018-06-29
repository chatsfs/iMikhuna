//
//  MakeOrderViewController.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 26/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MakeOrderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var restaurant : Subscription?
    var menu : Menu?

    
    var dishes: [Dish]=[]
    
    var token : String = ""
    var sessionStore = SessionStore()
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuPrice: UILabel!
    @IBOutlet weak var appetizerPickerView: UIPickerView!
    @IBOutlet weak var dishPickerView: UIPickerView!
    @IBOutlet weak var drinkPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantName.text = restaurant?.name
        menuLabel.text = menu?.name
        menuPrice.text = String(menu?.price as! Int)
        token = sessionStore.storeSession?.token as! String
        self.appetizerPickerView.dataSource = self
        self.appetizerPickerView.delegate = self
        self.dishPickerView.dataSource = self
        self.drinkPickerView.delegate = self
        self.drinkPickerView.dataSource = self
        self.dishPickerView.delegate = self
        self.drinkPickerView.isHidden = true
        updateData()
    }
    
    @IBAction func DoneAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dishes.count
    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        let dish:[String:Any] = ["dishId":self.dishes[self.appetizerPickerView.selectedRow(inComponent: 0)].dishId]
        let dish2: [String:Any] = ["dishId":self.dishes[self.dishPickerView.selectedRow(inComponent: 0)].dishId]
        let menu:[String:Any] =  ["menuId":self.menu?.menuId as! String,"quantity":2,"listDish":[dish,dish2]]
        let parameters:[String:Any] = ["restaurantId":restaurant?.restaurantId as! String,"pickUpHour":"2018-06-28T08:22:46.6593813+00:00","listMenu" :[menu]]
        let headers: HTTPHeaders = [
            "token": token
        ]
        Alamofire.request("http://mikhunaservices.us-east-2.elasticbeanstalk.com/api/sales", method: .post,parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON(completionHandler: {response in
                switch (response.result){
                case .success(let value):
                    let json = JSON(value)
                    let hasError = json["hasError"].stringValue
                    if  hasError == "true" {
                        print("Response Error: \(json["message"].stringValue)")
                        break
                    }
                    self.dismiss(animated: true)
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    break
                }
            })
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dishes[row].name
    }
    func updateData() {
        let headers: HTTPHeaders = [
            "token": token
        ]
        Alamofire.request("http://mikhunaservices.us-east-2.elasticbeanstalk.com/api/menus/\(menu?.menuId as! String)/dishes",
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
                    self.dishes = Dish.buildAll(from: json["result"]["dishes"].arrayValue)
                    self.appetizerPickerView.reloadAllComponents()
                    self.dishPickerView.reloadAllComponents()
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    break
                }
            })
    }

}
