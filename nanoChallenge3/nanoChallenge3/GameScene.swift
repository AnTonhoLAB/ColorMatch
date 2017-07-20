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
    var level: Int!
    var subLevel: Int!
    
    var shapeNoodesMainCircle = [SubShape]()
    var circles = [SKShapeNode]()
    var matches = 0
    
    var touched = false
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.white
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setSubLevelAcordingToParameters(level: self.level, subLevel: self.subLevel)
        
        setTopLayoutDownLayoutAndMusic(withLevel: level)
        
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
            
            for subShape in shapeNoodesMainCircle {
                circles.append(subShape.impulse())
            }
            
            touched = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for circle in circles{
            let height = (self.view?.frame.size.height)!
            let width = (self.view?.frame.size.width)!
            let distance = CGFloat(100)
            let x = circle.position.x
            let y = circle.position.y
            if y > height + distance || y < -(height + distance) || x > width + distance || x < -(width + distance){
                goToGameOverScene()
            }
        }
        
        if circles.count > 0 && matches == circles.count{
            let currentLevel = UserDefaultsManager.getCurrentUserInfo(info: DefaultsOption.CurrentLevel)
            
            if self.level == currentLevel && self.subLevel == 3{
                
                let numberOfLevels = World.numberOfLevels()
                let numberOfSubLevelsInLevel = World.getLevel(level: level)?.numberOfSubLevels()
                
                if level < numberOfLevels && subLevel == numberOfSubLevelsInLevel{
                    UserDefaultsManager.updateUserInfo(with: level+1, and: 1)
                    goToLevelUpScene()
                }
                else if level == numberOfLevels && subLevel == numberOfSubLevelsInLevel{
                    UserDefaultsManager.updateUserInfo(with: level, and: numberOfSubLevelsInLevel!)
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
    
    func goToGameOverScene(){
        let mainScene = MainScene(size: self.frame.size)
        mainScene.scaleMode = .aspectFill
        mainScene.createGameOverScene(level: level, subLevel: 1)
        self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
    }
    
    func goToLevelUpScene(){
        let levelUpScene = LevelUpScene(size: self.frame.size)
        levelUpScene.scaleMode = .aspectFill
        levelUpScene.setLevel(level: level)
        self.view?.presentScene(levelUpScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
        
    }
    
    func goToNextLevelOrSubLevel(){
        let gameScene = GameScene(size: self.frame.size)
        gameScene.scaleMode = .aspectFill
        if self.subLevel == World.getLevel(level: level)?.numberOfSubLevels(){
            gameScene.setLevelAndSubLevel(level: level+1, subLevel: 1)
        }
        else{
            gameScene.setLevelAndSubLevel(level: level, subLevel: subLevel+1)
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
        let shapeNodeBodyB = contact.bodyB.node as! SKShapeNode
        
        shapeNodeBodyA.physicsBody?.isDynamic = false
        shapeNodeBodyB.physicsBody?.isDynamic = false
        
        if shapeNodeBodyA.strokeColor == shapeNodeBodyB.strokeColor{
            if !shapeNodeBodyB.attributeValues.keys.contains("checked"){
                matches += 1
                shapeNodeBodyB.attributeValues.updateValue(SKAttributeValue.init(), forKey: "checked")
            }
        }
        else{
            goToGameOverScene()
        }
    }
    
    
    func setTopLayoutDownLayoutAndMusic(withLevel level:Int){
        let color = ((level%4)-1 == -1 ? 3 : (level%4)-1)+1
        
        MusicController.sharedInstance().backGroundMusic(music: "song\(color)", type: "mp3")
        
        let topLayout = SKSpriteNode(imageNamed: "Level_\(color)_Top")
        let downLayout = SKSpriteNode(imageNamed: "Level_\(color)_Down")
        
        let scaleLayout = self.frame.size.width/topLayout.size.width
        
        topLayout.xScale = scaleLayout
        topLayout.yScale = scaleLayout
        
        downLayout.xScale = scaleLayout
        downLayout.yScale = scaleLayout
        
        topLayout.position = CGPoint(x: 0, y: self.frame.size.height/2 - topLayout.size.height/2)
        downLayout.position = CGPoint(x: 0, y: -(self.frame.size.height/2) + downLayout.size.height/2)
        
        addChild(topLayout)
        addChild(downLayout)
    }
    
    func setSubLevelAcordingToParameters(level:Int, subLevel:Int){
        let subLevel = World.getLevel(level: level)?.getSubLevel(subLevel: subLevel)
        shapeNoodesMainCircle = (subLevel?.applySubLevelInScene(scene: self))!
    }
    
    func setLevelAndSubLevel(level:Int, subLevel:Int){
        self.level = level
        self.subLevel = subLevel
    }
    
}
