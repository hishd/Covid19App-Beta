//
//  SurveyCell.swift
//  Covid19App
//
//  Created by Hishara on 9/18/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class SurveyCell: UITableViewCell {
    
    @IBOutlet weak var imgProPic: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtRole: UILabel!
    @IBOutlet weak var txtNIC: UILabel!
    @IBOutlet weak var txtUpdatedDate: UILabel!
    @IBOutlet weak var txtScore: UILabel!
    @IBOutlet weak var viewRoot: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(data : SurveyDataModel){
        viewRoot.clipsToBounds = true
        viewRoot.layer.cornerRadius = 10
        imgProPic.generateRoundImageView()
        imgProPic.kf.setImage(with: URL(string: data.profileURL))
        txtName.text = data.name
        txtRole.text = data.role
        txtNIC.text = data.nic
        txtUpdatedDate.text = data.date
        txtScore.text = String(data.score)
        
        if data.score < 4 {
            txtScore.textColor = #colorLiteral(red: 1, green: 0.9974951219, blue: 0.9899804876, alpha: 1)
        } else if data.score >= 4 && data.score <= 5 {
            txtScore.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        } else if data.score > 5 && data.score <= 7 {
            txtScore.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        } else if data.score == 8 {
           txtScore.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        } else {
            txtScore.textColor = #colorLiteral(red: 1, green: 0.1872055232, blue: 0.1020390898, alpha: 1)
        }
    }
    
}
