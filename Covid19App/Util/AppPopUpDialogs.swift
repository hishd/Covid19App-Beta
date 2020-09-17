//
//  AppPopUpDialogs.swift
//  Covid19App
//
//  Created by Hishara on 9/15/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

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
            
            if let news = alert.textFields?.first {
                print(news.text ?? "")
            }
            
        }))
        
        return alert
    }
    
    static func displayAlert(title: String, message : String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    }
    
    static func displaySignInSuccessAlert(title: String, message : String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alert
    }
    
}

