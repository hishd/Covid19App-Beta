//
//  ViewSurveyResultsViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/18/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class ViewSurveyResultsViewController: UIViewController {
    
    @IBOutlet weak var tblData: UITableView!
    var surveyData : [SurveyDataModel] = []
    let firebaseOP = FirebaseOP()
    
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firebaseOP.delegate = self
        progressHUD = ProgressHUD(view: view)
        tblData.register(UINib(nibName: ResourceIdentifiers.cellNibName, bundle: nil), forCellReuseIdentifier: ResourceIdentifiers.cellIdentifier)
        
        firebaseOP.fetchSurveyData()
        progressHUD.displayProgressHUD()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func selectedFilterChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            for data in surveyData {
                
            }
        } else {
            
        }
    }

}

extension ViewSurveyResultsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblData.dequeueReusableCell(withIdentifier: ResourceIdentifiers.cellIdentifier, for: indexPath) as! SurveyCell
        cell.configureCell(data: surveyData[indexPath.row])
        return cell
    }
}

extension ViewSurveyResultsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ViewSurveyResultsViewController : FirebaseActions {
    func loadSurveyData(data: [SurveyDataModel]) {
        print(data)
        progressHUD.dismissProgressHUD()
        surveyData.removeAll()
        surveyData.append(contentsOf: data)
        tblData.reloadData()
    }
    func loadSurveyDataFailed(error: String) {
        progressHUD.dismissProgressHUD()
    }
}
