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
    case menu, gameOver
}

class MainScene: SKScene {
    var status = Status.menu
    var buttonsDistance = CGFloat(80)
    
    //Other Buttons
    var buttonPlay: SKSpriteNode!
    
    //Game Over Buttons
    var buttonRetry: SKSpriteNode!
    var buttonQuit: SKSpriteNode!
    
    //Menu Buttons
    var buttonLevels: SKSpriteNode!
    var buttonSettings: SKSpriteNode!
    
    
    
    override func didMove(to view: SKView) {
    }
    
    func createMenuScene(sceneSize: CGSize){
        self.status = .menu
        
        buttonSettings = SKSpriteNode(imageNamed: "Button_Settings")
        buttonSettings.position = CGPoint(x: 0, y: -sceneSize.height/2)
        buttonSettings.name = "Button_Settings";
        buttonSettings.isUserInteractionEnabled = false;
        self.addChild(buttonSettings)
        
        buttonLevels = SKSpriteNode(imageNamed: "Button_Levels")
        buttonLevels.position = CGPoint(x: 0, y: buttonSettings.position.y + buttonsDistance)
        buttonLevels.name = "Button_Levels";
        buttonLevels.isUserInteractionEnabled = false;
        self.addChild(buttonLevels)
    }
    
    func createGameOverScene(sceneSize: CGSize){
        self.status = .gameOver
        
        let gameOver = SKSpriteNode(imageNamed: "GameOver")
        gameOver.position = CGPoint(x: 0, y: 0)
        gameOver.name = "GameOver";
        gameOver.isUserInteractionEnabled = false;
        gameOver.zPosition = 1
        
        let circle = SKSpriteNode(imageNamed: "Circle")
        circle.name = "Circle";
        circle.isUserInteractionEnabled = false;
        circle.size = CGSize(width: circle.size.width-40, height: circle.size.height-40)
        
        circle.position = CGPoint(x: -gameOver.size.width/2 + circle.size.width/2, y: -gameOver.size.height/2 + circle.size.height/2)
        
        circle.zPosition = 2
        
        let gameOverNode = SKNode()
        gameOverNode.position = CGPoint(x: 0, y: 0)
        gameOverNode.addChild(gameOver)
        gameOverNode.addChild(circle)
        gameOverNode.position = CGPoint(x: 0, y: sceneSize.height/2)
        
        addChild(gameOverNode)
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 2)
        let forever = SKAction.repeatForever(rotate)
        circle.run(forever)
        
        
        
        
        
        buttonQuit = SKSpriteNode(imageNamed: "Button_Quit")
        buttonQuit.position = CGPoint(x: 0, y: -sceneSize.height/2)
        buttonQuit.name = "Button_Quit";
        buttonQuit.isUserInteractionEnabled = false;
        self.addChild(buttonQuit)
        
        buttonRetry = SKSpriteNode(imageNamed: "Button_Retry")
        buttonRetry.position = CGPoint(x: 0, y: buttonQuit.position.y + buttonsDistance)
        buttonRetry.name = "Button_Retry";
        buttonRetry.isUserInteractionEnabled = false;
        self.addChild(buttonRetry)
    }
    
    func createSubShapesWith(number: Int){
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if self.status == .menu {
            if buttonLevels.contains(touch.location(in: self)) {
                buttonLevels.texture = SKTexture(imageNamed: "Spaceship")
            }
            else if buttonSettings.contains(touch.location(in: self)) {
                buttonSettings.texture = SKTexture(imageNamed: "Spaceship")
            }
            else if touch.location(in: self).y > 0 {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                }
            }
        }
        else if self.status == .gameOver {
            if buttonRetry.contains(touch.location(in: self)) {
                buttonRetry.texture = SKTexture(imageNamed: "Spaceship")
            }
            else if buttonQuit.contains(touch.location(in: self)) {
                buttonQuit.texture = SKTexture(imageNamed: "Spaceship")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if self.status == .menu {
            if buttonLevels.contains(touch.location(in: self)) {
                buttonLevels.texture = SKTexture(imageNamed: "Button_Levels")
            }
            else if buttonSettings.contains(touch.location(in: self)) {
                buttonSettings.texture = SKTexture(imageNamed: "Button_Settings")
            }
        }
        else if self.status == .gameOver {
            if buttonRetry.contains(touch.location(in: self)) {
                buttonRetry.texture = SKTexture(imageNamed: "Button_Retry")
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                }
            }
            else if buttonQuit.contains(touch.location(in: self)) {
                buttonQuit.texture = SKTexture(imageNamed: "Button_Quit")
                if let scene = SKScene(fileNamed: "MainScene") {
                    scene.scaleMode = .aspectFill
                    let mainScene = scene as! MainScene
                    mainScene.createMenuScene(sceneSize: (self.view?.frame.size)!)
                    self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
