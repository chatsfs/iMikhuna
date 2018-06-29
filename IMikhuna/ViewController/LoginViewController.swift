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
    
    var pass : String = ""
    
    let sessionStore = SessionStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if self.sessionStore.storeSession != nil {
            self.performSegue(withIdentifier: "showMainLogin", sender: self)
        }
    }
    @IBAction func logIn(_ sender: UIButton) {
        let email = emailTextField!.text
        let password = passwordTextField!.text
        if (email?.isEmpty)! || (password?.isEmpty)! {
            return
        }
        print("Validate Login")
        validateLogInRequest(email: email as! String, password: password as! String)
        
    }
    
    @IBAction func register(_ sender: UIButton) {
        performSegue(withIdentifier: "showRegister", sender: self)
    }
    
    
    func validateLogInRequest(email:String,password:String) -> String{
        
        let parameters:[String:Any] = ["email":email,"password":password]
        
        Alamofire.request(MikhunaApi.logInUrl, method: .post,parameters: parameters)
        .validate()
        .responseJSON(completionHandler: {response in
            switch (response.result){
            case .success(let value):
                let json = JSON(value)
                let hasError = json["hasError"].stringValue
                if  hasError == "true" {
                    print("Response Error: \(json["message"].stringValue)")
                    self.sessionStore.storeSession = nil
                    self.pass = String(hasError)
                    break
                }
                self.pass = hasError
                let userToken = json["result"]["token"].stringValue
                let userId = json["result"]["userId"].stringValue
                self.sessionStore.storeSession = Session(userId,userToken)
                self.performSegue(withIdentifier: "showMainLogin", sender: self)
                break
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.pass="false"
                break
            }
        })
        return self.pass as! String
    }

}
