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
    
    
    var level: Int!
    var subLevel: Int!
    
    //Big Circle
    var bigCircle: SKShapeNode!
    var bigCircleRadius: CGFloat!
    
    //Small Circle
    var smallCircleRadius: CGFloat!
    var smallCircleSubShapes = [SubShape]()
    
    var touched = false
    let timeToMove = 0.5
    var timeTouched: TimeInterval!
    
    var circles = [SKShapeNode]()
    
    let colors = [UIColor(red: 255.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1),
                  UIColor(red: 255.0/255.0, green: 190.0/255.0, blue: 71.0/255.0, alpha: 1),
                  UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 215.0/255.0, alpha: 1),
                  UIColor.brown, UIColor.blue, UIColor.red, UIColor.green, UIColor.cyan,
                  UIColor.yellow, UIColor.lightGray]
    
    override func didMove(to view: SKView) {
        setNextSubLevelAcordingToParameters(currentLevel: self.level, currentSubLevel: self.subLevel)
        
        setTopAndDownLayoutForGameScene(currentLevel: level)
        
        Background.movePointsIn(scene: self)
    }
    
    func createSmallCircleSubShapesWith(number: Int, speed: TimeInterval){
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: speed)
        let forever = SKAction.repeatForever(rotate)
        
        let angle = Double(360/number)
        
        var currentAngle = 90.0
        
        for index in 0..<number {
            let subShape = SubShape(radius: smallCircleRadius, startAngle: CGFloat(currentAngle * (Double.pi/180)), endAngle: CGFloat((currentAngle + angle) * (Double.pi/180)), color: colors[index])
            addChild(subShape)
            smallCircleSubShapes.append(subShape)
            
            subShape.run(forever)
            
            currentAngle += angle
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touched {
            bigCircle.removeAllActions()
            
            for subShapeBigCircle in bigCircle.children{
                subShapeBigCircle.removeAllActions()
            }
            
            let subShapes = smallCircleSubShapes
            
            for subShape in subShapes {
                subShape.removeAllActions()
                
                removeChildren(in: smallCircleSubShapes)
                
                let circle = SKShapeNode(circleOfRadius: subShape.radius/2)
                circle.zPosition = 1
                circle.position = subShape.getPoint()
                circle.fillColor = subShape.color
                addChild(circle)
                let newPoint = CGPoint(x: position.x + cos(subShape.getAngle()) * bigCircleRadius, y: position.y + sin(subShape.getAngle())*bigCircleRadius)
                
                circles.append(circle)
                
                let move = SKAction.move(to: newPoint, duration: timeToMove)
                
                circle.run(move)
            }
            
            touched = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        var matches = 0
        
        if touched {
            if(timeTouched != nil){
                if(currentTime - timeToMove >= timeTouched){
                    touched = false
                    
                    for circle in circles {
                        
                        for shape in bigCircle.children{
                            
                            if circle.intersects(shape) {
                                if circle.fillColor == (shape as! SKShapeNode).strokeColor{
                                    matches += 1
                                    break
                                }
                            }
                        }
                    }
                    
                    if matches == circles.count{
                        let currentLevel = UserDefaultsManager.getCurrentUserInfo(info: DefaultsOption.CurrentLevel)
                        let currentSubLevel = UserDefaultsManager.getCurrentUserInfo(info: DefaultsOption.CurrentSubLevel)
                        
                        if(level == currentLevel && subLevel == currentSubLevel){
                            UserDefaultsManager.updateLevelAndSubLevel()
                            if level == 4 && subLevel == 3 {
                                if let scene = SKScene(fileNamed: "LevelScene") {
                                    scene.scaleMode = .aspectFill
                                    self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                                }
                            }
                            else if subLevel == 3 {
                                if let scene = SKScene(fileNamed: "LevelUpScene") {
                                    scene.scaleMode = .aspectFill
                                    let levelUpScene = scene as! LevelUpScene
                                    levelUpScene.setLevelAndSubLevel(level: level, subLevel: subLevel)
                                    self.view?.presentScene(levelUpScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                                }
                            }
                            else{
                                if let scene = SKScene(fileNamed: "GameScene") {
                                    scene.scaleMode = .aspectFill
                                    let gameScene = scene as! GameScene
                                    gameScene.fixLevelAccordingToLevelScreen(level: level, subLevel: subLevel+1)
                                    self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                                }
                            }
                        }
                        else if level == 4 && subLevel == 3 {
                            if let scene = SKScene(fileNamed: "LevelScene") {
                                scene.scaleMode = .aspectFill
                                self.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                            }
                        }
                        else if let scene = SKScene(fileNamed: "GameScene") {
                            scene.scaleMode = .aspectFill
                            let gameScene = scene as! GameScene
                            
                            if subLevel == 3 {
                                gameScene.fixLevelAccordingToLevelScreen(level: level+1, subLevel: 1)
                            }
                            else{
                                gameScene.fixLevelAccordingToLevelScreen(level: level, subLevel: subLevel+1)
                            }
                            self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                        }
                        
                        
                    }
                    else{
                        if let scene = SKScene(fileNamed: "MainScene") {
                            scene.scaleMode = .aspectFill
                            let mainScene = scene as! MainScene
                            mainScene.createGameOverScene(level: level, subLevel: subLevel)
                            self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                        }
                    }
                }
            }
            else{
                timeTouched = currentTime
            }
        }
        
    }
    
    
    func setTopAndDownLayoutForGameScene(currentLevel:Int){
        
        let topLayout = self.childNode(withName: "TopShape") as! SKSpriteNode
        let downLayout = self.childNode(withName: "DownShape") as! SKSpriteNode
        
        switch(currentLevel){
            
        case 1:
            topLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_1_Top")))
            downLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_1_Down")))
            break
            
        case 2:
            topLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_2_Top")))
            downLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_2_Down")))
            break
            
        case 3:topLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_3_Top")))
        downLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_3_Down")))
            break
            
        case 4:
            topLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_3_Top")))
            downLayout.run(SKAction.setTexture(SKTexture(imageNamed: "Level_3_Down")))
            break
            
        default:
            break
        }
    }
    
    func setNextSubLevelAcordingToParameters(currentLevel:Int, currentSubLevel:Int){
        
        switch(currentLevel){
            
        case 1:
            switch currentSubLevel {
            case 1:
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel1(radius: bigCircleRadius, colors: [colors[0], colors[1]])
                addChild(bigCircle)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 2, speed: 2)
                break
            case 2:
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel1(radius: bigCircleRadius, colors: [colors[0], colors[1], colors[2]])
                addChild(bigCircle)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 1.5)
                break
            case 3:
                let rotate = SKAction.rotate(byAngle: -1*CGFloat(Double.pi*2), duration: 4)
                let forever = SKAction.repeatForever(rotate)
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel1(radius: bigCircleRadius, colors: [colors[0], colors[1], colors[2]])
                addChild(bigCircle)
                bigCircle.run(forever)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 1.5)
            default:
                break
            }
            break
            
        case 2:
            switch currentSubLevel {
            case 1:
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel2(radius: bigCircleRadius, colors: [colors[0], colors[1], colors[2]], numberOfNodesInEachColor: [4, 10, 10])
                addChild(bigCircle)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 1.3)
                break
            case 2:
                let rotate = SKAction.rotate(byAngle: -1*CGFloat(Double.pi*2), duration: 4)
                let forever = SKAction.repeatForever(rotate)
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel2(radius: bigCircleRadius, colors: [colors[0], colors[1], colors[2]], numberOfNodesInEachColor: [4, 10, 10])
                addChild(bigCircle)
                bigCircle.run(forever)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 1.3)
                break
            case 3:
                let rotate = SKAction.rotate(byAngle: -1*CGFloat(Double.pi*2), duration: 3)
                let forever = SKAction.repeatForever(rotate)
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel2(radius: bigCircleRadius, colors: [colors[0], colors[1], colors[2]], numberOfNodesInEachColor: [4, 10, 10])
                addChild(bigCircle)
                bigCircle.run(forever)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 1)
                break
            default:
                break
            }
            break
        case 3:
            switch currentSubLevel {
            case 1:
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel1(radius: bigCircleRadius, colors: [colors[0], UIColor.clear, colors[1], UIColor.clear, colors[2], UIColor.clear])
                addChild(bigCircle)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 1)
                break
            case 2:
                let rotate = SKAction.rotate(byAngle: -1*CGFloat(Double.pi*2), duration: 3)
                let forever = SKAction.repeatForever(rotate)
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel1(radius: bigCircleRadius, colors: [colors[0], UIColor.clear, colors[1], UIColor.clear, colors[2], UIColor.clear])
                addChild(bigCircle)
                bigCircle.run(forever)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 1)
                break
            case 3:
                let rotate = SKAction.rotate(byAngle: -1*CGFloat(Double.pi*2), duration: 2.5)
                let forever = SKAction.repeatForever(rotate)
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel1(radius: bigCircleRadius, colors: [colors[0], UIColor.clear, colors[1], UIColor.clear, colors[2], UIColor.clear])
                addChild(bigCircle)
                bigCircle.run(forever)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 0.7)
                break
            default:
                break
            }
            break
        case 4:
            switch currentSubLevel {
            case 1:
                let rotate = SKAction.rotate(byAngle: -1*CGFloat(Double.pi*2), duration: 2.5)
                let forever = SKAction.repeatForever(rotate)
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel2(radius: bigCircleRadius, colors: [colors[0], colors[1], colors[2]], numberOfNodesInEachColor: [4, 10, 10])
                addChild(bigCircle)
                for subShapeBigCircle in bigCircle.children{
                    subShapeBigCircle.run(forever)
                }
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 1)
                break
            case 2:
                let rotate = SKAction.rotate(byAngle: -1*CGFloat(Double.pi*2), duration: 2.5)
                let forever = SKAction.repeatForever(rotate)
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel2(radius: bigCircleRadius, colors: [colors[0], colors[1], colors[2]], numberOfNodesInEachColor: [4, 10, 10])
                addChild(bigCircle)
                for subShapeBigCircle in bigCircle.children{
                    subShapeBigCircle.run(forever)
                }
                bigCircle.run(forever)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 1)
                break
            case 3:
                let rotate = SKAction.rotate(byAngle: -1*CGFloat(Double.pi*2), duration: 2)
                let forever = SKAction.repeatForever(rotate)
                bigCircleRadius = (self.view?.frame.width)! * 0.6
                bigCircle = ShapeLevel2(radius: bigCircleRadius, colors: [colors[0], colors[1], colors[2]], numberOfNodesInEachColor: [4, 10, 10])
                addChild(bigCircle)
                for subShapeBigCircle in bigCircle.children{
                    subShapeBigCircle.run(forever)
                }
                bigCircle.run(forever)
                smallCircleRadius = (self.view?.frame.size.width)! * 0.20
                createSmallCircleSubShapesWith(number: 3, speed: 0.5)
                break
            default:
                break
            }
            break
        default:
            break
        }
        
    }
    
    func fixLevelAccordingToLevelScreen(level:Int, subLevel:Int){
        self.level = level
        self.subLevel = subLevel
    }
    
}
