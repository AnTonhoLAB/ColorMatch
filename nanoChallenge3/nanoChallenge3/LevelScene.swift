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
    var background = SKSpriteNode(imageNamed:"Background")
    
    var buttons = [[SKSpriteNode]]()
    
    var lastUnlockedLevel = 1
    var lastUnlockedSublevel = 1
    
    override func didMove(to view: SKView) {
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
        
        for level in 0..<4
        {
            
            var subLevels = [SKSpriteNode]()
            
            for subLevel in 0..<3
            {
                let imageName = "Level_\(level+1).\(subLevel+1)"
                
                let button = SKSpriteNode(imageNamed: imageName)
                
                button.xScale = 3
                button.yScale = 3
                
                if(level == 0 && subLevel == 0){
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
        
        background.size.width = self.size.width
        background.size.height = self.size.height
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        for (level,buttonsLevel) in buttons.enumerated() {
            for (subLevel,buttonSubLevel) in buttonsLevel.enumerated() {
                if buttonSubLevel.contains(touch.location(in: self)) {
//                    buttonSubLevel.texture = SKTexture(imageNamed: "")
                    if let scene = SKScene(fileNamed: "GameScene") {
                        scene.scaleMode = .aspectFill
                        
                        print("Level: \(level+1) SubLevel: \(subLevel+1)")
                        
                        self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                    }
                }
            }
            
        }
    }
    
    
    
    
    
}
