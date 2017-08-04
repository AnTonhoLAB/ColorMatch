//
//  GameScene.swift
//  nanoChallenge3
//
//  Created by George Vilnei Arboite Gomes on 22/06/17.
//
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var subLevel: SubLevel!
    
    var mainCircle: MainCircle!
    var matches = 0
    
    var touched = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backgroundColor = UIColor.white
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(Hud(with: subLevel.level, and: self.size))
        
        setScene(with: subLevel)
        
        setMusic(with: subLevel.level.color)
        
        Background.applyIn(scene: self)
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touched {
            for child in children{
                if child.name == "arc"{
                    child.removeAllActions()
                }
            }
            
            for subShape in mainCircle.children as! [SubShapeMainCircle] {
                subShape.impulse()
            }
            
            touched = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if touched {
            
            for circle in mainCircle.children{
                let height = (self.view?.frame.size.height)!
                let width = (self.view?.frame.size.width)!
                let distance = CGFloat(100)
                let x = circle.position.x
                let y = circle.position.y
                if y > height + distance || y < -(height + distance) || x > width + distance || x < -(width + distance){
                    goToGameOverScene()
                }
            }
            
            if matches == mainCircle.children.count{
                
                let userInfo = UserInfoManager.getUserInfo()
                
                if subLevel.level.number == userInfo.level && self.subLevel.number == 3{
                    
                    let numberOfLevels = World.numberOfLevels()
                    let numberOfSubLevelsInLevel = subLevel.level.numberOfSubLevels()
                    
                    if subLevel.level.number < numberOfLevels && subLevel.number == numberOfSubLevelsInLevel{
                        UserInfoManager.updateUserInfo(with: subLevel.level.number+1, and: 1)
                        goToLevelUpScene()
                    }
                    else if subLevel.level.number == numberOfLevels && subLevel.number == numberOfSubLevelsInLevel{
                        UserInfoManager.updateUserInfo(with: subLevel.level.number, and: numberOfSubLevelsInLevel)
                        goToLevelScene()
                    }
                    else{
                        goToNextLevelOrSubLevel()
                    }
                }
                else{
                    goToNextLevelOrSubLevel()
                }
            }
        }
    }
    
    func goToGameOverScene(){
        let mainScene = MainScene(size: self.frame.size)
        mainScene.scaleMode = .aspectFill
        
        let userInfo = UserInfoManager.getUserInfo()
        
        if userInfo.level > subLevel.level.number {
            mainScene.createGameOverScene(level: subLevel.level.number, subLevel: subLevel.number)
        }
        else{
            mainScene.createGameOverScene(level: subLevel.level.number, subLevel: 1)
        }
        
        self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
    }
    
    func goToLevelUpScene(){
        let levelUpScene = LevelUpScene(size: self.frame.size)
        levelUpScene.scaleMode = .aspectFill
        levelUpScene.setLevel(level: subLevel.level.number)
        self.view?.presentScene(levelUpScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
        
    }
    
    func goToNextLevelOrSubLevel(){
        let gameScene = GameScene(size: self.frame.size)
        gameScene.scaleMode = .aspectFill
        if self.subLevel.number == subLevel.level.numberOfSubLevels(){
            gameScene.setSubLevel(with: subLevel.level.number+1, and: 1)
        }
        else{
            gameScene.setSubLevel(with: subLevel.level.number, and: subLevel.number+1)
        }
        self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
    }
    
    func goToLevelScene(){
        let levelScene = LevelsScene(size: self.frame.size)
        levelScene.scaleMode = .aspectFill
        self.view?.presentScene(levelScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let shapeNodeBodyA = contact.bodyA.node as! SKShapeNode
        let shapeNodeBodyB = contact.bodyB.node as! SubShapeMainCircle
        
        shapeNodeBodyA.physicsBody?.isDynamic = false
        shapeNodeBodyB.physicsBody?.isDynamic = false
        
        if shapeNodeBodyA.fillColor.description == shapeNodeBodyB.color!.description{
            if !shapeNodeBodyB.attributeValues.keys.contains("checked"){
                matches += 1
                shapeNodeBodyB.attributeValues.updateValue(SKAttributeValue.init(), forKey: "checked")
            }
        }
        else{
            goToGameOverScene()
        }
    }
    
    
    func setMusic(with levelColor:Int){
        MusicController.sharedInstance.backGroundMusic(music: "song\(levelColor)", type: "mp3")
    }
    
    func setScene(with subLevel: SubLevel){
        mainCircle = (self.subLevel.applySubLevelInScene(scene: scene!))
    }
    
    func setSubLevel(with level:Int, and subLevel:Int){
        self.subLevel = World.getLevel(level: level)?.getSubLevel(subLevel: subLevel)
    }
    
}
