//
//  RegisterViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnAcademicStaff: UIButton!
    @IBOutlet weak var btnStudent: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    var userRole: String = "academic staff"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfilePic.generateRoundImageView()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        btnSignUp.generateRoundCorners(radius: 5)
    }
    
    
    @IBAction func userRoleChanged(_ sender: UIButton) {
        btnStudent.isSelected = false
        btnAcademicStaff.isSelected = false
        sender.isSelected = true
        if sender.currentTitle == "Academic Staff" {
            userRole = "academic staff"
        } else {
            userRole = "student"
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
