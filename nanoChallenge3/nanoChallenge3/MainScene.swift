//
//  StartScene.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 23/06/17.
//
//

import SpriteKit
import GameplayKit

enum Status {
    case Menu, GameOver
}

class MainScene: SKScene {
    var status = Status.Menu
    var buttonsDistance = CGFloat(80)
    
    //Game Over
    var gameOverNode: SKNode! = nil
    var buttonRetry: SKSpriteNode!
    var buttonMenu: SKSpriteNode!
    var level: Int!
    var subLevel: Int!
    
    //Menu
    var nameNode: SKNode! = nil
    var buttonLevels: SKSpriteNode!
    var buttonPlay: SKSpriteNode!
    
    
    
    override func didMove(to view: SKView) {
        var firstButton: SKSpriteNode!
        var secondButton: SKSpriteNode!
        
        switch self.status {
        case .Menu:
            nameNode.xScale = 2
            nameNode.yScale = 2
            
            let name = nameNode.childNode(withName: "Name") as! SKSpriteNode
            
            nameNode.position = CGPoint(x: 0, y: name.frame.size.height)
            
            firstButton = buttonPlay
            secondButton = buttonLevels
            break
        case .GameOver:
            gameOverNode.xScale = 2
            gameOverNode.yScale = 2
            
            let gameOver = gameOverNode.childNode(withName: "Game_Over") as! SKSpriteNode
            
            gameOverNode.position = CGPoint(x: 0, y: gameOver.frame.size.height)
            
            firstButton = buttonRetry
            secondButton = buttonMenu
            break
        }
        
        firstButton.xScale = 2
        firstButton.yScale = 2
        
        secondButton.xScale = 2
        secondButton.yScale = 2
        
        buttonsDistance = firstButton.size.height + 21
        
        firstButton.isUserInteractionEnabled = false
        secondButton.isUserInteractionEnabled = false
        
        secondButton.position = CGPoint(x: 0, y: -self.frame.height/2 + secondButton.size.height*2)
        firstButton.position = CGPoint(x: 0, y: secondButton.position.y + buttonsDistance)
        
        addChild(firstButton)
        addChild(secondButton)
        
        Background.movePointsIn(scene: self)
        
    }
    
    func createMenuScene(){
        self.status = .Menu
        
        let name = SKSpriteNode(imageNamed: "Name")
        name.position = CGPoint(x: 0, y: 0)
        name.name = "Name";
        name.isUserInteractionEnabled = false;
        name.zPosition = 1
        
        let first_circle = SKSpriteNode(imageNamed: "Circle_Name")
        first_circle.position = CGPoint(x: -first_circle.size.width + 9, y: name.size.height/2 - first_circle.size.height/2 - 20)
        first_circle.name = "Circle_Name";
        first_circle.isUserInteractionEnabled = false;
        first_circle.zPosition = 2
        
        let second_circle = SKSpriteNode(imageNamed: "Circle_Name_2")
        second_circle.position = CGPoint(x: first_circle.size.width + 4, y: name.size.height/2 - first_circle.size.height/2 - 20)
        second_circle.name = "Circle_Name_2";
        second_circle.isUserInteractionEnabled = false;
        second_circle.zPosition = 2
        
        nameNode = SKNode()
        nameNode.position = CGPoint(x: 0, y: 0)
        nameNode.addChild(name)
        nameNode.addChild(first_circle)
        nameNode.addChild(second_circle)
        
        addChild(nameNode)
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 2)
        let forever = SKAction.repeatForever(rotate)
        first_circle.run(forever)
        second_circle.run(forever)
        
        buttonLevels = SKSpriteNode(imageNamed: "Button_Levels")
        buttonLevels.name = "Button_Levels";
        
        buttonPlay = SKSpriteNode(imageNamed: "Button_Play")
        buttonPlay.name = "Button_Play";
    }
    
    func createGameOverScene(level: Int, subLevel: Int){
        self.level = level
        self.subLevel = subLevel
        self.status = .GameOver
        
        let gameOver = SKSpriteNode(imageNamed: "Game_Over")
        gameOver.position = CGPoint(x: 0, y: 0)
        gameOver.name = "Game_Over";
        gameOver.isUserInteractionEnabled = false;
        gameOver.zPosition = 1
        
        let circle = SKSpriteNode(imageNamed: "Circle_Game_Over")
        circle.position = CGPoint(x: -gameOver.size.width/2 + circle.size.width/2, y: -gameOver.size.height/2 + circle.size.height/2)
        circle.name = "Circle_Game_Over";
        circle.isUserInteractionEnabled = false;
        circle.zPosition = 2
        
        gameOverNode = SKNode()
        gameOverNode.position = CGPoint(x: 0, y: 0)
        gameOverNode.addChild(gameOver)
        gameOverNode.addChild(circle)
        
        addChild(gameOverNode)
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 2)
        let forever = SKAction.repeatForever(rotate)
        circle.run(forever)
        
        buttonMenu = SKSpriteNode(imageNamed: "Button_Menu")
        buttonMenu.name = "Button_Menu";
        
        buttonRetry = SKSpriteNode(imageNamed: "Button_Retry")
        buttonRetry.name = "Button_Retry";
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if self.status == .Menu {
            if buttonLevels.contains(touch.location(in: self)) {
                buttonLevels.texture = SKTexture(imageNamed: "Button_Levels")
                if let scene = SKScene(fileNamed: "LevelScene") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                }

            }
            else if buttonPlay.contains(touch.location(in: self)) {
                buttonPlay.texture = SKTexture(imageNamed: "Button_Play")
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    let gameScene = scene as! GameScene
                    
                    let level = UserDefaultsManager.getCurrentUserInfo(info: DefaultsOption.CurrentLevel)
                    let subLevel = UserDefaultsManager.getCurrentUserInfo(info: DefaultsOption.CurrentSubLevel)
                    
                    gameScene.setLevelAndSubLevel(level: level, subLevel: subLevel)
                    self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                }
            }
        }
        else if self.status == .GameOver {
            if buttonRetry.contains(touch.location(in: self)) {
                buttonRetry.texture = SKTexture(imageNamed: "Button_Retry")
            }
            else if buttonMenu.contains(touch.location(in: self)) {
                buttonMenu.texture = SKTexture(imageNamed: "Button_Menu")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if self.status == .Menu {
            if buttonLevels.contains(touch.location(in: self)) {
                buttonLevels.texture = SKTexture(imageNamed: "Button_Levels")
            }
            else if buttonPlay.contains(touch.location(in: self)) {
                buttonPlay.texture = SKTexture(imageNamed: "Button_Play")
            }
        }
        else if self.status == .GameOver {
            if buttonRetry.contains(touch.location(in: self)) {
                buttonRetry.texture = SKTexture(imageNamed: "Button_Retry")
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    
                    let gameScene = scene as! GameScene
                    gameScene.setLevelAndSubLevel(level: level, subLevel: subLevel)
                    
                    self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                }
            }
            else if buttonMenu.contains(touch.location(in: self)) {
                buttonMenu.texture = SKTexture(imageNamed: "Button_Menu")
                if let scene = SKScene(fileNamed: "MainScene") {
                    scene.scaleMode = .aspectFill
                    let mainScene = scene as! MainScene
                    mainScene.createMenuScene()
                    self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                }
            }
        }
    }
    
    override func shake() {
        if status == Status.Menu {
            if let scene = SKScene(fileNamed: "CreditsScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
            }
        }
    }
    
}
