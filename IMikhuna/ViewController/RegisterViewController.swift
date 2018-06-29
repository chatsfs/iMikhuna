//
//  RegisterViewController.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 25/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegisterViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    var pass : String = ""
    
    let sessionStore = SessionStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func finishRegister(_ sender: UIButton) {
        let fullName = fullNameTextField!.text
        let email = emailTextField!.text
        let password = passwordTextField!.text
        let confirm = confirmTextField!.text
        
        if validateFields(fullName, email, password, confirm) == false {
            return
        } else if register(fullName as! String, email as! String, password as! String) == "false" {
            return
        }
        self.performSegue(withIdentifier: "showMainRegister", sender: self)
    }
    func validateFields(_ fullName: String?,_ email:String?,_ password:String?,_ confirm:String?) -> Bool{
        if (fullName?.isEmpty)! || (email?.isEmpty)! || (password?.isEmpty)! || (confirm?.isEmpty)! {
            return false
        } else if password != confirm {
            return false
        }
        return true
    }
    func register(_ fullName: String,_ email:String,_ password:String) -> String {
        let parameters:[String: Any] = ["fullName": fullName,"email": email,"password":password,"type":false]
        Alamofire.request(MikhunaApi.registerUrl, method: .post, parameters: parameters)
        .validate()
            .responseJSON(completionHandler: {response in
                switch (response.result){
                case .success(let value):
                    let json = JSON(value)
                    let hasError = json["hasError"].stringValue
                    if hasError == "true"{
                        print("Response Error: \(json["message"].stringValue)")
                        self.pass = hasError
                        break
                    }
                    self.pass = hasError
                    let userToken = json["result"]["token"].stringValue
                    let userId = json["result"]["userId"].stringValue
                    self.sessionStore.storeSession = Session(userId,userToken)
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.pass="false"
                    break
                }
            })
        return pass
    }
}
