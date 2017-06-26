//
//  OutCircleShape.swift
//  nanoChallenge3
//
//  Created by Douglas Gehring on 23/06/17.
//
//

import SpriteKit

class OutCircleShape:SKShapeNode {
    
    var color:UIColor!
    var correctedPosition:CGPoint!
    var initialPosition:CGPoint!
    var finalPosition:CGPoint!
    var radius:CGFloat!
    var startAngle:CGFloat!
    var endAngle:CGFloat!
    
    var angleArray:[CGPoint] = []
    
    init(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        super.init()
        
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let pathNode = SKShapeNode(path: bezierPath.cgPath)
        pathNode.strokeColor = color
        //pathNode.fillColor = .white
        pathNode.lineWidth = 30
        pathNode.position = position
        
        self.initialPosition = CGPoint(x: (position.x + cos(startAngle)*radius), y: (position.y + sin(startAngle)*radius))
        
        self.finalPosition = CGPoint(x: (position.x + cos(endAngle) * radius), y:(position.y + sin(endAngle)*radius))
        
        
        let correctedX = (self.initialPosition.x + self.finalPosition.x) / 2
        
        let correctedY = (self.initialPosition.y + self.finalPosition.y) / 2
        
        self.correctedPosition = CGPoint(x: correctedX, y: correctedY)
        self.radius = radius
        self.color = color
        addChild(pathNode)
        
        self.startAngle = startAngle
        self.endAngle = endAngle
        
        self.getPointPerAngle()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getPointPerAngle(){
        
        var startAngleCounter = Float(self.startAngle)
        var endAngleCounter = Float(self.endAngle)
        
        var end = false
        
        while(!end){
            
            self.angleArray.append(CGPoint(x: (position.x + cos(CGFloat(startAngleCounter))*radius), y: (position.y + sin(CGFloat(startAngleCounter))*radius)))
            
            if(Float(startAngleCounter) >= Float(endAngleCounter)){
                
                end = true
            }else{
                
                startAngleCounter+=0.00001
            }
            
        }
        
        
    }
    
    
    
}
