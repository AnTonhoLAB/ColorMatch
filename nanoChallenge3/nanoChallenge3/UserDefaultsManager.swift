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

class UserDefaultsManager: AnyObject {

    
    var currentLevel:Int!
    var currentSubLevel:Int!
    var userDefault:UserDefaults!
    
    
    init() {
        
        self.userDefault = UserDefaults.standard
        
        if(self.checkFirstTimeUsingApp()){
            
            self.currentLevel = 1
            self.currentSubLevel = 1
            
            self.registerLevelAndSubLevelToUserDefaults()
            
        }else{
            
            self.currentLevel = self.getCurrentUserInfo(info: .CurrentLevel)
            self.currentSubLevel = self.getCurrentUserInfo(info: .CurrentSubLevel)
        }
        
    }
    
    func updateDefaultsToNextSubLevel(){
        
        self.currentSubLevel = self.currentSubLevel+1
        
        self.registerLevelAndSubLevelToUserDefaults()
    }
    
    func updateDefaultstoNextLevel(){
        
        self.currentLevel = 1
        
        self.currentSubLevel = 1
        
        self.registerLevelAndSubLevelToUserDefaults()
        
    }
    
    func resetUserDefaults(){
        
        self.currentSubLevel = 1
        self.currentLevel = 1
        
        self.registerLevelAndSubLevelToUserDefaults()
        
    }
    
    
    func checkFirstTimeUsingApp()->Bool{
        
        return !(self.userDefault.bool(forKey: "CurrentLevel"))
    }
    
    func registerLevelAndSubLevelToUserDefaults(){
        
        self.userDefault.set(self.currentLevel, forKey: "CurrentLevel")
        self.userDefault.set(self.currentSubLevel, forKey: "CurrentSubLevel")
        
    }
    
    func getCurrentUserInfo(info:DefaultsOption)->Int{
        
        var informationToBeReturned:Int!
        
            switch(info){
            
            case .CurrentLevel: informationToBeReturned = self.userDefault.integer(forKey: "CurrentLevel")
                break
            
            case .CurrentSubLevel: informationToBeReturned = self.userDefault.integer(forKey: "CurrentSubLevel")
                break
            
            default: informationToBeReturned = -1
                break
            
        }
        
        return informationToBeReturned
        
    }
    
    
    
}
