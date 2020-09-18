//
//  AppUserDefaults.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

/*
 
    Class which will enable the application to store data which will be used for login etc.
 
 */

import Foundation

class AppUserDefaults {
    
    static func setUserDefault(data: String, key: String){
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func setUserDefault(data: Bool, key: String){
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func removeUserDefault(key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func getUserDefault(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func getUserDefault(key: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func getUserData() -> UserModel? {
        var user = UserModel()
        user.uid = UserDefaults.standard.string(forKey: UserInfoStorage.userUID) ?? ""
        user.name = UserDefaults.standard.string(forKey: UserInfoStorage.userName) ?? ""
        user.email = UserDefaults.standard.string(forKey: UserInfoStorage.userEmail) ?? ""
        user.nic = UserDefaults.standard.string(forKey: UserInfoStorage.userNIC) ?? ""
        user.role = UserDefaults.standard.string(forKey: UserInfoStorage.userType) ?? ""
        user.profileUrl = UserDefaults.standard.string(forKey: UserInfoStorage.proPicURL) ?? ""
        
        return user
    }
    
    static func saveUserData(user : UserModel) {
        UserDefaults.standard.set(user.uid, forKey: UserInfoStorage.userUID)
        UserDefaults.standard.set(user.name, forKey: UserInfoStorage.userName)
        UserDefaults.standard.set(user.email, forKey: UserInfoStorage.userEmail)
        UserDefaults.standard.set(user.nic, forKey: UserInfoStorage.userNIC)
        UserDefaults.standard.set(user.role, forKey: UserInfoStorage.userType)
        UserDefaults.standard.set(user.profileUrl, forKey: UserInfoStorage.proPicURL)
        UserDefaults.standard.set(true, forKey: UserInfoStorage.userLogged)
    }
    
    static func clearUserData() {
        UserDefaults.standard.removeObject(forKey: UserInfoStorage.userUID)
        UserDefaults.standard.removeObject(forKey: UserInfoStorage.userName)
        UserDefaults.standard.removeObject(forKey: UserInfoStorage.userEmail)
        UserDefaults.standard.removeObject(forKey: UserInfoStorage.userType)
        UserDefaults.standard.removeObject(forKey: UserInfoStorage.proPicURL)
        UserDefaults.standard.removeObject(forKey: UserInfoStorage.lastTemp)
        UserDefaults.standard.set(false, forKey: UserInfoStorage.userLogged)
    }
}
