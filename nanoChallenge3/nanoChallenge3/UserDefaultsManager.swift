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
    
    static func updateLevelAndSubLevel(){
        let currentLevel = getCurrentUserInfo(info: DefaultsOption.CurrentLevel)
        let currentSubLevel = getCurrentUserInfo(info: DefaultsOption.CurrentSubLevel)
        
        if currentLevel == 2 && currentSubLevel == 3{
            //Ignore
        }
        else if(currentSubLevel < 3){
            registerLevelAndSubLevelToUserDefaults(level: currentLevel, subLevel: currentSubLevel+1)
        }
        else{
            registerLevelAndSubLevelToUserDefaults(level: currentLevel+1, subLevel: 1)
        }
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
