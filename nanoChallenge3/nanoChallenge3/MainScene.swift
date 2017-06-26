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
    
    //Game Over Buttons
    var buttonRetry: SKSpriteNode!
    var buttonMenu: SKSpriteNode!
    
    //Menu Buttons
    var buttonLevels: SKSpriteNode!
    var buttonPlay: SKSpriteNode!
    
    
    
    override func didMove(to view: SKView) {
    }
    
    func createMenuScene(sceneSize: CGSize){
        self.status = .menu
        
        
        
        buttonLevels = SKSpriteNode(imageNamed: "Button_Levels")
        buttonLevels.position = CGPoint(x: 0, y: -sceneSize.height/2)
        buttonLevels.name = "Button_Levels";
        buttonLevels.isUserInteractionEnabled = false;
        self.addChild(buttonLevels)
        
        buttonPlay = SKSpriteNode(imageNamed: "Button_Play")
        buttonPlay.position = CGPoint(x: 0, y: buttonLevels.position.y + buttonsDistance)
        buttonPlay.name = "Button_Play";
        buttonPlay.isUserInteractionEnabled = false;
        self.addChild(buttonPlay)
    }
    
    func createGameOverScene(sceneSize: CGSize){
        self.status = .gameOver
        
        let gameOver = SKSpriteNode(imageNamed: "Game_Over")
        gameOver.position = CGPoint(x: 0, y: 0)
        gameOver.name = "Game_Over";
        gameOver.isUserInteractionEnabled = false;
        gameOver.zPosition = 1
        
        let circle = SKSpriteNode(imageNamed: "Circle")
        circle.position = CGPoint(x: -gameOver.size.width/2 + circle.size.width/2, y: -gameOver.size.height/2 + circle.size.height/2)
        circle.name = "Circle";
        circle.isUserInteractionEnabled = false;
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
        
        
        
        
        
        buttonMenu = SKSpriteNode(imageNamed: "Button_Menu")
        buttonMenu.position = CGPoint(x: 0, y: -sceneSize.height/2)
        buttonMenu.name = "Button_Menu";
        buttonMenu.isUserInteractionEnabled = false;
        self.addChild(buttonMenu)
        
        buttonRetry = SKSpriteNode(imageNamed: "Button_Retry")
        buttonRetry.position = CGPoint(x: 0, y: buttonMenu.position.y + buttonsDistance)
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
                buttonLevels.texture = SKTexture(imageNamed: "Button_Levels")
            }
            else if buttonPlay.contains(touch.location(in: self)) {
                buttonPlay.texture = SKTexture(imageNamed: "Button_Play")
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                }
            }
        }
        else if self.status == .gameOver {
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
        
        if self.status == .menu {
            if buttonLevels.contains(touch.location(in: self)) {
                buttonLevels.texture = SKTexture(imageNamed: "Button_Levels")
            }
            else if buttonPlay.contains(touch.location(in: self)) {
                buttonPlay.texture = SKTexture(imageNamed: "Button_Play")
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
            else if buttonMenu.contains(touch.location(in: self)) {
                buttonMenu.texture = SKTexture(imageNamed: "Button_Menu")
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
