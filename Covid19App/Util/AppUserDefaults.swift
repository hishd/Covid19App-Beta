//
//  AppUserDefaults.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

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
    
}
