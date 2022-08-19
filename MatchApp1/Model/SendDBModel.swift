//
//  SendDBModel.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/17.
//

import Foundation
import Firebase

protocol ProfileSendDone {
    
    func profileSendDone()
    
}

protocol LikeSendDelegate {
    
    
     func like()
    
    
}

class SendDBModel {
    
    let db = Firestore.firestore()
    var profileSendDone:ProfileSendDone?
    var likeSendDelegate:LikeSendDelegate?
//    プロフィールをfirestoreへ送信
    func sendProfileData(userData:UserDataModel,profileImageData:Data){
        
        let imageRef = Storage.storage().reference().child("ProfileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        imageRef.putData(profileImageData, metadata: nil) { metaData, error in
            if error != nil {
                
                return
            }
            
            imageRef.downloadURL { url, error in
                if error !=  nil {
                    return
                    
                }
                
                if url != nil {
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["name" : userData.name as Any,"age" : userData.age as Any,"height" : userData.height as Any,"bloodType" : userData.bloodType as Any,"prefecture" : userData.prefecture as Any,"gender" : userData.gender as Any,"profile" : userData.profile as Any,"profileImageString" : url?.absoluteString as Any,"uid" : Auth.auth().currentUser!.uid as Any,"quickWord" : userData.quickWord as Any,"work" : userData.work as Any,"onlineORNot" : userData.onlineORNot as Any]){ error in
                        if let error = error {
                            
                            print(error)
                            
                        }
                        
                    }
                    
                }
                
                keyChainConfig.setKeyData(value: ["name" : userData.name as Any,"age" : userData.age as Any,"height" : userData.height as Any,"bloodType" : userData.bloodType as Any,"prefecture" : userData.prefecture as Any,"gender" : userData.gender as Any,"profile" : userData.profile as Any,"profileImageString" : url?.absoluteString as Any,"uid" : Auth.auth().currentUser!.uid as Any,"quickWord" : userData.quickWord as Any,"work" : userData.work as Any], key: "userData")
                
               
                
                self.profileSendDone?.profileSendDone()
                
            }
        }
    }
    
    
    func sendToLike(likeFlag:Bool,thisUserID:String) {
//        まだlikeをしていない状態、再びlikeをする前の状態
        if likeFlag == false {
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":false])
            
//            消す
            deleteToLike(thisUserID: thisUserID)
            
            var ownLikeListArray = keyChainConfig.getkeyArrayListData(key: "ownLikeList")
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            keyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
//            自分がlikeした人たちのID一覧が保存される
            print(ownLikeListArray.debugDescription)
            
        }else if likeFlag == true {
            
            let userData = keyChainConfig.getKeyArrayData(key: "userData")
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":true,"gender":userData["gender"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"height":userData["height"] as Any,"profileImageString":userData["profileImageString"] as Any,"prefecture":userData["prefecture"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"bloodType":userData["bloodType"] as Any,"work":userData["work"] as Any])
            
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).setData(["like":true,"gender":userData["gender"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"height":userData["height"] as Any,"profileImageString":userData["profileImageString"] as Any,"prefecture":userData["prefecture"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"bloodType":userData["bloodType"] as Any,"work":userData["work"] as Any])
            
            var ownLikeListArray = keyChainConfig.getkeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            keyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
//            likeが終わったよ
            
            self.likeSendDelegate?.like()
            
            
        }
                    
        
        
    }
    
    func deleteToLike(thisUserID:String){
        
        self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(thisUserID).delete()
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).delete()
    }
    
}

