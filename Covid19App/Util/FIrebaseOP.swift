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
    
    func getUserData(uid : String?) {
        let ref = getDBReference()
        if let uid = uid {
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: {
                (snapshot) in
                
                if let userDict = snapshot.value as? [String:String] {
                    self.delegate?.isUserDataLoaded(
                        user: UserModel(
                            email: userDict["email"]!,
                            name: userDict["name"]!,
                            nic: userDict["nic"]!,
                            profileUrl: userDict["profileUrl"]!,
                            role: userDict["role"]!,
                            uid: userDict["uid"]!)
                    )
                }  else {
                    self.delegate?.isUserDataLoadFailed(error: "Failed to retrieve usee data")
                }
            }) { (error) in
                self.delegate?.isUserDataLoadFailed(error: error)
            }
        } else {
            self.delegate?.isUserDataLoadFailed(error: "Failed to retrieve usee data")
        }
    }
    
    func storeSympthomsData(score: Int) {
        let ref = getDBReference()
        if let uid : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userUID), let name : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userName), let nic : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userNIC), let role : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userType) {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let userdata = [
                "score" : score,
                "name" : name,
                "nic" : nic,
                "role" : role,
                "date" : formatter.string(from: Date())
                ] as [String : Any]
            ref.child("userData").child(uid).setValue(userdata) {
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    self.delegate?.isSympthomsUpdateFailed(error: error)
                } else {
                    self.delegate?.isSympthomsUpdated()
                }
            }
        } else {
            self.delegate?.isSympthomsUpdateFailed(error: "Faild to update latest sympthoms")
        }
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
        ref.child("users").child(data["uid"] ?? "defaultUid").setValue(data) {
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
            
            ref.child("images/user_images/").child(data["email"]!).putData(uploadData, metadata: metaData) {
                (meta, error) in
                
                ref.child("images/user_images/").child(data["email"]!).downloadURL(completion: {
                    (url,error) in
                    guard let downloadURL = url else {
                        let user = Auth.auth().currentUser
                        
                        user?.delete(completion: {
                            error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        })
                        
                        return
                    }
                    
                    let imageUrl = downloadURL.absoluteString
                    var userData = data
                    userData["profileUrl"] = imageUrl
                    self.createUserInDB(data: userData)
                    
                })
                
            }
            
        }
    }
    
}


protocol FirebaseActions {
    func isAuthenticationSuccessful(uid: String?)
    func isAuthenticationFailedWithError(error: Error)
    
    func isUserSignUpSuccessful()
    func isUserSignUpFailedwithError(error: Error)
    
    func isUserDataLoaded(user : UserModel)
    func isUserDataLoadFailed(error : Error)
    func isUserDataLoadFailed(error : String)
    
    func isSympthomsUpdated()
    func isSympthomsUpdateFailed(error : Error)
    func isSympthomsUpdateFailed(error : String)
}

extension FirebaseActions {
    func isAuthenticationSuccessful(uid: String?){}
    
    func isAuthenticationFailedWithError(error: Error){}
    
    func isUserSignUpSuccessful(){}
    
    func isUserSignUpFailedwithError(error: Error){}
    
    func isUserDataLoaded(user : UserModel) {}
    
    func isUserDataLoadFailed(error : Error) {}
    
    func isUserDataLoadFailed(error : String) {}
    
    func isSympthomsUpdated() {}
    
    func isSympthomsUpdateFailed(error : Error) {}
    
    func isSympthomsUpdateFailed(error : String) {}
}
