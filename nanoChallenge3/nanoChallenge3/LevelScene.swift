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
    
    
    
    override func didMove(to view: SKView) {
        
        
        
        
        var lastUnlockedLevel = 1
        var lastUnlockedSublevel = 1
        
        var button11 =  SKSpriteNode (imageNamed: "level1.1")
        var button12 =  SKSpriteNode (imageNamed: "level1.2")
        var button13 =  SKSpriteNode (imageNamed: "level1.3")
        
        var button21 = SKSpriteNode (imageNamed: "level2.1")
        var button22 = SKSpriteNode (imageNamed: "level2.2")
        var button23 = SKSpriteNode (imageNamed: "level2.3")
        
//        var button31 = SKSpriteNode (imageNamed: "level2.2")
//        var button32 =  SKSpriteNode (imageNamed: "level2.2")
//        var button33 =  SKSpriteNode (imageNamed: "level2.2")
//        
//        var button41 =  SKSpriteNode (imageNamed: "level2.2")
//        var button42 = SKSpriteNode (imageNamed: "level2.2")
//        var button43 = SKSpriteNode (imageNamed: "level2.2")
//        
        
        var arrayLevels1 = [button11, button12, button13]
        var arrayLevels2 = [button21, button22, button23]
//        var arrayLevels3 = [button31, button32, button33]
//        var arrayLevels4 = [button41, button42, button43]
//        
        
        var initialX = self.size.width/2
        var cont = 0
        var cont2 = 0
       
        for cont in 1..<5
        {
            for cont2 in 1..<4
            {
                
            
            }
        }
        
        
        button22.position = CGPoint(x: 0, y: 0)
        button22.texture = SKTexture.init(imageNamed: "level2.2")
        button22.xScale = 2
        button22.yScale = 2
        
        background.position = CGPoint(x: 0.5, y: 0.5)
        //back.scaleMode = .aspectFill
        background.size.width = self.size.width
        background.size.height = self.size.height
        addChild(background)
        addChild(button22)
    }
    
    
    
    

}
