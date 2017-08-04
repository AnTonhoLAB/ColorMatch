//
//  AppDelegate.swift
//  nanoChallenge3
//
//  Created by George Vilnei Arboite Gomes on 22/06/17.
//
//

import UIKit
import Fabric
import Crashlytics
import CloudKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        UserInfoManager.resetUserInfo()
        
        var userInfo = UserInfoManager.getUserInfo()
        
        let numberOfLevels = World.numberOfLevels()
        
        if userInfo.level! > numberOfLevels{
            userInfo.level = numberOfLevels
            userInfo.subLevel = 3
            UserInfoManager.saveLevelAndSubLevelUserDefaults(with: userInfo.level, and: userInfo.subLevel)
        }
        else if userInfo.subLevel == 3 && numberOfLevels > userInfo.level{
            userInfo.level! += 1
            userInfo.subLevel = 1
            UserInfoManager.saveLevelAndSubLevelUserDefaults(with: userInfo.level, and: userInfo.subLevel)
        }
        
        UserInfoManager.getLevelAndSubLevelCloudKit(completion: { (record: CKRecord?) -> Void in
            DispatchQueue.main.async() {
                
                if record != nil {
                    var levelCloudKit = record!["CurrentLevel"] as! Int
                    var subLevelCloudKit = record!["CurrentSubLevel"] as! Int
                    
                    if levelCloudKit > World.numberOfLevels(){
                        levelCloudKit = World.numberOfLevels()
                        subLevelCloudKit = 3
                    }
                    else if subLevelCloudKit == 3 && numberOfLevels > levelCloudKit{
                        levelCloudKit += 1
                        subLevelCloudKit = 1
                    }
                    
                    if levelCloudKit > userInfo.level || (levelCloudKit == userInfo.level && subLevelCloudKit > userInfo.subLevel){
                        userInfo.level = levelCloudKit
                        userInfo.subLevel = subLevelCloudKit
                        UserInfoManager.saveLevelAndSubLevelUserDefaults(with: userInfo.level, and: userInfo.subLevel)
                    }
                    else if levelCloudKit < userInfo.level || (levelCloudKit == userInfo.level && subLevelCloudKit < userInfo.subLevel){
                        
                        record!["CurrentLevel"] = userInfo.level as CKRecordValue
                        record!["CurrentSubLevel"] = userInfo.subLevel as CKRecordValue
                        
                        UserInfoManager.saveLevelAndSubLevelCloudKit(with: record!)
                    }
                }
                else {
                    
                    let recordToSave = CKRecord(recordType: "UserInfo")
                    
                    recordToSave["CurrentLevel"] = userInfo.level as CKRecordValue
                    recordToSave["CurrentSubLevel"] = userInfo.subLevel as CKRecordValue
                    UserInfoManager.saveLevelAndSubLevelCloudKit(with: recordToSave)
                }
            }
        })
        
//        Only set Crash reports if app is in production
        if( !GameConfiguration.debugMode ) {
            Fabric.with([Crashlytics.self])
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

