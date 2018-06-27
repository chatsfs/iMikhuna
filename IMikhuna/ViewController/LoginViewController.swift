//
//  LoginViewController.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 21/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var userToken : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        let email = emailTextField!.text
        let password = passwordTextField!.text
        if (email?.isEmpty)! || (password?.isEmpty)! {
            return
        } else if validateLogIn(email: email, password: password) == false{
            return
        }
        self.performSegue(withIdentifier: "showMain", sender: self)
    }
    func validateLogIn(email:String?,password:String?)->Bool{
        var pass = false
        let parameters:[String:Any] = ["email":email,"password":password]
        Alamofire.request(MikhunaApi.logInUrl, method: .post,parameters: parameters)
        .validate()
        .responseJSON(completionHandler: {response in
            switch (response.result){
            case .success(let value):
                let json = JSON(value)
                if json["hasError"].stringValue == "true"{
                    print("Response Error: \(json["message"].stringValue)")
                    pass = false
                    break
                }
                self.userToken = json["result"].arrayValue.map({$0["token"].stringValue})
                print(self.userToken[0])
                break
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                pass=false
                break
            }
        })
        return pass
    }

}
