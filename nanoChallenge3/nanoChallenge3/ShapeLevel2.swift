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
        
        var zRotation = CGFloat(0)
        
        for color in 0..<colors.count{
            for index in 1...numberOfNodesInEachColor[color]*2{
                if index % 2 == 0 && colors[color] != UIColor.clear {
                    currentAngleInRadians = CGFloat.degreesToRadians(degrees: currentAngleInDegrees)
                    
                    let point = CGPoint(x: position.x + cos(currentAngleInRadians) * radius, y: position.y + sin(currentAngleInRadians)*radius)
                    
                    let dash = SKShapeNode(rect: CGRect(x: 0, y: 0, width: widthNodes, height: widthNodes*3), cornerRadius: widthNodes/2 - 0.1)
                    dash.fillColor = colors[color]
                    dash.strokeColor = colors[color]
                    dash.position = point
                    dash.zRotation = zRotation
                    
                    addChild(dash)
                    zRotation += CGFloat.degreesToRadians(degrees: spacing*2)
                }
                
                currentAngleInDegrees += spacing
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
