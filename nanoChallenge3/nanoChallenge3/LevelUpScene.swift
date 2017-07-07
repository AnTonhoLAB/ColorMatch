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
        self.backgroundColor = UIColor.white
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        var fontSize = CGFloat(40)
        var yPositionTrophy = CGFloat(40)
        var distanceItems = CGFloat(35)
        let distanceItemsToBorder = CGFloat(35)
        
        let trophy = SKSpriteNode(imageNamed: "Trophy")
        let levelUp = SKSpriteNode(imageNamed: "LevelUp")
        buttonLevel = SKSpriteNode(imageNamed: "Button_Level")
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            trophy.xScale = 2
            trophy.yScale = 2
            
            levelUp.xScale = 2
            levelUp.yScale = 2
            
            buttonLevel.xScale = 2
            buttonLevel.yScale = 2
            
            fontSize = CGFloat(72)
            
            yPositionTrophy = CGFloat(80)
            
            distanceItems = CGFloat(35)
        }
        
        
        trophy.position = CGPoint(x: 0, y: -yPositionTrophy)
        levelUp.position = CGPoint(x: 0, y: trophy.position.y + trophy.size.height/2 + levelUp.size.height/2 + distanceItems)
        buttonLevel.position = CGPoint(x: 0, y: trophy.position.y - trophy.size.height/2 - buttonLevel.size.height/2 - distanceItems)
        
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: buttonLevel.size.width + distanceItemsToBorder*2, height: levelUp.size.height + trophy.size.height + buttonLevel.size.height + distanceItemsToBorder*2 + distanceItems*2), cornerRadius: 20)
        rectangle.lineWidth = 5
        rectangle.strokeColor = UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 215.0/255.0, alpha: 1)
        
        rectangle.position = CGPoint(x: -rectangle.frame.size.width/2 + 2.5, y: -rectangle.frame.size.height/2 + 2.5)
        addChild(rectangle)
        
        let labelLevel = SKLabelNode()
        labelLevel.text = "\(level+1)"
        labelLevel.fontName = "QanelasSoftDEMO-ExtraBold"
        labelLevel.fontSize = fontSize
        labelLevel.fontColor = SKColor.white
        labelLevel.position = CGPoint(x: 0, y: trophy.position.y)
        
        trophy.zPosition = 100
        levelUp.zPosition = 100
        buttonLevel.zPosition = 100
        labelLevel.zPosition = trophy.zPosition+1
        
        addChild(trophy)
        addChild(levelUp)
        addChild(buttonLevel)
        addChild(labelLevel)
        
        Background.applyIn(scene: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if buttonLevel.contains(touch.location(in: self)) {
            let gameScene = GameScene(size: self.frame.size)
            gameScene.scaleMode = .aspectFill
            gameScene.setLevelAndSubLevel(level: level+1, subLevel: 1)
            
            self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
        }
    }
    
    func setLevel(level: Int){
        self.level = level
    }
}
