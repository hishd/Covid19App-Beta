//
//  AppConstraints.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import Foundation

struct AppSegues {
    static var loginToHomeController = "loginToHome"
    static var updateToTakeSurvey = "updateToTakeSurvey"
    static var splashToHome = "splashToHome"
    static var splashToLogin = "splashToLogin"
}

struct UserInfoStorage {
    static var userUID = "USER_UID"
    static var userEmail = "USER_EMAIL"
    static var userName = "USER_NAME"
    static var userNIC = "USER_NIC"
    static var userType = "USER_TYPE"
    static var userLogged = "USER_LOGGED"
    static var proPicURL = "PROFILE_PICTURE_URL"
    static var lastTemp = "LAST_TEMP"
}

struct UserTypes {
    static var USER_TYPE_STUDENT = "STUDENT"
    static var USER_TYPE_STAFF = "STAFF"
}

struct ResourceIdentifiers {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "SurveyCell"
}
