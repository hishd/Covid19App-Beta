//
//  AppConstraints.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import Foundation

struct Segues {
    var loginToHomeController = "loginToHome"
}

struct UserInfoStorage {
    static var userEmail = "USER_EMAIL"
    static var userName = "USER_NAME"
    static var userNIC = "USER_NIC"
    static var userType = "USER_TYPE"
    static var userLogged = "USER_LOGGED"
}

struct UserTypes {
    static var USER_TYPE_STUDENT = "STUDENT"
    static var USER_TYPE_STAFF = "STAFF"
}
