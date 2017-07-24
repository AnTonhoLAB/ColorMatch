//
//  SubLevel.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 29/06/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import Foundation
import SpriteKit

struct Block {
    var speed: Double
    var colorsInt: [Int]
    var times: Int
    
    init(speed: Double, times: Int, colorsInt: [Int]) {
        self.speed = speed
        self.colorsInt = colorsInt
        self.times = times
    }
}

public class SubLevel {
    
    let blocks: [Block]!
    let level: Level!
    
    let number: Int
    
    init(subLevelJson: [[String : Any]], level: Level, number: Int) {
        self.level = level
        self.number = number
        
        var blocks = [Block]()
        
        for block in subLevelJson{
            let speed = block["speed"] as! Double
            
            let colorsInt = block["colors"] as! [Int]
            
            let times = block["times"] as! Int
            
            blocks.append(Block(speed: speed, times: times, colorsInt: colorsInt))
        }
        self.blocks = blocks
    }
    
    func applySubLevelInScene(scene: SKScene) -> MainCircle {
        
        var mainCircle: MainCircle!
        
        let totalRadius = ((scene.view?.frame.size.width)!) * 0.45
        let ringWidth = totalRadius*0.1
        
        for (index, block) in blocks.enumerated() {
            if index == 0{
                mainCircle = createMainCircle(block: block, radius: totalRadius * 0.18)
                scene.addChild(mainCircle)
            }
            else {
                createRing(block: block, radius: totalRadius-(ringWidth+(ringWidth/2))*CGFloat(index), ringWidth: ringWidth, scene: scene)
            }
        }
        
        return mainCircle
    }
    
    func createMainCircle(block: Block, radius: CGFloat) -> MainCircle{
        let mainCircle = MainCircle(block: block, radius: radius)
        mainCircle.run()
        return mainCircle
    }
    
    func createRing(block: Block, radius: CGFloat, ringWidth: CGFloat, scene: SKScene){
        let shapeArc = ShapeArc(radius: radius, ringWidth: ringWidth, block: block)
        shapeArc.run()
        scene.addChild(shapeArc)
    }
    
    func getTextureWith(scene: SKScene, andLockedState locked: Bool) -> SKTexture{
        let shapeNodeForTexture = SKShapeNode()
        
        let totalRadius = ((scene.view?.frame.size.width)!)*0.08
        let ringWidth = totalRadius*0.1
        
        for (index, block) in blocks.enumerated() {
            if index == 0{
                    mainCircleForTexture(block: block, radius: totalRadius*0.18, locked: locked, shapeNode: shapeNodeForTexture)
            }
            else {
                ringForTexture(block: block, radius: totalRadius-(ringWidth+(ringWidth/2))*CGFloat(index), ringWidth: ringWidth, locked: locked, shapeNode: shapeNodeForTexture)
            }
        }
        
        let square = SKShapeNode(rectOf: CGSize(width: totalRadius*2+(ringWidth*3)*2, height: totalRadius*2+(ringWidth*3)*2 ), cornerRadius: totalRadius*2/4)
        square.lineWidth = ringWidth
        square.position = CGPoint(x: 0, y: 0)
        square.zPosition = -50
        square.fillColor = UIColor.white
        
        if locked{
            square.strokeColor = Preferences.colors[4]
            let locked = SKSpriteNode(imageNamed: "Locked")
            if UIDevice.current.userInterfaceIdiom == .pad {
                locked.xScale = 2
                locked.yScale = 2
            }
            shapeNodeForTexture.addChild(locked)
        }
        else{
            square.strokeColor = Preferences.colors[level.color]
        }
        
        shapeNodeForTexture.addChild(square)
        let texture = scene.view?.texture(from: shapeNodeForTexture)
        return texture!
    }
    
    func mainCircleForTexture(block: Block, radius: CGFloat,locked: Bool, shapeNode: SKShapeNode){
        let angle = Double(360/block.colorsInt.count)
        
        var currentAngle = 90.0
        for index in 0..<block.colorsInt.count {
            let subShape = SubShapeMainCircle(radius: radius, startAngle: CGFloat(currentAngle) * (CGFloat.pi/180), endAngle: CGFloat(currentAngle + angle) * (CGFloat.pi/180), color: Preferences.colors[block.colorsInt[index]])
            if locked{
                for childSubShape in subShape.children{
                    let childSubShapeNode = childSubShape as! SKShapeNode
                    childSubShapeNode.strokeColor = Preferences.colors[4]
                    childSubShapeNode.fillColor = Preferences.colors[4]
                }
            }
            shapeNode.addChild(subShape)
            currentAngle += angle
        }
    }
    
    func ringForTexture(block: Block, radius: CGFloat, ringWidth: CGFloat, locked: Bool, shapeNode: SKShapeNode){
        let shapeArc = ShapeArc(radius: radius, ringWidth: ringWidth, block: block)
        for arc in shapeArc.children{
            arc.removeFromParent()
            let arcShapeNodey = arc as! SKShapeNode
            if locked{
                arcShapeNodey.fillColor = Preferences.colors[4]
                arcShapeNodey.strokeColor = Preferences.colors[4]
            }
            shapeNode.addChild(arcShapeNodey)
        }
    }
    
}
