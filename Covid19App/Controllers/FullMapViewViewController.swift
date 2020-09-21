//
//  FullMapViewViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/18/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit
import MapKit

class FullMapViewViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewExposedArea: UIView!
    
    let firebaseOP = FirebaseOP()
    
    let locationManager = CLLocationManager()
    
    var myLocation : CustomMapMarker!
    
    var pickedLattitude: Double = 0
    var pickedLonglitude: Double = 0
    
    var news : [String] = []
    var tempData : [TemperatureDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        viewExposedArea.isHidden = true
        firebaseOP.delegate = self
        firebaseOP.fetchTemperatureData()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        myLocation = CustomMapMarker(coor: CLLocationCoordinate2D(latitude: pickedLattitude, longitude: pickedLonglitude))
        
    }
}

extension FullMapViewViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func locateClicked(_ sender: UIButton) {
        
        if pickedLattitude == 0 || pickedLonglitude == 0 {
            
            if let location = locationManager.location {
                let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(viewRegion, animated: true)
            }
            
        } else {
            let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pickedLattitude, longitude: pickedLonglitude), latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    func refreshMapData(){
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.7){
                self.viewExposedArea.isHidden = true
            }
            
            let currentCoord = CLLocation(latitude: self.pickedLattitude, longitude: self.pickedLonglitude)
            
            for data in self.tempData{
                
                if data.uid == AppUserDefaults.getUserDefault(key: UserInfoStorage.userUID) {
                    self.mapView.addAnnotation(self.myLocation)
                    continue
                }
                
                let coord = CLLocation(latitude: data.lat, longitude: data.lon)
                let pin = CustomMapMarker(coor: coord.coordinate)
                
                if data.temperature < 35 {
                    pin.title = "NORMAL"
                } else {
                    pin.title = "SEVERE"
                    if currentCoord.distance(from: coord) < 1000 {
                        print(currentCoord.distance(from: coord))
                        UIView.animate(withDuration: 0.7){
                            self.viewExposedArea.isHidden = false
                        }
                    } else {
                        print("Not in range")
                        print(currentCoord)
                    }
                }
                
                
                UIView.animate(withDuration: 0.7){
                    
                }
                
                self.mapView.addAnnotation(pin)
            }
            
        }
        
    }
    
}

extension FullMapViewViewController : FirebaseActions {
    
    func onTempDataLoaded(tempData: [TemperatureDataModel]) {
        self.tempData.removeAll()
        self.mapView.removeAnnotations(mapView.annotations)
        self.tempData.append(contentsOf: tempData)
        self.refreshMapData()
    }
    
}

extension FullMapViewViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            mapView.removeAnnotation(myLocation)
            myLocation = CustomMapMarker(coor: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            myLocation.title = "ME"
            self.mapView.addAnnotation(myLocation)
            
            pickedLattitude = location.coordinate.latitude
            pickedLonglitude = location.coordinate.longitude
            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(viewRegion, animated: true)
            
            refreshMapData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.present(AppPopUpDialogs.displayAlert(title: "Location error", message: error.localizedDescription), animated: true)
    }
    
}

extension FullMapViewViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        if annotation.title == "SEVERE" {
            annotationView.image =  #imageLiteral(resourceName: "dot_red")
        }
        
        if annotation.title == "NORMAL" {
            annotationView.image =  #imageLiteral(resourceName: "dot_green")
        }
        
        if annotation.title == "ME" {
            annotationView.image = #imageLiteral(resourceName: "my_location")
        }

        annotationView.canShowCallout = true
        return annotationView
    }
    
}


