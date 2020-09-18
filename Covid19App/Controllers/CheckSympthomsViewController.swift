//
//  CheckSympthomsViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/15/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit


class CheckSympthomsViewController: UIViewController {
    
    @IBOutlet weak var viewContainerCough: UIView!
    @IBOutlet weak var viewContainerFever: UIView!
    @IBOutlet weak var viewContainerSoreTroath: UIView!
    @IBOutlet weak var btnUpdateCondition: UIButton!
    
    @IBOutlet weak var segmentCough: UISegmentedControl!
    @IBOutlet weak var segmentfever: UISegmentedControl!
    @IBOutlet weak var segmentSoreTroath: UISegmentedControl!
    
//    let locationManager = CLLocationManager()
//
//    var pickedLattitude: Double = 0
//    var pickedLonglitude: Double = 0
    
    let scoreScale = [1,2,3]
    
    var firebaseOP = FirebaseOP()
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.createTransparentNavBar()
        viewContainerCough.clipsToBounds = true
        viewContainerFever.clipsToBounds = true
        viewContainerSoreTroath.clipsToBounds = true
        viewContainerCough.layer.cornerRadius = 10
        viewContainerFever.layer.cornerRadius = 10
        viewContainerSoreTroath.layer.cornerRadius = 10
        btnUpdateCondition.generateRoundCorners(radius: 5)
        self.navigationController?.generateWhiteBackButton()
        
        firebaseOP.delegate = self
        progressHUD = ProgressHUD(view: view)
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 200
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.generateGrayBackButton()
//        self.locationManager.stopUpdatingLocation()
    }

    
    @IBAction func updateClicked(_ sender: UIButton) {
        let score = scoreScale[segmentCough.selectedSegmentIndex] + scoreScale[segmentfever.selectedSegmentIndex] + scoreScale[segmentSoreTroath.selectedSegmentIndex]
        
        firebaseOP.storeSympthomsData(score: score)
        
        progressHUD.displayProgressHUD()
    }
    
}

//extension CheckSympthomsViewController : CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            pickedLattitude = location.coordinate.latitude
//            pickedLonglitude = location.coordinate.longitude
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        self.present(AppPopUpDialogs.displayAlert(title: "Location error", message: error.localizedDescription), animated: true)
//    }
//
//}

extension CheckSympthomsViewController : FirebaseActions {
    
    func isSympthomsUpdated() {
        progressHUD.dismissProgressHUD()
        self.present(AppPopUpDialogs.displayAlert(title: "Sympthoms Updated", message: "Latest sympthoms data updated"), animated: true)
    }
    
    func isSympthomsUpdateFailed(error: Error) {
        progressHUD.dismissProgressHUD()
        print(error)
        self.present(AppPopUpDialogs.displayAlert(title: "Faild to update", message: error.localizedDescription), animated: true)
    }
    
    func isSympthomsUpdateFailed(error: String) {
        progressHUD.dismissProgressHUD()
        print(error)
        self.present(AppPopUpDialogs.displayAlert(title: "Faild to update", message: error), animated: true)
    }
    
}
