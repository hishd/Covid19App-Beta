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
    
    var firebaseOP = FirebaseOP()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.createTransparentNavBar()
        
        firebaseOP.delegate = self
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        btnSignIn.generateRoundCorners(radius: 5)
        // Do any additional setup after loading the view.
    }

}

extension LoginViewContoller {
    
    @IBAction func btnSignInClicked(_ sender: Any) {
        let email = txtEmail.text ?? ""
        let password = txtPassword.text ?? ""
        
        if !FieldValidator.isValidEmail(email) {
            txtEmail.text = ""
            txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter a valid email address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        if !FieldValidator.checkLength(password, 6) {
            txtPassword.text = ""
            txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter a valid password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        firebaseOP.signInUser(email: email, pass: password)
        
    }
    
}

extension LoginViewContoller : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

extension LoginViewContoller : FirebaseActions {
    func isAuthenticationSuccessful(uid: String?) {
        print(uid ?? "")
    }
    
    func isAuthenticationFailedWithError(error: Error) {
        print(error.localizedDescription)
        self.present(AppPopUpDialogs.displayAlert(title: "Sign in error", message: error.localizedDescription), animated: true)
    }
}

