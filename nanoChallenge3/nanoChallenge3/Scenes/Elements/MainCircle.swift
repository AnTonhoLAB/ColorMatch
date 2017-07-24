//
//  MainCircle.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 20/07/17.
//

import SpriteKit

class MainCircle: SKNode{
    
    var counterclockwise = false
    var timeToTurn: Double!
    var times: Int!
    
    init(block: Block, radius: CGFloat) {
        super.init()
        
        self.timeToTurn = abs(block.speed)
        
        self.counterclockwise = block.speed < 0 ? true : false
        
        self.times = block.times
        
        let angle = Double(360/block.colorsInt.count)
        
        var currentAngle = 90.0
        
        for index in 0..<block.colorsInt.count {
            let subShape = SubShapeMainCircle(radius: radius, startAngle: CGFloat(currentAngle) * (CGFloat.pi/180), endAngle: CGFloat(currentAngle + angle) * (CGFloat.pi/180), color: Preferences.colors[block.colorsInt[index]])
            addChild(subShape)
            currentAngle += angle
        }
    }
    
    func run(){
        let rotate = counterclockwise ? -1 * CGFloat.pi*2 : CGFloat.pi*2
        
        let normalRotation = SKAction.rotate(byAngle: rotate, duration: timeToTurn)
        
        
        var forever: SKAction!
        
        if times > 0{
            let oppositeRotation = normalRotation.reversed()
            
            let normalRotationRepeat = SKAction.repeat(normalRotation, count: times)
            let oppositeRotationRepeat = SKAction.repeat(oppositeRotation, count: times)
            
            let repeating = SKAction.sequence([normalRotationRepeat, oppositeRotationRepeat])
            forever = SKAction.repeatForever(repeating)
        }
        else{
            forever = SKAction.repeatForever(normalRotation)
        }
        
        for child in children{
            let subShape = child as! SubShapeMainCircle
            subShape.run(forever)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
