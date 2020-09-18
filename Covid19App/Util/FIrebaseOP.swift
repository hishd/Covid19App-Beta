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
        if let uid : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userUID), let name : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userName), let nic : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userNIC), let role : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userType), let proURL : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.proPicURL) {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let userdata = [
                "score" : score,
                "name" : name,
                "nic" : nic,
                "role" : role,
                "date" : formatter.string(from: Date()),
                "profileURL" : proURL
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
    
    func updateProfilePicture(image : UIImage?, email : String, uid : String){
        if let uploadData = image?.jpegData(compressionQuality: 0.5) {
            let ref = getStorageReference()
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            ref.child("images/user_images/").child(email).putData(uploadData, metadata: metaData) {
                (meta, error) in
                
                ref.child("images/user_images/").child(email).downloadURL(completion: {
                    (url,error) in
                    guard let downloadURL = url else {
                        self.delegate?.isUpdateFailed(error: "Failed to update profile picture")
                        return
                    }
                    
                    let dbRef = self.getDBReference()
                    dbRef.child("users").child(uid).child("profileUrl").setValue(downloadURL.absoluteString){
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            self.delegate?.isUpdateFailed(error: error)
                        } else {
                            self.delegate?.isUpdateSuccess()
                        }
                    }
                })
                
            }
            
        }
    }
    
    func publishNews(news : String){
        let ref = self.getDBReference()
        guard let key = ref.child("news").childByAutoId().key else {
            self.delegate?.isNewsAddingFailed(error : "Failed to generate news")
            return
        }
        ref.child("news").child(key).child("notification").setValue(news) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                self.delegate?.isNewsAddingFailed(error : error.localizedDescription)
            } else {
                self.delegate?.isNewNewsAdded()
            }
        }
    }
    
    func updateUserName(name : String, uid : String){
        let ref = self.getDBReference()
        ref.child("users").child(uid).child("name").setValue(name) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                self.delegate?.isUpdateFailed(error: error)
            } else {
                AppUserDefaults.setUserDefault(data: name, key: UserInfoStorage.userName)
                self.delegate?.isUpdateSuccess()
            }
        }
    }
    
    func updateUserEmail(email : String, uid : String){
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            if let error = error {
                self.delegate?.isUpdateFailed(error: error)
            } else {
                let ref = self.getDBReference()
                ref.child("users").child(uid).child("email").setValue(email) {
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        self.delegate?.isUpdateFailed(error: error)
                    } else {
                        AppUserDefaults.setUserDefault(data: email, key: UserInfoStorage.userEmail)
                        self.delegate?.isEmailOrPasswordUpdated()
                    }
                }
            }
        }
    }
    
    func updatePassword(password : String){
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if let error = error {
                self.delegate?.isUpdateFailed(error: error)
            } else {
                self.delegate?.isEmailOrPasswordUpdated()
            }
        }
    }
    
    func addTempData(uid: String, temperature: Double, lat: Double, lon: Double) {
        let ref = self.getDBReference()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let uid : String = AppUserDefaults.getUserDefault(key: UserInfoStorage.userUID) ?? ""
        
        let data = [
            "uid": uid,
            "temperature" : temperature,
            "lat" : lat,
            "lon" : lon,
            "lastUpdate" : formatter.string(from: Date())
        ] as [String : Any]
        ref.child("temperatureData").child(uid).setValue(data) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                self.delegate?.isTempratureDataAddingFailed(error: error)
            } else {
                self.delegate?.isTempratureDataAdded()
            }
        }
    }
    
    func loadNewsData(){
        var news : [String] = []
        let ref = self.getDBReference()
        var initialRead = true
        
        ref.child("news").observe(.childAdded, with: {
            snapshot in
            if initialRead == false {
                if let newsDict = snapshot.value as? [String : Any] {
                    let data = newsDict["notification"] as! String
                    news.append(data)
                }
                print(news)
                self.delegate?.onNewsDataLoaded(news: news)
            }
            
        })
        
        ref.child("news").observeSingleEvent(of: .value, with: { snapshot in
            
            initialRead = false
            
            if let newsDict = snapshot.value as? [String: Any] {
                for (_,value) in newsDict {
                    guard let innerDict = value as? [String: Any] else {
                        continue
                    }
                    news.append(innerDict["notification"] as! String)
                }
                print(news)
                self.delegate?.onNewsDataLoaded(news: news)
            }
        })
//        self.delegate?.onNewsDataLoaded(news: news)
    }
    
    func fetchTemperatureData(){
        var tempData : [TemperatureDataModel] = []
        let ref = self.getDBReference()
        
        ref.child("temperatureData").observeSingleEvent(of: .value, with: {
            (snapshot) in
//                print(snapshot)
            tempData.removeAll()
            if let tempDict = snapshot.value as? [String: Any] {
                for data in tempDict {
//                        print(data)
                    guard let innerData = data.value as? [String : Any] else {
                        continue
                    }
                    tempData.append(TemperatureDataModel(uid : innerData["uid"] as! String ,lastUpdate: innerData["lastUpdate"] as! String, lat: innerData["lat"] as! Double, lon: innerData["lon"] as! Double, temperature: innerData["temperature"] as! Double))
                }
                self.delegate?.onTempDataLoaded(tempData: tempData)
            }
        })
        
        ref.child("temperatureData").observe(.childChanged, with: { snapshot in
            ref.child("temperatureData").observeSingleEvent(of: .value, with: {
                (snapshot) in
//                print(snapshot)
                tempData.removeAll()
                if let tempDict = snapshot.value as? [String: Any] {
                    for data in tempDict {
//                        print(data)
                        guard let innerData = data.value as? [String : Any] else {
                            continue
                        }
                        tempData.append(TemperatureDataModel(uid : innerData["uid"] as! String ,lastUpdate: innerData["lastUpdate"] as! String, lat: innerData["lat"] as! Double, lon: innerData["lon"] as! Double, temperature: innerData["temperature"] as! Double))
                    }
                    self.delegate?.onTempDataLoaded(tempData: tempData)
                }
            })
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
    
    func isUpdateSuccess()
    func isUpdateFailed(error : Error)
    func isUpdateFailed(error : String)
    func isEmailOrPasswordUpdated()
    
    func isNewNewsAdded()
    func isNewsAddingFailed(error: String)
    
    func isTempratureDataAdded()
    func isTempratureDataAddingFailed(error: Error)
    
    func onNewsDataLoaded(news : [String])
    
    func onTempDataLoaded(tempData : [TemperatureDataModel])
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
    
    func isUpdateSuccess() {}
    
    func isUpdateFailed(error : Error) {}
    
    func isUpdateFailed(error : String) {}
    
    func isEmailOrPasswordUpdated(){}
    
    func isNewNewsAdded(){}
    
    func isNewsAddingFailed(error: String){}
    
    func isTempratureDataAdded() {}
    
    func isTempratureDataAddingFailed(error: Error) {}
    
    func onNewsDataLoaded(news : [String]) {}
    
    func onTempDataLoaded(tempData : [TemperatureDataModel]) {}
}
