//
//  LevelScene.swift
//  nanoChallenge3
//
//  Created by Laura Corssac on 26/06/17.
//
//


import SpriteKit
import GameplayKit

class LevelScene: SKScene {
    
    var buttons = [[SKSpriteNode]]()
    
    var buttonBack: SKSpriteNode!
    
    var lastUnlockedLevel: Int!
    var lastUnlockedSublevel: Int!
    
    override func didMove(to view: SKView) {
        
        lastUnlockedLevel = UserDefaultsManager.getCurrentUserInfo(info: .CurrentLevel)
        lastUnlockedSublevel = UserDefaultsManager.getCurrentUserInfo(info: .CurrentSubLevel)
        
        let levelsTitle = SKSpriteNode(imageNamed: "Levels")
        levelsTitle.xScale = 2
        levelsTitle.yScale = 2
        levelsTitle.position = CGPoint(x: 0, y: (self.view?.frame.size.height)!/2 + levelsTitle.size.height/2)
        levelsTitle.zPosition = 100
        addChild(levelsTitle)
        
        var size: CGFloat!
        let columnSpace = CGFloat(25)
        let lineSpace = CGFloat(25)
        
        var initialX: CGFloat!
        var currentX: CGFloat!
        
        var initialY: CGFloat!
        
        for numberLevel in 1...4
        {
            let level = World.getLevel(level: numberLevel)
            var subLevels = [SKSpriteNode]()
            
            for subLevelNumber in 1...3
            {
                var texture: SKTexture!
                if (numberLevel > lastUnlockedLevel!) || (numberLevel == lastUnlockedLevel! && subLevelNumber > lastUnlockedSublevel!){
                    texture = level?.getSubLevel(subLevel: subLevelNumber)?.getLockedTextureWith(scene: self)
                }
                else{
                    texture = level?.getSubLevel(subLevel: subLevelNumber)?.getUnlockedTextureWith(scene: self)
                }
                
                let button = SKSpriteNode(texture: texture)
                
                if(numberLevel == 1 && subLevelNumber == 1){
                    size = button.size.width
                    initialX = -1*(size + columnSpace)
                    currentX = initialX
                    
                    initialY = size
                }
                
                button.position = CGPoint(x: currentX, y: initialY)
                //                button.size = CGSize(width: size, height: size)
                
                currentX = currentX + columnSpace + button.size.width
                
                subLevels.append(button)
                self.addChild(button)
                
            }
            
            buttons.append(subLevels)
            
            currentX =   initialX
            
            initialY = initialY - size - lineSpace
            
        }
        Background.movePointsIn(scene: self)
        
        buttonBack = SKSpriteNode(imageNamed: "Back")
        buttonBack.position = CGPoint(x: -(view.frame.size.width)+buttonBack.size.width/2+25, y: (view.frame.size.height)-(buttonBack.size.height+25))
        addChild(buttonBack)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        for (level,buttonsLevel) in buttons.enumerated() {
            for (subLevel,buttonSubLevel) in buttonsLevel.enumerated() {
                if (level+1 > lastUnlockedLevel!) || (level+1 == lastUnlockedLevel! && subLevel+1 > lastUnlockedSublevel!){
                    break
                }
                else if buttonSubLevel.contains(touch.location(in: self)) {
                    if let scene = SKScene(fileNamed: "GameScene") {
                        scene.scaleMode = .aspectFill
                        let gameScene = scene as! GameScene
                        gameScene.setLevelAndSubLevel(level: level+1, subLevel: subLevel+1)
                        self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                    }
                }
            }
        }
        
        if buttonBack.contains(touch.location(in: self)) {
            if let scene = SKScene(fileNamed: "MainScene") {
                scene.scaleMode = .aspectFill
                let mainScene = scene as! MainScene
                mainScene.createMenuScene()
                self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
            }
        }
        
    }
}
