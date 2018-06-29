//
//  MikhunaApi.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 26/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import Foundation
class MikhunaApi{
    static let baseUrl = "http://mikhunaservices.us-east-2.elasticbeanstalk.com/api"
    public static var logInUrl: String {
        return "\(baseUrl)/session"
    }
    public static var registerUrl: String {
        return "\(baseUrl)/users"
    }
    func subscriptUrl(_ userId:String) -> String {
        return "http://mikhunaservices.us-east-2.elasticbeanstalk.com/api/users/\(userId)/subscriptions"
    }
}
