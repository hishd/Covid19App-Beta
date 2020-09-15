//
//  ViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class LoginViewContoller: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.createTransparentNavBar()
        
        txtEmail.delegate = self
        txtEmail.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        btnSignIn.generateRoundCorners(radius: 5)
        // Do any additional setup after loading the view.
    }

}

extension LoginViewContoller : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

