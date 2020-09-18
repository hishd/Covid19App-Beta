//
//  HomeViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionViewNews: UICollectionView!
    @IBOutlet weak var mapKit: MKMapView!
    
    let firebaseOP = FirebaseOP()
    
    let locationManager = CLLocationManager()
    
    var myLocation : CustomMapMarker!
    
    var pickedLattitude: Double = 0
    var pickedLonglitude: Double = 0
    
    var news : [String] = []
    var tempData : [TemperatureDataModel] = []
    
    var delegate : UserStatActions?
    
    var infected: Int = 0
    var nonInfected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        addBottonStatView()
        registerNib()
        firebaseOP.delegate = self
        firebaseOP.loadNewsData()
        firebaseOP.fetchTemperatureData()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        mapKit.delegate = self
        mapKit.showsUserLocation = true
        
        myLocation = CustomMapMarker(coor: CLLocationCoordinate2D(latitude: pickedLattitude, longitude: pickedLonglitude))
    }

}

extension HomeViewController {
    
    func addBottonStatView() {
        let bottomSheetVC = StatBottomBarViewController()
        self.delegate = bottomSheetVC
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
    }
    
    func refreshMapData(){
        infected = 0
        nonInfected = 0

        DispatchQueue.main.async {
            for data in self.tempData{
                
                if data.temperature < 35 {
                    self.nonInfected+=1
                } else {
                    self.infected+=1
                }
                
                if data.uid == AppUserDefaults.getUserDefault(key: UserInfoStorage.userUID) {
                    self.mapKit.addAnnotation(self.myLocation)
                    continue
                }
                
                let coord = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lon)
                let pin = CustomMapMarker(coor: coord)
                
                if data.temperature < 35 {
                    pin.title = "NORMAL"
                } else {
                    pin.title = "SEVERE"
                }
                
                self.mapKit.addAnnotation(pin)
            }
            
            self.delegate?.onStatLoadedorRefreshed(infected: self.infected, nonInfected: self.nonInfected)
        }
        
    }
    
    func registerNib() {
        let nib = UINib(nibName: NewsCollectionViewCell.nibName, bundle: nil)
        collectionViewNews?.register(nib, forCellWithReuseIdentifier: NewsCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.collectionViewNews?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }

    
    @IBAction func locateClicked(_ sender: UIButton) {
        if pickedLattitude == 0 || pickedLonglitude == 0 {
            
            if let location = locationManager.location {
                let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapKit.setRegion(viewRegion, animated: true)
            }
            
        } else {
            let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pickedLattitude, longitude: pickedLonglitude), latitudinalMeters: 500, longitudinalMeters: 500)
            mapKit.setRegion(viewRegion, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    
}

extension HomeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionViewNews.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.reuseIdentifier,
                                                             for: indexPath) as? NewsCollectionViewCell {
            let name = news[indexPath.row]
            cell.configureCell(data: name)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.present(AppPopUpDialogs.displayAlert(title: "News", message: news[indexPath.row]), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      cell.alpha = 0
      cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      UIView.animate(withDuration: 0.25) {
        cell.alpha = 1
        cell.transform = .identity
      }
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: NewsCollectionViewCell = Bundle.main.loadNibNamed(NewsCollectionViewCell.nibName,
                                                                          owner: self,
                                                                          options: nil)?.first as? NewsCollectionViewCell else {
                                                                            return CGSize.zero
        }
        cell.configureCell(data: news[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 120)
    }
    
}

extension HomeViewController : FirebaseActions {
    
    func onNewsDataLoaded(news: [String]) {
        self.news = news
        DispatchQueue.main.async {
            self.collectionViewNews.reloadData()
            self.collectionViewNews.scrollToItem(at:IndexPath(item: news.count-1, section: 0), at: .right, animated: true)
        }
    }
    
    func onTempDataLoaded(tempData: [TemperatureDataModel]) {
        self.tempData.removeAll()
        self.mapKit.removeAnnotations(mapKit.annotations)
        self.tempData.append(contentsOf: tempData)

        self.refreshMapData()
    }
    
}

extension HomeViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            mapKit.removeAnnotation(myLocation)
            myLocation = CustomMapMarker(coor: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            myLocation.title = "ME"
            self.mapKit.addAnnotation(myLocation)
            
            pickedLattitude = location.coordinate.latitude
            pickedLonglitude = location.coordinate.longitude
            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapKit.setRegion(viewRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.present(AppPopUpDialogs.displayAlert(title: "Location error", message: error.localizedDescription), animated: true)
    }
    
}

extension HomeViewController : MKMapViewDelegate {
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

protocol UserStatActions {
    func onStatLoadedorRefreshed(infected: Int, nonInfected: Int)
}
