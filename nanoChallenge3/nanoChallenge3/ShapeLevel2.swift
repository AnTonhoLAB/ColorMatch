//
//  SubShape2.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 23/06/17.
//
//

import SpriteKit

class ShapeLevel2: SKShapeNode{
    
    init(radius: CGFloat, colors: [UIColor], numberOfNodesInEachColor: [Int]) {
        super.init()
        
        var numberOfNodes = CGFloat(0)
        
        for number in numberOfNodesInEachColor{
            numberOfNodes += CGFloat(number)
        }
        
        numberOfNodes *= 2
        
        let spacing = 360/numberOfNodes
        
        let perimeter = CGFloat(2*Double.pi)*radius
        
        let widthNodes = perimeter/numberOfNodes
        
        var currentAngleInDegrees = CGFloat(90)
        var currentAngleInRadians = CGFloat()
        
        for color in 0..<colors.count{
            for index in 1...numberOfNodesInEachColor[color]*2{
                if index % 2 == 0 && colors[color] != UIColor.clear {
                    currentAngleInRadians = degreesToRadians(degrees: currentAngleInDegrees)
                    
                    let point = CGPoint(x: position.x + cos(currentAngleInRadians) * radius, y: position.y + sin(currentAngleInRadians)*radius)
                    
                    let circle = SKShapeNode(circleOfRadius: widthNodes/2)
                    circle.fillColor = colors[color]
                    circle.position = point
                    
                    addChild(circle)
                }
                
                currentAngleInDegrees += spacing
            }
        }
    }
    
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees*CGFloat(Double.pi/180)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
