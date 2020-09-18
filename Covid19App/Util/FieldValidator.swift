//
//  FieldValidator.swift
//  Covid19App
//
//  Created by Hishara on 9/16/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

/*
 
    Class which will be used to validate the textfield data
 
 */

import Foundation

class FieldValidator {
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return emailPred.evaluate(with: email)
    }
    
    static func checkLength(_ text: String, _ count: Int) -> Bool{
        
        let regex = "[A-Za-z0-9]{\(count),}"
        let compRegex = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return compRegex.evaluate(with: text)
    }
    
    static func checkName(_ name: String) -> Bool{
        let regEx = "[A-Za-z ]{2,50}"
        let compRegex = NSPredicate(format: "SELF MATCHES %@", regEx)
        return compRegex.evaluate(with: name)
    }
    
    static func isEmpty(_ text: String) -> Bool {
        if text == ""{
            return true
        }else{
            return false
        }
    }
    
    static func isValidNIC(_ nic: String) -> Bool {
        let NICRegEx = "^([0-9]{9}[x|X|v|V]|[0-9]{12})$"
        let NicPred = NSPredicate(format:"SELF MATCHES %@", NICRegEx)

        return NicPred.evaluate(with: nic)
    }
    
    static func isEqual(_ one: String, _ two: String) -> Bool {
        if(one == two){
            return true
        }else{
            return false
        }
    }
    
}
