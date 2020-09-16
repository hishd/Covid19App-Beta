//
//  UpdateViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var viewTempPicker: UIView!
    @IBOutlet weak var txtTemp: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var sliderTemprature: UISlider!
    @IBOutlet weak var viewCheckForSympthoms: UIView!
//    @IBOutlet weak var viewCheckSympthoms: UIImageView!
    
    var currentTemp = 28.0
    var Floatbtn = UIButton(type: .custom)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTempPicker.clipsToBounds = true
        viewTempPicker.layer.cornerRadius = 10
        viewCheckForSympthoms.clipsToBounds = true
        viewCheckForSympthoms.layer.cornerRadius = 10
        btnUpdate.generateRoundCorners(radius: 5)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.launchSurveyController))
        
        self.viewCheckForSympthoms.addGestureRecognizer(gesture)
        
        checkUserRoles()
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

extension UpdateViewController {
    
    @IBAction func sliderTempChanged(_ sender: UISlider) {
        
        if sender.value < 30 {
            UIView.animate(withDuration: 0.7){
                self.btnUpdate.backgroundColor = UIColor(named: "color_accent")
                self.txtTemp.textColor = UIColor(named: "color_accent")
                self.sliderTemprature.tintColor = UIColor(named: "color_accent")
            }
        } else if sender.value > 30 && sender.value < 35 {
            UIView.animate(withDuration: 0.7){
                self.btnUpdate.backgroundColor = UIColor(named: "color_yellow")
                self.txtTemp.textColor = UIColor(named: "color_yellow")
                self.sliderTemprature.tintColor = UIColor(named: "color_yellow")
            }
        } else if sender.value > 35 && sender.value < 40 {
            UIView.animate(withDuration: 0.7){
                self.btnUpdate.backgroundColor = UIColor(named: "color_orange")
                self.txtTemp.textColor = UIColor(named: "color_orange")
                self.sliderTemprature.tintColor = UIColor(named: "color_orange")
            }
        } else if sender.value > 40 && sender.value < 45 {
            UIView.animate(withDuration: 0.7){
                self.btnUpdate.backgroundColor = UIColor(named: "color_light_red")
                self.txtTemp.textColor = UIColor(named: "color_light_red")
                self.sliderTemprature.tintColor = UIColor(named: "color_light_red")
            }
        } else {
            UIView.animate(withDuration: 0.7){
                self.btnUpdate.backgroundColor = UIColor(named: "color_red")
                self.txtTemp.textColor = UIColor(named: "color_red")
                self.sliderTemprature.tintColor = UIColor(named: "color_red")
            }
        }
        
        txtTemp.text = String(format: "%.1f", sender.value) + " C"
    }
    
    
    func setFloatingNewsButton(){
        let navBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        Floatbtn.frame = CGRect(x: view.frame.size.width - 140, y: self.view.frame.size.height - navBarHeight - 65, width: 120, height: 40)
        Floatbtn.setTitle("Add news", for: .normal)
        Floatbtn.backgroundColor = UIColor(named: "color_accent")
        Floatbtn.clipsToBounds = true
        Floatbtn.layer.cornerRadius = 5
        Floatbtn.addTarget(self,action: #selector(onFloatingNewsButtonPressed), for: .touchUpInside)
        if let window = UIApplication.shared.windows.first {
            window.addSubview(Floatbtn)
        }
    }
    
    func checkAndEnableNewsFloatButton() {
        if let data : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userType){
            if data == UserTypes.USER_TYPE_STAFF {
                if let window = UIApplication.shared.windows.first {
                    window.addSubview(Floatbtn)
                }
            }
        }
    }
    
    @objc
    func onFloatingNewsButtonPressed(){
        self.present(AppPopUpDialogs.generateCreateNewsPopup(), animated: true)
    }
    
    func checkUserRoles(){
        AppUserDefaults.setUserDefault(data: UserTypes.USER_TYPE_STAFF, key: UserInfoStorage.userType)
        //        AppUserDefaults.removeUserDefault(key: UserInfoStorage.userType)
        
        if let data : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userType){
            if data == UserTypes.USER_TYPE_STAFF {
                setFloatingNewsButton()
            }
        }
    }
    
    @objc func launchSurveyController(sender : UITapGestureRecognizer) {
        self.performSegue(withIdentifier: AppSegues.updateToTakeSurvey, sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Floatbtn.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkAndEnableNewsFloatButton()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
