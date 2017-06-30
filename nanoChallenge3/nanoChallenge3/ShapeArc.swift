//
//  ShapeLevel1.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 27/06/17.
//
//

import SpriteKit

class ShapeArc: SKShapeNode{
    
    init(radius: CGFloat, ringWidth: CGFloat, colorsInt: [Int]) {
        super.init()
        
        let angle = Double(360/colorsInt.count)
        
        var currentAngle = 90.0
        
        for index in 0..<colorsInt.count {
            
            if colorsInt[index] >= 0 {
                
                let radius2 = radius + ringWidth
                
                let startAngle = CGFloat.degreesToRadians(degrees: CGFloat(90 + angle/2))
                let endAngle = CGFloat.degreesToRadians(degrees: CGFloat(90 - angle/2))
                
                let path = CGMutablePath()
                path.addArc(center: CGPoint(x: 0, y: 0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                path.addArc(center: CGPoint(x: 0, y: 0), radius: radius2, startAngle: endAngle, endAngle: startAngle, clockwise: false)
                
                let arc = SKShapeNode(path: path)
                arc.fillColor = GamePreferences.colors[colorsInt[index]]
                arc.strokeColor = GamePreferences.colors[colorsInt[index]]
                arc.lineWidth = 1
                arc.physicsBody = SKPhysicsBody(polygonFrom: path)
                arc.physicsBody?.affectedByGravity = false
                arc.physicsBody?.allowsRotation = false
                arc.physicsBody?.isDynamic = false
                arc.physicsBody?.pinned = false
                arc.zRotation = CGFloat.degreesToRadians(degrees: CGFloat(currentAngle - angle/2))
                
                addChild(arc)
            }

            currentAngle += angle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
