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
        
        let semiCircle = SKShapeNode(path: bezierPath.cgPath)
        semiCircle.strokeColor = color
        semiCircle.fillColor = color
        semiCircle.lineWidth = 0
        semiCircle.position = position
        addChild(semiCircle)
        
        let mutablePath: CGMutablePath = CGMutablePath()
        mutablePath.move(to: position)
        mutablePath.addLine(to: CGPoint(x: position.x + cos(startAngle) * radius, y: position.y + sin(startAngle)*radius))
        mutablePath.addLine(to: CGPoint(x: position.x + cos(endAngle) * radius, y: position.y + sin(endAngle)*radius))
        
        let triangle = SKShapeNode(path: mutablePath)
        triangle.strokeColor = color
        triangle.fillColor = color
        triangle.lineWidth = 0
        addChild(triangle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getAngle() -> CGFloat {
        let startAngleInDegrees = CGFloat.radiansToDegrees(radians: startAngle)
        let endAngleInDegrees = CGFloat.radiansToDegrees(radians: endAngle)
        let angleInDegrees = endAngleInDegrees - startAngleInDegrees
        let rotationInDegrees = CGFloat.radiansToDegrees(radians: self.zRotation)
        return CGFloat.degreesToRadians(degrees: startAngleInDegrees + angleInDegrees/2 + rotationInDegrees)
    }
    
    func getPoint() -> CGPoint {
        return CGPoint(x: position.x + cos(getAngle()) * (radius/2), y: position.y + sin(getAngle())*(radius/2))
    }
    
    func impulse() -> SKShapeNode{
        self.removeAllChildren()
        let circle = SKShapeNode(circleOfRadius: self.radius/2)
        circle.physicsBody = SKPhysicsBody.init(circleOfRadius: self.radius/2)
        circle.physicsBody?.affectedByGravity = false
        circle.physicsBody?.categoryBitMask = 1
        circle.physicsBody?.collisionBitMask = 2
        circle.physicsBody?.contactTestBitMask = 2
        circle.zPosition = 1
        circle.position = getPoint()
        circle.fillColor = self.color
        circle.strokeColor = self.color
        circle.name = "circle"
        self.addChild(circle)
        
        let move = SKAction.applyImpulse(CGVector.init(dx: 15 * getPoint().x, dy: 15 * getPoint().y), duration: 1)
        
        circle.run(move)
        return circle
    }
    
}
