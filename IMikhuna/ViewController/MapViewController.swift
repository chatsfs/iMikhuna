//
//  MapViewController.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 25/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var sessionStore : SessionStore = SessionStore()
    @IBAction func signOutAction(_ sender: Any) {
        sessionStore.logout()
        self.dismiss(animated: true)
    }


}
