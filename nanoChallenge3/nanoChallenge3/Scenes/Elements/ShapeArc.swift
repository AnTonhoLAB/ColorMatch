//
//  ShapeArc.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 27/06/17.
//
//

import SpriteKit

class ShapeArc: SKShapeNode{
    
    var counterclockwise = false
    var timeToTurn: Double!
    var times: Int!
    
    init(radius: CGFloat, ringWidth: CGFloat, block: Block) {
        super.init()
        
        self.name = "arc"
        
        if block.speed < 0 {
            counterclockwise = true
        }
        
        timeToTurn = abs(block.speed)
        
        self.times = block.times
        
        let angle = Double(360/block.colorsInt.count)
        
        var currentAngle = 90.0
        
        for index in 0..<block.colorsInt.count {
            
            if block.colorsInt[index] >= 0 {
                
                let radius2 = radius + ringWidth
                
                let startAngle = CGFloat.degreesToRadians(degrees: CGFloat(90 + angle/2))
                let endAngle = CGFloat.degreesToRadians(degrees: CGFloat(90 - angle/2))
                
                let path = CGMutablePath()
                path.addArc(center: CGPoint(x: 0, y: 0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                path.addArc(center: CGPoint(x: 0, y: 0), radius: radius2, startAngle: endAngle, endAngle: startAngle, clockwise: false)
                
                let arc = SKShapeNode(path: path)
                arc.fillColor = Preferences.colors[block.colorsInt[index]]
                arc.strokeColor = Preferences.colors[block.colorsInt[index]]
                arc.lineWidth = 1
                arc.physicsBody = SKPhysicsBody(polygonFrom: path)
                arc.physicsBody?.affectedByGravity = false
                arc.physicsBody?.allowsRotation = false
                arc.physicsBody?.isDynamic = false
                arc.physicsBody?.pinned = false
                arc.zRotation = CGFloat.degreesToRadians(degrees: CGFloat(currentAngle - angle/2))
                
                arc.physicsBody?.categoryBitMask = Preferences.arcBitMask
                arc.physicsBody?.collisionBitMask = Preferences.circleBitMask
                arc.physicsBody?.contactTestBitMask = Preferences.circleBitMask
                
                addChild(arc)
            }
            
            currentAngle += angle
        }
    }
    
    func run(){
        if timeToTurn > 0 {
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
            
            self.run(forever)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
