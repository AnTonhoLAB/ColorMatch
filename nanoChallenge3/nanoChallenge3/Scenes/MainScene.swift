//
//  MainScene.swift
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
    
    var titleNode: SKNode! = nil
    
    var firstButton: SKSpriteNode!
    var secondButton: SKSpriteNode!
    
    var buttonsDistance = CGFloat(15)
    
    //Game Over
    var level: Int!
    var subLevel: Int!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backgroundColor = UIColor.white
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        if status == .Menu {
            MusicController.sharedInstance.backGroundMusic(music: "back", type: "wav")
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleNode.xScale = 2
            titleNode.yScale = 2
            
            firstButton.xScale = 2
            firstButton.yScale = 2
            
            secondButton.xScale = 2
            secondButton.yScale = 2
            
            buttonsDistance = CGFloat(30)
        }
        
        let title = titleNode.childNode(withName: "Title") as! SKSpriteNode
        
        let spaces = (self.frame.size.height - (title.size.height + firstButton.size.height*2 + buttonsDistance))/3
        
        titleNode.position = CGPoint(x: 0, y: self.frame.size.height/2 - spaces - title.size.height/2)
        
        firstButton.isUserInteractionEnabled = false
        secondButton.isUserInteractionEnabled = false
        
        secondButton.position = CGPoint(x: 0, y: -self.frame.height/2 + spaces)
        firstButton.position = CGPoint(x: 0, y: secondButton.position.y + firstButton.size.height + buttonsDistance)
        
        addChild(titleNode)
        addChild(firstButton)
        addChild(secondButton)
        
        Background.applyIn(scene: self)
    }
    
    func createMenuScene(){
        self.status = .Menu
        
        let name = SKSpriteNode(imageNamed: "Name")
        name.position = CGPoint(x: 0, y: 0)
        name.name = "Title";
        name.isUserInteractionEnabled = false;
        name.zPosition = 100
        
        let first_circle = SKSpriteNode(imageNamed: "Circle_Name")
        first_circle.position = CGPoint(x: -first_circle.size.width + 9, y: name.size.height/2 - first_circle.size.height/2 - 20)
        first_circle.isUserInteractionEnabled = false;
        first_circle.zPosition = name.zPosition+1
        
        let second_circle = SKSpriteNode(imageNamed: "Circle_Name_2")
        second_circle.position = CGPoint(x: first_circle.size.width + 4, y: name.size.height/2 - first_circle.size.height/2 - 20)
        second_circle.isUserInteractionEnabled = false;
        second_circle.zPosition = name.zPosition+1
        
        titleNode = SKNode()
        titleNode.position = CGPoint(x: 0, y: 0)
        titleNode.addChild(name)
        titleNode.addChild(first_circle)
        titleNode.addChild(second_circle)
        
        var rotate = SKAction.rotate(byAngle: CGFloat.pi*2, duration: 2)
        var forever = SKAction.repeatForever(rotate)
        first_circle.run(forever)
        rotate = SKAction.rotate(byAngle: -1*CGFloat.pi*2, duration: 2)
        forever = SKAction.repeatForever(rotate)
        second_circle.run(forever)
        
        secondButton = SKSpriteNode(imageNamed: "Button_Levels")
        firstButton = SKSpriteNode(imageNamed: "Button_Play")
    }
    
    func createGameOverScene(level: Int, subLevel: Int){
        self.level = level
        self.subLevel = subLevel
        self.status = .GameOver
        
        let gameOver = SKSpriteNode(imageNamed: "Game_Over")
        gameOver.position = CGPoint(x: 0, y: 0)
        gameOver.name = "Title";
        gameOver.isUserInteractionEnabled = false;
        gameOver.zPosition = 100
        
        let circle = SKSpriteNode(imageNamed: "Circle_Game_Over")
        circle.position = CGPoint(x: -gameOver.size.width/2 + circle.size.width/2, y: -gameOver.size.height/2 + circle.size.height/2)
        circle.isUserInteractionEnabled = false;
        circle.zPosition = gameOver.zPosition+1
        
        titleNode = SKNode()
        titleNode.position = CGPoint(x: 0, y: 0)
        titleNode.addChild(gameOver)
        titleNode.addChild(circle)
        
        let rotate = SKAction.rotate(byAngle: CGFloat.pi*2, duration: 2)
        let forever = SKAction.repeatForever(rotate)
        circle.run(forever)
        
        secondButton = SKSpriteNode(imageNamed: "Button_Menu")
        firstButton = SKSpriteNode(imageNamed: "Button_Retry")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if self.status == .Menu {
            if secondButton.contains(touch.location(in: self)) {
                let levelScene = LevelsScene(size: self.frame.size)
                levelScene.scaleMode = .aspectFill
                self.view?.presentScene(levelScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
            }
            else if firstButton.contains(touch.location(in: self)) {
                let gameScene = GameScene(size: self.frame.size)
                gameScene.scaleMode = .aspectFill
                let level = UserDefaultsManager.getCurrentUserInfo(info: DefaultsOption.CurrentLevel)
                let subLevel = UserDefaultsManager.getCurrentUserInfo(info: DefaultsOption.CurrentSubLevel)
                gameScene.setSubLevel(with: level, and: subLevel)
                self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
            }
        }
        else if self.status == .GameOver {
            if firstButton.contains(touch.location(in: self)) {
                let gameScene = GameScene(size: self.frame.size)
                gameScene.scaleMode = .aspectFill
                gameScene.setSubLevel(with: level, and: subLevel)
                self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
            }
            else if secondButton.contains(touch.location(in: self)) {
                let mainScene = MainScene(size: self.frame.size)
                mainScene.scaleMode = .aspectFill
                mainScene.createMenuScene()
                self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
            }
        }
    }
    
    override func shake() {
        if status == Status.Menu {
            let creditsScene = CreditsScene(size: self.frame.size)
            creditsScene.scaleMode = .aspectFill
            self.view?.presentScene(creditsScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
        }
    }
    
}
