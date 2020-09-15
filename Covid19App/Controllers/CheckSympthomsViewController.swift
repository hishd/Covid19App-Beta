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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        viewContainerCough.clipsToBounds = true
        viewContainerFever.clipsToBounds = true
        viewContainerSoreTroath.clipsToBounds = true
        viewContainerCough.layer.cornerRadius = 10
        viewContainerFever.layer.cornerRadius = 10
        viewContainerSoreTroath.layer.cornerRadius = 10
        btnUpdateCondition.generateRoundCorners(radius: 5)
        self.navigationController?.generateWhiteBackButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.generateGrayBackButton()
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
