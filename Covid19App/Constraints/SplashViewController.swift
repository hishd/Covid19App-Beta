//
//  SplashViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/17/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.createTransparentNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Thread.sleep(forTimeInterval: 2)
        
        if let logged : Bool = AppUserDefaults.getUserDefault(key: UserInfoStorage.userLogged) {
            
            if logged {
                performSegue(withIdentifier: AppSegues.splashToHome, sender: nil)
            } else {
                performSegue(withIdentifier: AppSegues.splashToLogin, sender: nil)
            }
            
        }
    }
}
