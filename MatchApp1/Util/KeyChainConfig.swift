//
//  KeyChainConfig.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/18.
//

import Foundation
import KeychainSwift

class keyChainConfig {
    
//    userdefaults
    
    static func getKeyData(key:String) -> String {
        
        let keychain = KeychainSwift()
        let keyString = keychain.get(key)
        return keyString!
        
    }
    
    
    static func setKeyData(value:[String:Any],key:String){
        
        let keychain = KeychainSwift()
//        配列をデータ化
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        keychain.set(archivedData, forKey: key)
    }
    
    static func getKeyArrayData(key:String) -> [String:Any]{
        
        let keychain = KeychainSwift()
        let keyData = keychain.getData(key)
        if keyData != nil {
            
            let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyData!) as! [String:Any]
            return unarchivedObject
            
            
        }else{
            
            return [:]
        }
        
    }
    
    static func  getkeyArrayListData(key:String)->[String] {
        
        let keychain = KeychainSwift()
        let keyData = keychain.getData(key)
        if keyData != nil {
            
            let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyData!) as! [String]
            return unarchivedObject
            
            
        }else{
            
            return []
        }
        
        
    }
    
    static func setKeyArrayData(value:[String],key:String) {
        
        let keychain = KeychainSwift()
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        keychain.set(archivedData, forKey: key)
    }
    
}
