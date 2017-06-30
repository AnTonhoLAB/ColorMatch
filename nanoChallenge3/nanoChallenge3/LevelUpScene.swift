//
//  LevelUpScene.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 27/06/17.
//
//

import SpriteKit
import GameplayKit

class LevelUpScene: SKScene {
    
    var buttonLevel: SKSpriteNode!
    
    var level: Int!
    
    override func didMove(to view: SKView) {
        
        let trophy = SKSpriteNode(imageNamed: "Trophy")
        trophy.xScale = 2
        trophy.yScale = 2
        trophy.position = CGPoint(x: 0, y: 0)
        trophy.zPosition = 100
        addChild(trophy)
        
        let levelUp = SKSpriteNode(imageNamed: "LevelUp")
        levelUp.xScale = 2
        levelUp.yScale = 2
        levelUp.position = CGPoint(x: 0, y: trophy.size.height/2 + levelUp.size.height/2 + 33)
        levelUp.zPosition = 100
        addChild(levelUp)
        
        buttonLevel = SKSpriteNode(imageNamed: "Button_Level")
        buttonLevel.xScale = 2
        buttonLevel.yScale = 2
        buttonLevel.position = CGPoint(x: 0, y: -(trophy.size.height/2 + buttonLevel.size.height/2 + 33))
        addChild(buttonLevel)
        
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: buttonLevel.size.width + 63*2, height: levelUp.size.height + trophy.size.height + buttonLevel.size.height + 33*2 + 48*2), cornerRadius: 20)
        rectangle.lineWidth = 5
        rectangle.strokeColor = UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 215.0/255.0, alpha: 1)
        
        rectangle.position = CGPoint(x: -rectangle.frame.size.width/2, y: -rectangle.frame.size.height/2)
        addChild(rectangle)
        
        let diference = CGFloat(80)
        
        trophy.position = CGPoint(x: 0, y: trophy.position.y - diference)
        levelUp.position = CGPoint(x: 0, y: levelUp.position.y - diference)
        buttonLevel.position = CGPoint(x: 0, y: buttonLevel.position.y - diference)
        
        let lableLevel = SKLabelNode()
        lableLevel.text = "\(level+1)"
        lableLevel.fontSize = 72
        lableLevel.fontColor = SKColor.white
        lableLevel.position = trophy.position
        lableLevel.zPosition = 200
        addChild(lableLevel)
        
        Background.movePointsIn(scene: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if buttonLevel.contains(touch.location(in: self)) {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                let gameScene = scene as! GameScene
                    gameScene.setLevelAndSubLevel(level: level+1, subLevel: 1)
                    
                self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
            }
        }
    }
    
    func setLevel(level: Int){
        self.level = level
    }
}
