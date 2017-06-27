//
//  SubShapes.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 22/06/17.
//
//

import SpriteKit

class SubShape: SKShapeNode{
    
    var startAngle: CGFloat!
    var endAngle: CGFloat!
    var radius: CGFloat!
    var color: UIColor!
    
    init(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        super.init()
        self.radius = radius
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.color = color
        
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let pathNode = SKShapeNode(path: bezierPath.cgPath)
        pathNode.strokeColor = color
        pathNode.fillColor = color
        pathNode.lineWidth = 0
        pathNode.position = position
        
        addChild(pathNode)
        
        let line_path: CGMutablePath = CGMutablePath()
        line_path.move(to: position)
        
        line_path.addLine(to: CGPoint(x: position.x + cos(startAngle) * radius, y: position.y + sin(startAngle)*radius))
        
        line_path.addLine(to: CGPoint(x: position.x + cos(endAngle) * radius, y: position.y + sin(endAngle)*radius))
        
        let linePathNode = SKShapeNode(path: line_path)
        
        linePathNode.strokeColor = color
        linePathNode.fillColor = color
        linePathNode.lineWidth = 0
        
        addChild(linePathNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees*CGFloat(Double.pi/180)
    }
    
    func radiansToDegrees(radians: CGFloat) -> CGFloat {
        return CGFloat((radians*180)/CGFloat(Double.pi))
    }
    
    func getAngle() -> CGFloat {
        let startAngleInDegrees = radiansToDegrees(radians: startAngle)
        let endAngleInDegrees = radiansToDegrees(radians: endAngle)
        let angleInDegrees = endAngleInDegrees - startAngleInDegrees
        let rotationInDegrees = radiansToDegrees(radians: self.zRotation)
        return degreesToRadians(degrees: startAngleInDegrees + angleInDegrees/2 + rotationInDegrees)
    }
    
    func getPoint() -> CGPoint {
        return CGPoint(x: position.x + cos(getAngle()) * (radius/2), y: position.y + sin(getAngle())*(radius/2))
    }
    
}
