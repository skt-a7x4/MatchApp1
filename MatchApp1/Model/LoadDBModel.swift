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

class LoadDBModel {
    
    var db = Firestore.firestore()
    var profileModelArray = [UserDataModel]()
    var getprofileDataProtocol:GetprofileDataProtocol?
    var getLikeCountProtocol:GetLikeCountProtocol?
    
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
    
}
