//
//  ShapeLevel1.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 27/06/17.
//
//

import SpriteKit

class ShapeArc: SKShapeNode{
    
    init(radius: CGFloat, colors: [UIColor]) {
        super.init()
        
        let angle = Double(360/colors.count)
        
        var currentAngle = 90.0
        
        for index in 0..<colors.count {
            
            if colors[index] != UIColor.clear {
                let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: CGFloat(currentAngle * (Double.pi/180)), endAngle: CGFloat((currentAngle + angle) * (Double.pi/180)), clockwise: true)
                
                let arc = SKShapeNode(path: bezierPath.cgPath)
                arc.strokeColor = colors[index]
                arc.lineWidth = radius * 0.2
                arc.position = position
                
                addChild(arc)
            }
            
            currentAngle += angle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
