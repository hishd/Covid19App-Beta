//
//  KeyboadToorbar.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    
    func addToolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        let clearBtn = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(self.clearClicked))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClicked))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([clearBtn,space,doneBtn], animated: true)
        self.inputAccessoryView = toolBar
    }
    
    @objc func clearClicked(){
        self.text = ""
    }
    
    @objc func doneClicked(){
        self.endEditing(true)
    }
}
