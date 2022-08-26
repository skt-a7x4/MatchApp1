//
//  File.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/18.
//

import Foundation
import Firebase

protocol GetprofileDataProtocol {
    
    func getprofileData(userDataModelArray:[UserDataModel])
    
}

protocol GetLikeCountProtocol{
    
    func getLikeCount(likeCount:Int,likeFlag:Bool)
    
}

protocol GetLikeDataProtocol{
    
    func getLikeDataProtocol(userDataModelArray:[UserDataModel])
    
}

protocol GetWhoisMatchListProtocol {
    
    func getWhoisMatchListProtocol(userDataModelArray:[UserDataModel])
    
    
}

protocol GetAshiatoDataProtcol {
    
    func getAshiatoDataProtcol(userDataModelArray:[UserDataModel])
    
}

class LoadDBModel {
    
    var db = Firestore.firestore()
    var profileModelArray = [UserDataModel]()
    var matchingIDArray = [String]()
    var getprofileDataProtocol:GetprofileDataProtocol?
    var getLikeCountProtocol:GetLikeCountProtocol?
    var getLikeDataProtocol:GetLikeDataProtocol?
    var getWhoisMatchListProtocol:GetWhoisMatchListProtocol?
    var getAshiatoDataProtcol:GetAshiatoDataProtcol?
    
//    ユーザーデータを受信する。ただし性別別に受信する
    func loadUsersProfile(gender:String){
//        ユーザーの逆の性別を受信するメソッド※isNotEqualTo
        db.collection("Users").whereField("gender", isNotEqualTo: gender).addSnapshotListener { snapShot, error in
            if error != nil {
                
                print(error.debugDescription)
                return
            }

// if snapShot != nil {
//
//            print(snapShot.debugDescription)
//            return
//        }
            //        上記のように記載してもしいが上記のように記載してまうとデータがロードできたことは確認できるが再度データの変数を作らないといけない為下記のように記載するとデータがきていることも確認でき変数をsnapShotDocという変数に入れることもできるので変数を作らなくても良くなる
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let height = data["height"] as? String,let bloodType = data["bloodType"] as? String,let prefecture = data["prefecture"] as? String,let gender = data["gender"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String,let onlineORNot = data["onlineORNot"] as? Bool,let work = data["work"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineORNot: onlineORNot)
                        
                        self.profileModelArray.append(userDataModel)
                    }
                    
                }
                
                self.getprofileDataProtocol?.getprofileData(userDataModelArray: self.profileModelArray)
                
            }
        }
        
        
    }
    
//    likeの数を取得するメソッドを書く
    func loadLikeCount(uuid:String) {
        
        var likeFlag = Bool()
        db.collection("Users").document(uuid).collection("like").addSnapshotListener { snapShot, error in
            if error != nil {
                return
            
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    if doc.documentID == Auth.auth().currentUser?.uid {
                        if let like = data["like"] as? Bool {
                            
                            likeFlag = like
                            
                        }
                        
                        
                    }
                    
                }
                
                let docCount = snapShotDoc.count
                self.getLikeCountProtocol?.getLikeCount(likeCount: docCount, likeFlag: likeFlag)
                
            }
                
            
        }
        
        
        
    }
    
    func loadLikeList(){
        
        
//        self.profileModelArray = []
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").addSnapshotListener { snapShot, error in
            
        
            if error != nil {
                
                print(error.debugDescription)
                return
            }

// if snapShot != nil {
//
//            print(snapShot.debugDescription)
//            return
//        }
            //        上記のように記載してもしいが上記のように記載してまうとデータがロードできたことは確認できるが再度データの変数を作らないといけない為下記のように記載するとデータがきていることも確認でき変数をsnapShotDocという変数に入れることもできるので変数を作らなくても良くなる
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let height = data["height"] as? String,let bloodType = data["bloodType"] as? String,let prefecture = data["prefecture"] as? String,let gender = data["gender"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String,let work = data["work"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineORNot: true)
                        
                        self.profileModelArray.append(userDataModel)
                    }
                    
                }
                
                self.getLikeDataProtocol?.getLikeDataProtocol(userDataModelArray: self.profileModelArray)
                
            }
        }
        
        
    }
    
//    matching以下のデータ(人)を取得する
    func loadMatchingPersonData(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").addSnapshotListener { snapShot, error in
            if error != nil {
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let height = data["height"] as? String,let bloodType = data["bloodType"] as? String,let prefecture = data["prefecture"] as? String,let gender = data["gender"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String,let work = data["work"] as? String{
                        
                        self.matchingIDArray = keyChainConfig.getkeyArrayListData(key: "matchingID")
//                        このIDを含んでいないなら
                        if self.matchingIDArray.contains(where: {$0 == uid}) == false{
                            if uid == Auth.auth().currentUser?.uid{
                                
                                self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
                                
                                
                            }else{
                            
                            
                            Util.matchiNotification(name: name, id: uid)
                                self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
                                
                            
                            self.matchingIDArray.append(uid)
                            keyChainConfig.setKeyArrayData(value: self.matchingIDArray, key: "matchingID")
                            }
                        }
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineORNot: true)
                        self.profileModelArray.append(userDataModel)
                    }
                    
                }
                
                self.getWhoisMatchListProtocol?.getWhoisMatchListProtocol(userDataModelArray: self.profileModelArray)
                
            }
            
        }
        
        
    }
    
    func loadAsiatoData(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ashiato").order(by: "date").addSnapshotListener { snapShot, error in
            if error != nil {
                
                return
                
            }
            if let snapShotDoc = snapShot?.documents {
                self.profileModelArray = []
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                   if let name = data["name"] as? String,let age = data["age"] as? String,let height = data["height"] as? String,let bloodType = data["bloodType"] as? String,let prefecture = data["prefecture"] as? String,let gender = data["gender"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String,let work = data["work"] as? String,let date = ["date"] as? Double{
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: date, onlineORNot: true)
                       
                       self.profileModelArray.append(userDataModel)
                        
                    }
                    
                }
                
                self.getAshiatoDataProtcol?.getAshiatoDataProtcol(userDataModelArray: self.profileModelArray)
                
                
            }
            
        }
        
        
    }
    
    
}
