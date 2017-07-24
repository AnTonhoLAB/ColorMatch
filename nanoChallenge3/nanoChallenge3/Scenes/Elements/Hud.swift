//
//  Hud.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 19/07/17.
//

import SpriteKit

class Hud: SKNode {
    
    init(with level: Level, and size: CGSize) {
        super.init()
        
        let topLayout = SKSpriteNode(imageNamed: "Level_\(level.color)_Top")
        let downLayout = SKSpriteNode(imageNamed: "Level_\(level.color)_Down")
        
        let scaleLayout = size.width/topLayout.size.width
        
        topLayout.xScale = scaleLayout
        topLayout.yScale = scaleLayout
        
        downLayout.xScale = scaleLayout
        downLayout.yScale = scaleLayout
        
        topLayout.position = CGPoint(x: 0, y: size.height/2 - topLayout.size.height/2)
        downLayout.position = CGPoint(x: 0, y: -(size.height/2) + downLayout.size.height/2)
        
        addChild(topLayout)
        addChild(downLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
