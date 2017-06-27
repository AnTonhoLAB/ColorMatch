//
//  SubShape2.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 23/06/17.
//
//

import SpriteKit

class ShapeLevel2: SKShapeNode{
    
    var radius:CGFloat!
    
    init(radius: CGFloat, colors: [UIColor], numberOfNodesInEachColor: [Int]) {
        super.init()
        
        var numberOfNodes = CGFloat(0)
        
        for number in numberOfNodesInEachColor{
            numberOfNodes += CGFloat(number)
        }
        
        self.radius = radius
        
        numberOfNodes *= 2
        
        let spacing = 360/numberOfNodes
        
        let perimeter = CGFloat(2*Double.pi)*radius
        
        let widthNodes = perimeter/numberOfNodes
        
        var currentAngleInDegrees = CGFloat(90)
        var currentAngleInRadians = CGFloat()
        
        var zRotation = CGFloat(0)
        
        for color in 0..<colors.count{
            for index in 1...numberOfNodesInEachColor[color]*2{
                if index % 2 == 0 && colors[color] != UIColor.clear {
                    currentAngleInRadians = degreesToRadians(degrees: currentAngleInDegrees)
                    
                    let point = CGPoint(x: position.x + cos(currentAngleInRadians) * radius, y: position.y + sin(currentAngleInRadians)*radius)
                    
                    let trace = SKShapeNode(rect: CGRect(x: 0, y: 0, width: widthNodes, height: widthNodes*3), cornerRadius: widthNodes/2 - 0.1)
                    trace.fillColor = colors[color]
                    trace.strokeColor = colors[color]
                    trace.position = point
                    trace.zRotation = zRotation
                    zRotation += degreesToRadians(degrees: spacing*2)
                    
                    addChild(trace)
                    
//                    let circle = SKShapeNode(circleOfRadius: widthNodes/2)
//                    circle.fillColor = colors[color]
//                    circle.position = point
//                    circle.zRotation = zRotation
//                    
//                    addChild(circle)
                }
                
                currentAngleInDegrees += spacing
            }
        }
    }
    
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees*CGFloat(Double.pi/180)
    }
    
    func radiansToDegrees(radians: CGFloat) -> CGFloat {
        return CGFloat(radians/180)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
