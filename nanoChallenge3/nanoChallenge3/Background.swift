//
//  Background.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 27/06/17.
//

import SpriteKit

class Background {
    static func movePointsIn(scene: SKScene){
        for (index, child) in scene.children.enumerated(){
            let rotate1 = SKAction.rotate(byAngle: -1*CGFloat(Double.pi*2), duration: 3)
            let rotate2 = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 3)
            if child.name == "point" {
                if let point = child as? SKSpriteNode{
                    point.anchorPoint = CGPoint(x: 0, y: 0)
                    if index % 2 == 0{
                        let forever = SKAction.repeatForever(rotate1)
                        point.run(forever)
                    }
                    else{
                        let forever = SKAction.repeatForever(rotate2)
                        point.run(forever)
                    }
                }
            }
        }
    }
}
