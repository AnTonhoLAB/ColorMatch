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
    
    var radius = CGFloat()
    var velocity = TimeInterval(exactly: 0.2)
    
    override func didMove(to view: SKView) {
        
        let testShape = ShapeLevel2(radius: (self.view?.frame.size.width)! * 0.60, colors: [
            UIColor(red: 255.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1),
            UIColor(red: 255.0/255.0, green: 190.0/255.0, blue: 71.0/255.0, alpha: 1),
            UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 215.0/255.0, alpha: 1)], numberOfNodesInEachColor: [4, 10, 10])
        
        addChild(testShape)
        
        radius = (self.view?.frame.size.width)! * 0.20
        
        circle.position = CGPoint(x: 0, y: 0)
        
        createSubShapesWith(number: 3)
        
        for subShape in subShapes {
            circle.addChild(subShape)
        }
        
        addChild(circle)
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 2)
        let forever = SKAction.repeatForever(rotate)
        circle.run(forever)
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
        circle.removeAllActions()
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
