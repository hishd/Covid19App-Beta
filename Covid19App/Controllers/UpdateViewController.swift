//
//  UpdateViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit
import CoreLocation

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var viewTempPicker: UIView!
    @IBOutlet weak var txtTemp: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var sliderTemprature: UISlider!
    @IBOutlet weak var viewCheckForSympthoms: UIView!
    //    @IBOutlet weak var viewCheckSympthoms: UIImageView!
    
    let locationManager = CLLocationManager()
    
    var pickedLattitude: Double = 0
    var pickedLonglitude: Double = 0
    
    var currentTemp : Double = 28
    
    var Floatbtn = UIButton(type: .custom)
    
    let firebaseOP = FirebaseOP()
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lastTemp : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.lastTemp){
            currentTemp = Double(lastTemp)!
        }
                
        viewTempPicker.clipsToBounds = true
        viewTempPicker.layer.cornerRadius = 10
        viewCheckForSympthoms.clipsToBounds = true
        viewCheckForSympthoms.layer.cornerRadius = 10
        btnUpdate.generateRoundCorners(radius: 5)
        
        firebaseOP.delegate = self
        
        progressHUD = ProgressHUD(view: view)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.launchSurveyController))
        
        self.viewCheckForSympthoms.addGestureRecognizer(gesture)
        
        checkUserRoles()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    @IBAction func temperatureUpdateClicked(_ sender: UIButton) {
        
        if pickedLattitude == 0 || pickedLonglitude == 0 {
            
            if let location = locationManager.location {
                pickedLattitude = location.coordinate.latitude
                pickedLonglitude = location.coordinate.longitude
            }
            
        }
        
        currentTemp = Double(String(format: "%.1f", sliderTemprature.value))!
        
        progressHUD.displayProgressHUD()
        
        firebaseOP.addTempData(uid: AppUserDefaults.getUserDefault(key: UserInfoStorage.userUID) ?? "", temperature: currentTemp, lat: pickedLattitude, lon: pickedLonglitude)
        
    }
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
        let alert = AppPopUpDialogs.displayUserDataUpdatePopup(title: "Add news", message: "Enter news content to publish", type: "EMAIL")
        
        let action = UIAlertAction(title: "Submit", style: .default, handler: {
            action in
            if let news = alert.textFields?.first {
                if let news = news.text {
                    self.progressHUD.displayProgressHUD()
                    self.firebaseOP.publishNews(news: news)
                }
            }
        })
        action.isEnabled = false;
        alert.addAction(action)
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alert.textFields?.first, queue: OperationQueue.main, using: {
            notification in
            
            if FieldValidator.isEmpty(alert.textFields?.first?.text ?? "") {
                action.isEnabled = false
                
                alert.message = "Enter a valid news"
            } else {
                action.isEnabled = true
                alert.message = "Click on add to submit"
            }
            
        })
        
        self.present(alert, animated: true)
    }
    
    func checkUserRoles(){
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
//        self.locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkAndEnableNewsFloatButton()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

extension UpdateViewController : FirebaseActions {
    
    func isNewNewsAdded() {
        self.progressHUD.dismissProgressHUD()
        self.present(AppPopUpDialogs.displayAlert(title: "News added", message: "New news published successfully"), animated: true)
    }
    
    func isNewsAddingFailed(error: String) {
        self.progressHUD.dismissProgressHUD()
        self.present(AppPopUpDialogs.displayAlert(title: "Publish failed", message: "Failed to publish new news"), animated: true)
    }
    
    func isTempratureDataAdded() {
        self.progressHUD.dismissProgressHUD()
        AppUserDefaults.setUserDefault(data: String(currentTemp), key: UserInfoStorage.lastTemp)
//        self.present(AppPopUpDialogs.displayAlert(title: "Data added", message: "Latest temperature data updated successfully"), animated: true)
    }
    
    func isTempratureDataAddingFailed(error: Error) {
        self.progressHUD.dismissProgressHUD()
        self.present(AppPopUpDialogs.displayAlert(title: "Update Failed", message: error.localizedDescription), animated: true)
    }
}

extension UpdateViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            if AppUserDefaults.getUserDefault(key: UserInfoStorage.userLogged) == false {
                self.locationManager.stopUpdatingLocation()
            }
            
            pickedLattitude = location.coordinate.latitude
            pickedLonglitude = location.coordinate.longitude
            self.firebaseOP.addTempData(uid: AppUserDefaults.getUserDefault(key: UserInfoStorage.userUID) ?? "", temperature: currentTemp, lat: pickedLattitude, lon: pickedLonglitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.present(AppPopUpDialogs.displayAlert(title: "Location error", message: error.localizedDescription), animated: true)
    }

}
