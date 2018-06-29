//
//  SessionStore.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 26/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import CoreData
import Foundation
class SessionStore{
    let session = UserDefaults.standard
    var storeSession: Session? {
        get{
            let userId = session.string(forKey: "userId")
            let token = session.string(forKey: "token")
            if userId == nil && token == nil{
                return nil
            }
            return Session(userId!,token!)
        }
        set{
            if let session = newValue{
                self.session.set(session.userId, forKey: "userId")
                self.session.set(session.token, forKey: "token")
            }
        }
    }
    func logout(){
        self.session.removeObject(forKey: "userId")
        self.session.removeObject(forKey: "token")
    }
}
