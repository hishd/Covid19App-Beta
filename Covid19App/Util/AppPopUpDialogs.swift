//
//  AppPopUpDialogs.swift
//  Covid19App
//
//  Created by Hishara on 9/15/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

/*
 
    Class which will create popup dialogs and return the isntances
 
 */

import Foundation
import UIKit

class AppPopUpDialogs {
    
    static func generateCreateNewsPopup() -> UIAlertController {
        let alert = UIAlertController(title: "Update News", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: {
            txtNewsContent in
            txtNewsContent.placeholder = "Enter news here"
        })
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            
//            if let news = alert.textFields?.first {
//                print(news.text ?? "")
//            }
            
        }))
        
        return alert
    }
    
    static func displayAlert(title: String, message : String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    }
    
    static func displayCustomAlert(title: String, message : String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alert
    }
    
    static func displayUserDataUpdatePopup(title: String, message: String, type : String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if type == "NAME" {
            alert.addTextField(configurationHandler: {
                txtNewsContent in
                txtNewsContent.placeholder = "Enter name here"
            })
        } else if type == "EMAIL" {
            alert.addTextField(configurationHandler: {
                txtNewsContent in
                txtNewsContent.placeholder = "Enter email here"
            })
        } else if type == "PASSWORD" {
            alert.addTextField(configurationHandler: {
                txtNewsContent in
                txtNewsContent.isSecureTextEntry = true
                txtNewsContent.placeholder = "Enter password"
            })
            alert.addTextField(configurationHandler: {
                txtNewsContent in
                txtNewsContent.isSecureTextEntry = true
                txtNewsContent.placeholder = "Re enter password"
            })
        }
        
        return alert
    }
    
}

