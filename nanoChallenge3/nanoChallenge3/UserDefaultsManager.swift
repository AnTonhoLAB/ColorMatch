//
//  UserDefaultsManager.swift
//  nanoChallenge3
//
//  Created by Douglas Gehring on 26/06/17.
//
//

import UIKit


enum DefaultsOption {
    case CurrentLevel
    case CurrentSubLevel
}

class UserDefaultsManager {
    
    static func updateUserInfo(with level: Int, and subLevel: Int){
        registerLevelAndSubLevelToUserDefaults(level: level, subLevel: subLevel)
    }
    
    static func resetUserDefaults(){
        let userDefault = UserDefaults.standard
        
        userDefault.set(1, forKey: "CurrentLevel")
        userDefault.set(1, forKey: "CurrentSubLevel")
    }
    
    
    static func checkFirstTimeUsingApp()->Bool{
        let userDefault = UserDefaults.standard
        return !(userDefault.bool(forKey: "CurrentLevel"))
    }
    
    static func registerLevelAndSubLevelToUserDefaults(level: Int, subLevel: Int){
        let userDefault = UserDefaults.standard
        
        userDefault.set(level, forKey: "CurrentLevel")
        userDefault.set(subLevel, forKey: "CurrentSubLevel")
        
    }
    
    static func getCurrentUserInfo(info:DefaultsOption)->Int{
        
        let userDefault = UserDefaults.standard
        
        var informationToBeReturned:Int!
        
            switch(info){
            
            case .CurrentLevel: informationToBeReturned = userDefault.integer(forKey: "CurrentLevel")
                break
            
            case .CurrentSubLevel: informationToBeReturned = userDefault.integer(forKey: "CurrentSubLevel")
                break
        }
        
        return informationToBeReturned
        
    }
    
    
    
}
