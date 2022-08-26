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

protocol GetAttachProtocol {
    
    func getAttachProtocol(attachImageString:String)
    
}

class SendDBModel {
    
    let db = Firestore.firestore()
    var profileSendDone:ProfileSendDone?
    var likeSendDelegate:LikeSendDelegate?
    var getAttachProtocol:GetAttachProtocol?
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
    
//    いいねをされたリストからのいいねをする場合のメソッド
    
    func sendToLikeFromLike(likeFlag:Bool,thisUserID:String,matchName:String,matchID:String){
        
        if likeFlag == false {
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":false])
            deleteToLike(thisUserID: thisUserID)
            var ownLikeListArray = keyChainConfig.getkeyArrayListData(key: "ownLikeList")
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            keyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            
        }else if likeFlag == true {
            
            let userData = keyChainConfig.getKeyArrayData(key: "userdata")
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":true,"gender":userData["gender"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"height":userData["height"] as Any,"profileImageString":userData["profileImageString"] as Any,"prefecture":userData["prefecture"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"bloodType":userData["bloodType"] as Any,"work":userData["work"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).setData(["like":true,"gender":userData["gender"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"height":userData["height"] as Any,"profileImageString":userData["profileImageString"] as Any,"prefecture":userData["prefecture"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"bloodType":userData["bloodType"] as Any,"work":userData["work"] as Any])
            
            var ownLikeListArray = keyChainConfig.getkeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            keyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
//            マッチングが成立した
            Util.matchiNotification(name: matchName, id: matchID)
            
//            マッチングしたら相手がいいねされましたに残り続けてしまうのでマッチングしたらここで消す
            deleteToLike(thisUserID: Auth.auth().currentUser!.uid)
            deleteToLike(thisUserID:matchID)
            self.db.collection("Users").document(matchID).collection("matching").document(matchID).delete()
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
            
            self.likeSendDelegate?.like()
        }
       
    }
    
    func sendToMatchingList(thisiUserID:String,name:String,age:String,bloodType:String,height:String,prefecture:String,gender:String,profile:String,profileImageString:String,uid:String,quickWord:String,work:String,userData:[String:Any]){
        
//        もしthiUserIDが自分ではなければ
        if thisiUserID == uid {
            

            
            self.db.collection("Users").document(thisiUserID).collection("matching").document(Auth.auth().currentUser!.uid).setData(["gender":userData["gender"] as Any,"uid":userData["uid"] as Any,"height":userData["height"] as Any,"profileImageString":userData["profileImageString"] as Any,"prefecture":userData["prefecture"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"bloodType":userData["bloodType"] as Any,"work":userData["work"] as Any])
            
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(thisiUserID).setData(["gender":gender as Any,"uid":uid as Any,"age":age as Any,"height":height as Any,"profileImageString":profileImageString as Any,"prefecture":prefecture as Any,"name":name as Any,"quickWord":quickWord as Any,"profile":profile as Any,"bloodType":bloodType as Any,"work":work as Any])
            
            
        }else{
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(thisiUserID).setData(["gender":gender as Any,"uid":uid as Any,"age":age as Any,"height":height as Any,"profileImageString":profileImageString as Any,"prefecture":prefecture as Any,"name":name as Any,"quickWord":quickWord as Any,"profile":profile as Any,"bloodType":bloodType as Any,"work":work as Any])
            
        }
        
        self.db.collection("Users").document(thisiUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(thisiUserID).delete()
        

        
        
    }
    
    func sendAshiato(aitenoUserID:String) {
        
        let userData = keyChainConfig.getKeyArrayData(key: "userData")
        
        self.db.collection("Users").document(aitenoUserID).collection("ashiato").document(Auth.auth().currentUser!.uid).setData(["gender":userData["gender"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"height":userData["height"] as Any,"profileImageString":userData["profileImageString"] as Any,"prefecture":userData["prefecture"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"bloodType":userData["bloodType"] as Any,"work":userData["work"] as Any,"date":Date().timeIntervalSince1970])
        
        
    }
    
    func sendImageData(image:UIImage,senderID:String,toID:String){
        
        let userData = keyChainConfig.getKeyArrayData(key: "userData")
        
        let imageRef = Storage.storage().reference().child("ChatImages").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        imageRef.putData(image.jpegData(compressionQuality: 0.3)!, metadata: nil) { metaData, error in
            if error != nil {
                
                return
            }
            
            imageRef.downloadURL { url, error in
                if error !=  nil {
                    return
                    
                }
                
                if url != nil {
                    self.db.collection("Users").document(senderID).collection("matching").document(toID).collection("chat").document().setData(["senderID":Auth.auth().currentUser!.uid,"displayName" : userData["name"] as Any,"imageURLString" : userData["profileImageString"] as Any,"date":Date().timeIntervalSince1970,"attachImageString":url?.absoluteString as Any]){ error in
                        if let error = error {
                            
                            print(error)
                            
                        }
                        
                        self.db.collection("Users").document(toID).collection("matching").document(senderID).collection("chat").document().setData(["senderID":Auth.auth().currentUser!.uid,"displayName" : userData["name"] as Any,"imageURLString" : userData["profileImageString"] as Any,"date":Date().timeIntervalSince1970,"attachImageString":url?.absoluteString as Any])
                        
                    }
                    
                    self.getAttachProtocol?.getAttachProtocol(attachImageString: url!.absoluteString)
                    
                }
                
               
                
            }
        }
        
    }
    
    func sendMessage(senderID:String,toID:String,text:String,displayName:String,imageURLString:String){
        
        self.db.collection("Users").document(senderID).collection("matching").document(toID).collection("chat").document().setData(["text":text as Any,"senderID":senderID as Any,"displayName":displayName as Any,"imageURLString":imageURLString as Any,"date:":Date().timeIntervalSince1970])
        
        self.db.collection("Users").document(toID).collection("matching").document(senderID).collection("chat").document().setData(["text":text as Any,"senderID":Auth.auth().currentUser!.uid as Any,"displayName":displayName as Any,"imageURLString":imageURLString as Any,"date:":Date().timeIntervalSince1970])
        
    }
    
}

