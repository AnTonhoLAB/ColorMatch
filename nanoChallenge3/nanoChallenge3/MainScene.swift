//
//  StartScene.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 23/06/17.
//
//

import SpriteKit
import GameplayKit

class MainScene: SKScene {
    
    var buttonPlay: SKSpriteNode!
    
    override func didMove(to view: SKView) {
//        let button = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))
//        button.position = CGPoint(x:0, y: 0)
        
        buttonPlay = SKSpriteNode(imageNamed: "Button_Play")
        buttonPlay.position = CGPoint(x: 0, y: 0)
//        buttonPlay.size = CGSize(width: size.width/1.4, height: size.height/8)
        buttonPlay.name = "Button_Play";
        buttonPlay.isUserInteractionEnabled = false;
        self.addChild(buttonPlay)
        
//        let buttonPlay = SKSpriteNode(imageNamed: "Button_Play")
//        buttonPlay.position = CGPoint(x:0, y: 0);
//        self.addChild(buttonPlay)
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
        if buttonPlay.contains(touch.location(in: self)) {
            buttonPlay.texture = SKTexture(imageNamed: "Spaceship")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if buttonPlay.contains(touch.location(in: self)) {
            buttonPlay.texture = SKTexture(imageNamed: "Button_Play")
            
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                //SKTransition.flipVertical(withDuration: 2)
                self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
            }
            
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {

    }
}
