//
//  NewsCollectionViewCell.swift
//  Covid19App
//
//  Created by Hishara on 9/16/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblNewsContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class var reuseIdentifier: String {
        return "NewsCollectionViewCellReusableIdentifier"
    }
    class var nibName: String {
        return "NewsCollectionViewCell"
    }

    func configureCell(data: String) {
        self.lblNewsContent.text = data
    }

}
