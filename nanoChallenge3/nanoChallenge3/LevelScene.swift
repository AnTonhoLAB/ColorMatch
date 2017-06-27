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
        let lineSpace: CGFloat = 25
        
        var initialX: CGFloat!
        var currentX: CGFloat!
        
        var initialY: CGFloat!
        
        for level in 1...4
        {
            
            var subLevels = [SKSpriteNode]()
            
            for subLevel in 1...3
            {
                var imageName: String!
                if level > lastUnlockedLevel!{
                    imageName = "Level_\(level)_locked"
                }
                else if level == lastUnlockedLevel! && subLevel > lastUnlockedSublevel!{
                    imageName = "Level_\(level)_locked"
                }
                else{
                    imageName = "Level_\(level).\(subLevel)"
                }
                
                let button = SKSpriteNode(imageNamed: imageName)
                
                button.xScale = 2
                button.yScale = 2
                
                if(level == 1 && subLevel == 1){
                    size = button.size.width
                    initialX = -1*(size + lineSpace)
                    currentX = initialX
                    
                    initialY = size
                }
                
                button.size = CGSize(width: size, height: size)
                
                button.position = CGPoint(x: currentX, y: initialY)
                
                currentX = currentX + lineSpace + button.size.width
                
                subLevels.append(button)
                self.addChild(button)
                
            }
            
            buttons.append(subLevels)
            
            currentX =   initialX
            
            initialY = initialY - size - 12.5
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        for (level,buttonsLevel) in buttons.enumerated() {
            for (subLevel,buttonSubLevel) in buttonsLevel.enumerated() {
                if level+1 > lastUnlockedLevel!{
                    break
                }
                else if level+1 == lastUnlockedLevel! && subLevel+1 > lastUnlockedSublevel!{
                    break
                }
                else if buttonSubLevel.contains(touch.location(in: self)) {
                    if let scene = SKScene(fileNamed: "GameScene") {
                        scene.scaleMode = .aspectFill
                        
                        let gameScene = scene as! GameScene
                        gameScene.fixLevelAccordingToLevelScreen(level: level+1, subLevel: subLevel+1)
                        
                        
                        self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                    }
                }
            }
            
        }
    }
}
