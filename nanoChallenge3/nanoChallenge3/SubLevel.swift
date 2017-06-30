//
//  Level.swift
//  ReadJason
//
//  Created by Eduardo Fornari on 29/06/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import Foundation
import SpriteKit

struct Block {
    var speed: Double
    var colorsInt: [Int]
    
    init(speed: Double, colorsInt: [Int]) {
        self.speed = speed
        self.colorsInt = colorsInt
    }
}

public class SubLevel {
    
    let blocks: [Block]!
    
    init(subLevelJson: [[String : Any]]) {
        var blocks = [Block]()
        
        for block in subLevelJson{
            let blockSpeed = block["speed"] as! Double
            let blockColorsNSArray = block["colors"] as? NSArray
            
            var blockColorsInt = [Int]()
            
            for color in blockColorsNSArray! {
                if let colorTemp = color as? [String: Int] {
                    let colorInt = colorTemp["color"]!
                    blockColorsInt.append(colorInt)
                }
            }
            blocks.append(Block(speed: blockSpeed, colorsInt: blockColorsInt))
        }
        self.blocks = blocks
    }
    
    func printBlocks(){
        for block in self.blocks{
            print("Speed = \(block.speed) - ColorsInt = \(block.colorsInt)")
        }
    }
    
    func applySubLevelInScene(scene: SKScene) -> [SubShape]? {
        
        var subShapesMainCircle: [SubShape]?
        
        let totalRadius = ((scene.view?.frame.size.width)!)*0.6
        let ringWidth = totalRadius*0.2
        
        for (index, block) in blocks.enumerated() {
            if index == 0{
                subShapesMainCircle = createMainCircle(block: block, radius: (totalRadius/CGFloat(blocks.count-1)) * 0.3, scene: scene)
            }
            else {
                createRing(block: block, radius: totalRadius/CGFloat(index), ringWidth: ringWidth, scene: scene)
            }
        }
        
        return subShapesMainCircle
    }
    
    func createMainCircle(block: Block, radius: CGFloat, scene: SKScene) -> [SubShape]{
        let speed = abs(block.speed)
        let rotationAngle = block.speed < 0 ? -1 * CGFloat(Double.pi*2) : CGFloat(Double.pi*2)
        
        let rotate = SKAction.rotate(byAngle: rotationAngle, duration: speed)
        let forever = SKAction.repeatForever(rotate)
        
        let angle = Double(360/block.colorsInt.count)
        
        var currentAngle = 90.0
        
        var subShapesMainCircle = [SubShape]()
        
        for index in 0..<block.colorsInt.count {
            let subShape = SubShape(radius: radius, startAngle: CGFloat(currentAngle * (Double.pi/180)), endAngle: CGFloat((currentAngle + angle) * (Double.pi/180)), color: GamePreferences.colors[block.colorsInt[index]])
            subShape.run(forever)
            scene.addChild(subShape)
            currentAngle += angle
            
            subShapesMainCircle.append(subShape)
        }
        return subShapesMainCircle
    }
    
    func createRing(block: Block, radius: CGFloat, ringWidth: CGFloat, scene: SKScene){
        let speed = abs(block.speed)
        let rotationAngle = block.speed < 0 ? -1 * CGFloat(Double.pi*2) : CGFloat(Double.pi*2)
        
        let rotate = SKAction.rotate(byAngle: rotationAngle, duration: speed)
        let forever = SKAction.repeatForever(rotate)
        
        let shapeArc = ShapeArc(radius: radius, ringWidth: ringWidth, colorsInt: block.colorsInt)
        for arc in shapeArc.children{
            arc.removeFromParent()
            if speed != 0{
                arc.run(forever)
            }
            arc.physicsBody?.categoryBitMask = 2
            arc.physicsBody?.collisionBitMask = 1
            arc.physicsBody?.contactTestBitMask = 1
            arc.name = "arc"
            scene.addChild(arc)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
