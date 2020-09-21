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

}

extension ViewSurveyResultsViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func selectedFilterChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            for i in (0..<surveyData.count){
                surveyData[i].dateString = formatter.date(from: surveyData[i].date)
            }
            
            surveyData = surveyData.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            tblData.reloadData()
        } else {
            surveyData =  surveyData.sorted(by: {
                $0.score > $1.score
            })
            tblData.reloadData()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
        UIView.animate(withDuration: 1, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1,
                       options: .curveEaseIn, animations: {
                        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
        })
    }
}

extension ViewSurveyResultsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ViewSurveyResultsViewController : FirebaseActions {
    func loadSurveyData(data: [SurveyDataModel]) {
        progressHUD.dismissProgressHUD()
        surveyData.removeAll()
        surveyData.append(contentsOf: data)
        surveyData =  surveyData.sorted(by: {
            $0.score > $1.score
        })
        tblData.reloadData()
    }
    func loadSurveyDataFailed(error: String) {
        progressHUD.dismissProgressHUD()
    }
}
