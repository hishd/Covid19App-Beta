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
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        imgProfilePic.generateRoundImageView()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onPickImageClicked))
        self.imgProfilePic.addGestureRecognizer(gesture)
        
        if let profileImageURL: String = AppUserDefaults.getUserDefault(key: UserInfoStorage.proPicURL) {
            imgProfilePic.kf.setImage(with: URL(string: profileImageURL))
        }
    }
    
    @IBAction func chaneNameClicked(_ sender: UIButton) {
    }
    @IBAction func changeEmailClicked(_ sender: UIButton) {
    }
    @IBAction func changePasswordClicked(_ sender: UIButton) {
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

}

extension SettingsViewController : ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        
        if image == nil {
            return
        }
        
        self.imgProfilePic.image = image
    }
}
