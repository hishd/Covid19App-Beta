//
//  RegisterViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var btnAcademicStaff: UIButton!
    @IBOutlet weak var btnStudent: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNIC: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var imgProfilePic: UIImageView!
        
    var userRole: String = UserTypes.USER_TYPE_STAFF
    
    var imagePicker: ImagePicker!
    
    var firebaseOP = FirebaseOP()
    
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfilePic.generateRoundImageView()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        btnSignUp.generateRoundCorners(radius: 5)
        
        firebaseOP.delegate = self
        setTFDelegates()
        
        self.progressHUD = ProgressHUD(view: view)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onPickImageClicked))
        self.imgProfilePic.addGestureRecognizer(gesture)
        
    }
}

extension RegisterViewController {
    
    @IBAction func userRoleChanged(_ sender: UIButton) {
        btnStudent.isSelected = false
        btnAcademicStaff.isSelected = false
        sender.isSelected = true
        if sender.currentTitle == "Academic Staff" {
            userRole = UserTypes.USER_TYPE_STAFF
        } else {
            userRole = UserTypes.USER_TYPE_STUDENT
        }
    }
    
    @IBAction func onSignUpPressed(_ sender: Any) {
        let name = txtName.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let email = txtEmail.text ?? ""
        let nic = txtNIC.text ?? ""
        let pass = txtPassword.text ?? ""
        let confirmPass = txtConfirmPassword.text ?? ""
        
        if !FieldValidator.checkName(name) {
            txtName.text = ""
            txtName.attributedPlaceholder = NSAttributedString(string: "Enter a valid name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        if !FieldValidator.isValidEmail(email) {
            txtEmail.text = ""
            txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter a valid email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        if !FieldValidator.isValidNIC(nic) {
            txtNIC.text = ""
            txtNIC.attributedPlaceholder = NSAttributedString(string: "Enter a valid NIC no", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        if !FieldValidator.checkLength(pass, 6) {
            txtPassword.text = ""
            txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter a valid password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        if !(pass == confirmPass) {
            txtPassword.text = ""
            txtConfirmPassword.text = ""
            txtPassword.attributedPlaceholder = NSAttributedString(string: "Passwords don't match", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Passwords don't match", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        firebaseOP.signUpUser(name: name, email: email, nic: nic, password: pass, role: userRole, proPic: imgProfilePic.image)
        progressHUD.displayProgressHUD()
        
    }
    
    
    @objc func onPickImageClicked(_ sender: UIImageView){
        self.imagePicker.present(from: sender)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setTFDelegates() {
        self.txtName.delegate = self
        self.txtEmail.delegate = self
        self.txtNIC.delegate = self
        self.txtPassword.delegate = self
        self.txtConfirmPassword.delegate = self
    }
    
}

extension RegisterViewController : ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        
        if image == nil {
            self.imgProfilePic.image = UIImage(systemName: "person.circle.fill")
            return
        }
        
        self.imgProfilePic.image = image
    }
}

extension RegisterViewController : FirebaseActions {
    
    func isUserSignUpSuccessful() {
        progressHUD.dismissProgressHUD()
        let alert = AppPopUpDialogs.displayCustomAlert(title: "Sign up successful", message: "Registration successful you can now login through login page.");
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func isUserSignUpFailedwithError(error: Error) {
        progressHUD.dismissProgressHUD()
        print(error)
        self.present(AppPopUpDialogs.displayAlert(title: "Sign up error", message: error.localizedDescription), animated: true )
    }
}
