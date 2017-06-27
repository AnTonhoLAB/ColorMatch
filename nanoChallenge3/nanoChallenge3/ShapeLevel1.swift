//
//  ShapeLevel1.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 27/06/17.
//
//

import SpriteKit

class ShapeLevel1: SKShapeNode{
    
    var radius:CGFloat!
    
    init(radius: CGFloat, colors: [UIColor]) {
        super.init()
        
        let angle = Double(360/colors.count)
        
        var currentAngle = 90.0
        
        for index in 0..<colors.count {
            
            let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: CGFloat(currentAngle * (Double.pi/180)), endAngle: CGFloat((currentAngle + angle) * (Double.pi/180)), clockwise: true)
            
            let pathNode = SKShapeNode(path: bezierPath.cgPath)
            pathNode.strokeColor = colors[index]
//            pathNode.fillColor = colors[index]
            pathNode.lineWidth = radius * 0.2
            pathNode.position = position

            
            addChild(pathNode)
            
//            let node = SKShapeNode()
//            node.addChild(pathNode)
//            node.strokeColor = colors[index]
//            
//            addChild(node)
            
            currentAngle += angle
        }
    }
    
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees*CGFloat(Double.pi/180)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
