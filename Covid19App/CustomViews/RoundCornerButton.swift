//
//  RoundCornerButton.swift
//  Covid19App
//
//  Created by Hishara on 9/15/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func generateRoundCorners(radius : Float){
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(radius)
    }
}
