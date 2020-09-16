//
//  FIrebaseOP.swift
//  Covid19App
//
//  Created by Hishara on 9/16/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseOP {
    
    var delegate: FirebaseActions?
    
    func signInUser(email: String, pass: String){
        Auth.auth().signIn(withEmail: email, password: pass, completion: {
            authResult, error in
            
            if let error = error {
                self.delegate?.isAuthenticationFailedWithError(error: error)
            } else {
                self.delegate?.isAuthenticationSuccessful(uid: authResult?.user.uid)
            }
            
        })
    }
    
    func signUpUser(name: String, email: String, nic: String, password: String, role: String, proPic: UIImage?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            result, error in
            if let error = error {
                self.delegate?.isUserSignUpFailedwithError(error: error)
            } else {
                if let uid = result?.user.uid {
                    let userdata = ["uid" : uid,
                                    "name" : name,
                                    "email" : email,
                                    "nic" : nic,
                                    "profileUrl" : "URL",
                                    "role" : role]
//                    self.createUserInDB(data: userdata)
                    self.uploadProfilePicture(image: proPic, data: userdata)
                }
            }
        })
    }
    
    //MARK: - Class methods
    
    func getDBReference() -> DatabaseReference{
         return Database.database().reference()
    }
    
    func getStorageReference() -> StorageReference {
        return Storage.storage().reference()
    }
    
    func createUserInDB(data: Dictionary<String, String>){
        let ref = self.getDBReference()
        ref.child("users").child(data["role"] ?? "defaultRole").child(data["uid"] ?? "defaultUid").setValue(data) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                self.delegate?.isUserSignUpFailedwithError(error: error)
            } else {
                self.delegate?.isUserSignUpSuccessful()
            }
        }
    }
    
    func uploadProfilePicture(image: UIImage?, data: Dictionary<String, String>){
        if let uploadData = image?.jpegData(compressionQuality: 0.5) {
            let ref = getStorageReference()
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            ref.child("user_images").putData(uploadData, metadata: metaData) {
                (meta, error) in
                if let error = error {
                    self.delegate?.isUserSignUpFailedwithError(error: error)
                } else {
                    ref.downloadURL(completion: {
                        (url, error) in
                        if let error = error {
                            self.delegate?.isUserSignUpFailedwithError(error: error)
                        } else {
                            let imageUrl = url?.absoluteString
                            var userData = data
                            userData["profileUrl"] = imageUrl
                            self.createUserInDB(data: userData)
                        }
                    })
                }
            }
            
        }
    }
    
}


protocol FirebaseActions {
    func isAuthenticationSuccessful(uid: String?)
    func isAuthenticationFailedWithError(error: Error)
    
    func isUserSignUpSuccessful()
    func isUserSignUpFailedwithError(error: Error)
}

extension FirebaseActions {
    func isAuthenticationSuccessful(uid: String?){
        
    }
    
    func isAuthenticationFailedWithError(error: Error){
        
    }
    
    func isUserSignUpSuccessful(){
        
    }
    
    func isUserSignUpFailedwithError(error: Error){
        
    }
}
