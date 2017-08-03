//
//  UserDefaultsManager.swift
//  nanoChallenge3
//
//  Created by Douglas Gehring on 26/06/17.
//
//

import UIKit
import CloudKit


enum DefaultsOption {
    case CurrentLevel
    case CurrentSubLevel
}

struct UserInfo {
    var level: Int!
    var subLevel: Int!
    
    init(with level: Int, and subLevel: Int) {
        self.level = level
        self.subLevel = subLevel
    }
}

class UserInfoManager {
    
    static func updateUserInfo(with level: Int, and subLevel: Int) {
        
        saveLevelAndSubLevelUserDefaults(with: level, and: subLevel)
        
        var userInfo = UserInfoManager.getUserInfo()
        
        UserInfoManager.getLevelAndSubLevelCloudKit(completion: { (record: CKRecord?) -> Void in
            DispatchQueue.main.async() {
                
                if record != nil {
                    let levelCloudKit = record!["CurrentLevel"] as! Int
                    let subLevelCloudKit = record!["CurrentSubLevel"] as! Int
                    
                    if levelCloudKit > userInfo.level || (levelCloudKit == userInfo.level && subLevelCloudKit > userInfo.subLevel){
                        userInfo.level = levelCloudKit
                        userInfo.subLevel = subLevelCloudKit
                        saveLevelAndSubLevelUserDefaults(with: userInfo.level, and: userInfo.subLevel)
                    }
                    else if levelCloudKit < userInfo.level || (levelCloudKit == userInfo.level && subLevelCloudKit < userInfo.subLevel){
                        
                        record!["CurrentLevel"] = userInfo.level as CKRecordValue
                        record!["CurrentSubLevel"] = userInfo.subLevel as CKRecordValue
                        
                        saveLevelAndSubLevelCloudKit(with: record!)
                    }
                }
                else {
                    
                    let recordToSave = CKRecord(recordType: "UserInfo")
                    
                    recordToSave["CurrentLevel"] = userInfo.level as CKRecordValue
                    recordToSave["CurrentSubLevel"] = userInfo.subLevel as CKRecordValue
                    saveLevelAndSubLevelCloudKit(with: recordToSave)
                }
            }
        })
    }
    
    static func resetUserInfo(){
        UserInfoManager.getLevelAndSubLevelCloudKit(completion: { (record: CKRecord?) -> Void in
            DispatchQueue.main.async() {
                if record != nil {
                    record!["CurrentLevel"] = Int(1) as CKRecordValue
                    record!["CurrentSubLevel"] = Int(1) as CKRecordValue
                    UserInfoManager.saveLevelAndSubLevelCloudKit(with: record!)
                }
                else {
                    let recordToSave = CKRecord(recordType: "UserInfo")
                    recordToSave["CurrentLevel"] = Int(1) as CKRecordValue
                    recordToSave["CurrentSubLevel"] = Int(1) as CKRecordValue
                    UserInfoManager.saveLevelAndSubLevelCloudKit(with: recordToSave)
                }
            }
        })
        
        saveLevelAndSubLevelUserDefaults(with: 1, and: 1)
    }
    
    static func saveLevelAndSubLevelUserDefaults(with level: Int, and subLevel: Int){
        let userDefault = UserDefaults.standard
        
        userDefault.set(level, forKey: "CurrentLevel")
        userDefault.set(subLevel, forKey: "CurrentSubLevel")
        
    }
    
    static func getUserInfo() -> UserInfo {
        
        let userDefault = UserDefaults.standard
        
        if !(userDefault.bool(forKey: "CurrentLevel")) {
            saveLevelAndSubLevelUserDefaults(with: 1, and: 1)
        }
        
        let level = userDefault.integer(forKey: "CurrentLevel")
        let subLevel = userDefault.integer(forKey: "CurrentSubLevel")
        
        return UserInfo(with: level, and: subLevel)
    }
    
    static func saveLevelAndSubLevelCloudKit( with record: CKRecord){
        
        let privateData = CKContainer.default().privateCloudDatabase
        
        privateData.save(record) {
            (record, error) in
        }
        
    }
    
    static func getLevelAndSubLevelCloudKit(completion: @escaping (CKRecord?)->Void) {
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "UserInfo", predicate: pred)
        
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let err = error {
                print(err)
            }else {
                var result: CKRecord!
                if records != nil {
                    for record in records! {
                        result = record
                    }
                    completion(result)
                }
                else {
                    completion(result)
                }
            }
        }
    }
    
    
    
}
