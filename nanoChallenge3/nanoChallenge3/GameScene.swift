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
        setNextSubLevelAcordingToParameters(level: self.level, subLevel: self.subLevel)
        
        setTopAndDownLayoutForGameScene(level: level)
        
        Background.movePointsIn(scene: self)
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
            let currentSubLevel = UserDefaultsManager.getCurrentUserInfo(info: DefaultsOption.CurrentSubLevel)
            
            if self.level == currentLevel && self.subLevel == currentSubLevel{
                UserDefaultsManager.updateLevelAndSubLevel()
                if level < World.numberOfLevels() && subLevel == World.getLevel(level: level)?.numberOfSubLevels(){
                    goToLevelUpScene()
                }
                else if level == World.numberOfLevels() && subLevel == World.getLevel(level: level)?.numberOfSubLevels(){
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
        if let scene = SKScene(fileNamed: "MainScene") {
            scene.scaleMode = .aspectFill
            let mainScene = scene as! MainScene
            mainScene.createGameOverScene(level: level, subLevel: subLevel)
            self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
        }
    }
    
    func goToLevelUpScene(){
        if let scene = SKScene(fileNamed: "LevelUpScene") {
            scene.scaleMode = .aspectFill
            let levelUpScene = scene as! LevelUpScene
            levelUpScene.setLevel(level: level)
            self.view?.presentScene(levelUpScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
        }
    }
    
    func goToNextLevelOrSubLevel(){
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            let gameScene = scene as! GameScene
            if self.subLevel == World.getLevel(level: level)?.numberOfSubLevels(){
                gameScene.setLevelAndSubLevel(level: level+1, subLevel: 1)
            }
            else{
                gameScene.setLevelAndSubLevel(level: level, subLevel: subLevel+1)
            }
            self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
        }
    }
    
    func goToLevelScene(){
        if let scene = SKScene(fileNamed: "LevelScene") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
        }
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
    
    
    func setTopAndDownLayoutForGameScene(level:Int){
        
        let topLayout = self.childNode(withName: "TopShape") as! SKSpriteNode
        let downLayout = self.childNode(withName: "DownShape") as! SKSpriteNode
        
        topLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_\(level)_Top")))
        downLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_\(level)_Down")))
        
    }
    
    func setNextSubLevelAcordingToParameters(level:Int, subLevel:Int){
        let subLevel = World.getLevel(level: level)?.getSubLevel(subLevel: subLevel)
        shapeNoodesMainCircle = (subLevel?.applySubLevelInScene(scene: self))!
    }
    
    func setLevelAndSubLevel(level:Int, subLevel:Int){
        self.level = level
        self.subLevel = subLevel
    }
    
}
