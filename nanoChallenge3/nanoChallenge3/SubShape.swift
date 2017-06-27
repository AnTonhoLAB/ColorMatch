//
//  SubShapes.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 22/06/17.
//
//

import SpriteKit

class SubShape: SKShapeNode{
    
    var color:UIColor!
    var positionCorrected:CGPoint!
    
    
    
    init(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        super.init()
        
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let pathNode = SKShapeNode(path: bezierPath.cgPath)
        pathNode.strokeColor = color
        pathNode.fillColor = color
        pathNode.lineWidth = 0
        pathNode.position = position
        
        self.color = color
        
        addChild(pathNode)
        
        let line_path: CGMutablePath = CGMutablePath()
        line_path.move(to: position)
        
        line_path.addLine(to: CGPoint(x: position.x + cos(startAngle) * radius, y: position.y + sin(startAngle)*radius))
        
        line_path.addLine(to: CGPoint(x: position.x + cos(endAngle) * radius, y: position.y + sin(endAngle)*radius))
        
        var correctedX = ((position.x + cos(startAngle)*radius) + (position.x + cos(endAngle) * radius)) / 2
        
        correctedX *= 2
        
        var correctedY = ((position.y + sin(startAngle)*radius) + (position.y + sin(endAngle)*radius)) / 2
        
        correctedY *= 2
        
        positionCorrected = CGPoint(x: correctedX, y: correctedY)

        
        
        
        
        let linePathNode = SKShapeNode(path: line_path)
        
        linePathNode.strokeColor = color
        linePathNode.fillColor = color
        linePathNode.lineWidth = 0
        
        addChild(linePathNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
