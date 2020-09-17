//
//  SettingsViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit
import Kingfisher

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtRole: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    
    var imagePicker: ImagePicker!
    
    var firebaseOP = FirebaseOP()
    
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        imgProfilePic.generateRoundImageView()
        
        btnLogout.generateRoundCorners(radius: 6)
        
        firebaseOP.delegate = self
        self.progressHUD = ProgressHUD(view: view)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onPickImageClicked))
        self.imgProfilePic.addGestureRecognizer(gesture)
        
        if let profileImageURL: String = AppUserDefaults.getUserDefault(key: UserInfoStorage.proPicURL) {
            imgProfilePic.kf.setImage(with: URL(string: profileImageURL))
        }
        
        loadUserData()
    }

}

extension SettingsViewController {
    
    @IBAction func chaneNameClicked(_ sender: UIButton) {
        let alert = AppPopUpDialogs.displayUserDataUpdatePopup(title: "Update Name", message: "Enter new name to update", type: "NAME")
        
        let action = UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let name = alert.textFields?.first {
                
            }
        })
        action.isEnabled = false;
        alert.addAction(action)
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alert.textFields?.first, queue: OperationQueue.main, using: {
            notification in
            
            if !FieldValidator.checkName(alert.textFields?.first?.text ?? "") {
                action.isEnabled = false
                
                alert.message = "Enter a valid name"
            } else {
                action.isEnabled = true
                alert.message = "Click update to submit"
            }
            
        })
        
        self.present(alert, animated: true)
    }
    @IBAction func changeEmailClicked(_ sender: UIButton) {
        let alert = AppPopUpDialogs.displayUserDataUpdatePopup(title: "Update Email", message: "Enter new email to update", type: "EMAIL")
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let email = alert.textFields?.first {
                
            }
            
        }))
        self.present(alert, animated: true)
    }
    @IBAction func changePasswordClicked(_ sender: UIButton) {
        let alert = AppPopUpDialogs.displayUserDataUpdatePopup(title: "Update Password", message: "Enter new password to update", type: "PASSWORD")
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let pass = alert.textFields?.first, let confirmPass = alert.textFields?.last {
                
            }
            
        }))
        self.present(alert, animated: true)
    }
    @IBAction func viewSurveyResultsClicked(_ sender: UIButton) {
    }
    @IBAction func logoutClicked(_ sender: UIButton) {
        let alert = AppPopUpDialogs.displayCustomAlert(title: "Sign out", message: "Sign out from the application?")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: {
            action in
            
            AppUserDefaults.clearUserData()
            
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    @objc func onPickImageClicked(_ sender: UIImageView){
        self.imagePicker.present(from: sender)
    }
    
    func loadUserData(){
        txtUserName.text = AppUserDefaults.getUserDefault(key: UserInfoStorage.userName)
        txtEmail.text = AppUserDefaults.getUserDefault(key: UserInfoStorage.userEmail)
        txtRole.text = AppUserDefaults.getUserDefault(key: UserInfoStorage.userType)
    }
    
}

extension SettingsViewController : ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        
        if image == nil {
            return
        }
        
        progressHUD.displayProgressHUD()
        self.imgProfilePic.image = image
        if let image = image , let email : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userEmail), let uid : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userUID){
            firebaseOP.updateProfilePicture(image: image, email: email, uid: uid)
        }
    }
}

extension SettingsViewController : FirebaseActions {
    
    func isUpdateSuccess() {
        progressHUD.dismissProgressHUD()
        self.present(AppPopUpDialogs.displayAlert(title: "Update Successful", message: "Data updated successfully."), animated: true)
    }
    
    func isUpdateFailed(error: Error) {
        progressHUD.dismissProgressHUD()
        print(error)
        self.present(AppPopUpDialogs.displayAlert(title: "Error updating data", message: error.localizedDescription), animated: true)
    }
    
    func isUpdateFailed(error: String) {
        progressHUD.dismissProgressHUD()
        print(error)
        self.present(AppPopUpDialogs.displayAlert(title: "Error updating data", message: error), animated: true)
    }
    
}
