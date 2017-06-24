//
//  GameScene.swift
//  nanoChallenge3
//
//  Created by George Vilnei Arboite Gomes on 22/06/17.
//
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let colors = [UIColor(red: 255.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1),
                  UIColor(red: 255.0/255.0, green: 190.0/255.0, blue: 71.0/255.0, alpha: 1),
                  UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 215.0/255.0, alpha: 1), UIColor.red, UIColor.blue, UIColor.yellow, UIColor.green, UIColor.cyan, UIColor.brown, UIColor.lightGray]
    
    var circle = SKShapeNode()
    
    var subShapes = [SubShape]()
    
    var clicks = 0
    
    var radius = CGFloat()
    var began = false
    var velocity = TimeInterval(exactly: 0.2)
    
    override func didMove(to view: SKView) {
        
        
        
        radius = (self.view?.frame.size.width)! * 0.20
        
        circle.position = CGPoint(x: 0, y: -view.frame.size.height/2)
        
        createSubShapesWith(number: 3)
        
        for subShape in subShapes {
            circle.addChild(subShape)
        }
        
        addChild(circle)
    }
    
    func createSubShapesWith(number: Int){
        let angle = Double(360/number)
        
        var currentAngle = 90.0
        
        for index in 0..<number {
            let subShape = SubShape(radius: radius, startAngle: CGFloat(currentAngle * (Double.pi/180)), endAngle: CGFloat((currentAngle + angle) * (Double.pi/180)), color: colors[index])
            subShapes.append(subShape)
            currentAngle += angle
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clicks += 1
        
        if clicks == 1 {
            began = true
            
            let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 2)
            let forever = SKAction.repeatForever(rotate)
            circle.run(forever)
            
            let move = SKAction.move(to: CGPoint(x: 0, y: (self.view?.frame.size.height)!/2), duration: 5)
            circle.run(move)
        }
        else if clicks == 2 {
//            for subShape in subShapes{
//                let move = SKAction.move(to: CGPoint(x: subShape.position.x + cos(circle.zRotation) * 200, y: subShape.position.y + sin(circle.zRotation)*200), duration: 5)
//
//                    subShape.run(move)
//            }
            
            began = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
