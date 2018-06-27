//
//  MikhunaApi.swift
//  IMikhuna
//
//  Created by Raul Bigoria Escobedo on 26/06/18.
//  Copyright © 2018 Raul Bigoria Escobedo. All rights reserved.
//

import Foundation
class MikhunaApi{
    static let baseUrl = "http://mikhunaservices.us-east-2.elasticbeanstalk.com/"
    public static var logInUrl: String {
        return "\(baseUrl)api/session"
    }
}
