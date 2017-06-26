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
    
    
    var touched = false
    var touchesCont = 0
    var numberOfColors = 3
    var outCircle = SKShapeNode()
    var circle = SKShapeNode()
    var subShapes = [SubShape]()
    var radius = CGFloat()
    var velocity = TimeInterval(exactly: 0.2)
    
    var level = 1
    
    
    
    var outCircles = [OutCircleShape]()
    
    var clicks = 0
    var gotItRight = 0
    var time = TimeInterval()
    var began = false
    
    
    var bigCircle  = [OutCircleShape]()
    var redBall:SKShapeNode!
    
    
    
    
    override func didMove(to view: SKView) {
        
        switch (level){
            
            case 1: self.loadInitialData()
                break
            case 2: self.level2Data()
            break;
        default: break
           
            
        }
        
        
        //self.loadInitialData()
        
        
    }
    
    func level2Data(){
        
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
    
    
    
    
    
    func loadInitialData() {
        
        let rotateAction  = SKAction.rotate(byAngle: CGFloat( Float.pi), duration: 1)
        let fasterRotation = SKAction.rotate(byAngle: -1*CGFloat (2 * (Float.pi)), duration: 1)
        
        radius = (self.view?.frame.size.width)! * 0.20
        
        circle.position = CGPoint(x: 0, y: 0)
        
        let infiniteRotation = SKAction.repeatForever(rotateAction)
        let infiniteRotationFaster = SKAction.repeatForever(fasterRotation)
        
        
        createSubShapesWith(number: 3)
        createOutCirclesWith(number: 3)
        //createBigCircle(number: 3)
        
        for subShape in subShapes {
            circle.addChild(subShape)
        }
        
        addChild(circle)
        
        for semiCircle in self.outCircles{
            
            outCircle.addChild(semiCircle)
            
        }
        
        self.addChild(outCircle)
        self.circle.run(infiniteRotation)
        //self.outCircle.run(infiniteRotationFaster)
        
        
        
        
        
    }
    
    func  createOutCirclesWith(number: Int){
        
        let angle = Double(360/number)
        
        var currentAngle = 90.0
        
        for index in 0..<number {
            let subCircleShape = OutCircleShape(radius: radius*3, startAngle: CGFloat(currentAngle * (Double.pi/180)), endAngle: CGFloat((currentAngle + angle) * (Double.pi/180)), color: colors[index])
            outCircles.append(subCircleShape)
            currentAngle += angle
        }
        
        
        
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
        
        
        touchesCont = touchesCont + 1
        var ballCounter = 0
        
        touched = true
        
        
        for shape in subShapes{
            
            
            
            self.redBall = SKShapeNode.init(circleOfRadius: 40)
            
            self.redBall?.fillColor = shape.color
            
            self.redBall?.position = shape.positionCorrected
            
            self.redBall?.physicsBody = SKPhysicsBody.init(circleOfRadius: 40)
            
            self.redBall?.physicsBody?.affectedByGravity = false
            
            self.redBall?.name = "ball_\(ballCounter)"
            
            self.circle.addChild(self.redBall)
            
            ballCounter+=1
            
            
            
            //print(shape.positionCorrected)
            
        }
        
        var removeCounter = 0
        
        for shape in subShapes{
            
            
            let ballNodeRemoved = self.circle.childNode(withName: "ball_\(removeCounter)")
            
            let point = self.convert((ballNodeRemoved?.position)!, from: self.circle)
            
            let impulse = SKAction.applyImpulse(CGVector(dx: point.x, dy: point.y), duration: 1)
            
            let fadeEffect = SKAction.fadeOut(withDuration: 1)
            
            self.circle.removeAllActions()
            self.outCircle.removeAllActions()
            
            ballNodeRemoved?.run(impulse)
            
            removeCounter+=1
            
            shape.run(fadeEffect)
            
        }
        
        
        
        let rotatee = GLKMathDegreesToRadians(360.0)
        let rot = GLKMathRadiansToDegrees(Float(circle.zRotation)) / 360
        print(rot)
        //let numberOfColorsTimes2: Int = (numberOfColors) * 2
        //        if (CGFloat (rotatee) < 2 * CGFloat.pi){
        //
        //
        //            print("vamos")
        //            gotItRight = 1
        //
        //        }
        //        else {
        
        
        let subtraction =  CGFloat (GLKMathRadiansToDegrees(Float.pi / Float (numberOfColors)))
       // if (abs (fmod(circle.zRotation, CGFloat(rotatee))  -  fmod(outCircle.zRotation, CGFloat (rotatee)))
           // < CGFloat.pi /  CGFloat (numberOfColors)) {
            
            
            
            
            if (fmod (circle.zRotation, CGFloat(rotatee)) - subtraction <  CGFloat.pi / CGFloat (numberOfColors))
            {
            
            gotItRight = 1
            print("vamooo")
        }
        else{
            gotItRight = 0
            print ("nao vamo")
        }
        
        
        
        // }
        
        
    
        
        //circle.removeAllActions()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        switch level {
        case 1:
            updateLevel1(currentTime)
            break
        default: break
            //circle.removeAllActions()
        }
        
        
    }
    
func updateLevel1(_ currentTime: TimeInterval) {
        
        var removeCounter = 0
        let fadeEffect = SKAction.fadeOut(withDuration: 1)
        
        if(touched){
            
            
            
            
            /*
             for circles in self.outCircles{
             print("COR DO CIRCULO")
             print(circles.color)
             if let a = circles.physicsBody?.allContactedBodies(){
             
             
             for body in a{
             print("cor do body")
             
             
             let bodyNode = body.node as! SKShapeNode
             print(bodyNode.fillColor.cgColor)
             
             if bodyNode.fillColor.cgColor == circles.color.cgColor{
             bodyNode.run(fadeEffect)
             }
             
             }
             }
             */
            
            
            
            
            
            if self.circle.childNode(withName: "ball_\(removeCounter)") != nil{
                
                let ballNodeRemoved = self.circle.childNode(withName: "ball_\(removeCounter)") as! SKShapeNode
                
                let point = self.convert((ballNodeRemoved.position), from: self.circle)
                
                //if(sqrt(pow(point.x, 2) + pow(point.y, 2)) >= (self.outCircles.first?.radius)!){
                if pow(point.x, 2)  + pow(point.y, 2) >= pow (radius * 3, 2){
                    
                    
                    
                    
                    
                    if (gotItRight == 1){
                        
                        for child in circle.children{
                            child.run(.stop())
                            child.removeFromParent()
                            
                        }
                        for child in outCircle.children{
                            child.removeFromParent()
                        }
                        
                        self.removeAllChildren()
                        self.subShapes = []
                        self.outCircles = []
                        self.loadInitialData()
                        
                        
                        
                        
                        
                        
                    }
                        
                    else {
                        
                        
                        for child in circle.children{
                            child.run(.stop())
                            child.removeFromParent()
                            
                        }
                        for child in outCircle.children{
                            child.removeFromParent()
                        }
                        
                        self.removeAllChildren()
                        subShapes = []
                        outCircles = []
                        self.loadInitialData()
                        
                        
                    }
                    
                    
                    
                    // for circles in self.outCircles{
                    
                    //print(circles.zRotation)
                    //print(ballNodeRemoved.zRotation)
                    
                    //print(circles.initialPosition)
                    
                    
                    // let initialPointCircle = self.convert((circles?.initialPosition!)!, from: self.circle)
                    // let finalPointCircle = self.convert((circles?.finalPosition!)!, from: self.circle)
                    
                    //print("\(ballNodeRemoved.name): \(point)")
                    
                    //print(initialPointCircle)
                    
                    //   if(circles.color == ballNodeRemoved.fillColor){
                    
                    
                    
                    //    }
                    
                    //if(circles?.color == ballNodeRemoved.strokeColor && point.x >= (circles?.initialPosition.x)! && point.x <= (circles?.finalPosition.x)!){
                    
                    //  print("colisiom")
                    //}
                    
                    
                    
                    
                    
                    
                    
                    // }
                    
                    
                }
                
                
            }
            
            
            
        }
        
        
        
        
    }

    
    
    
    
    
    
    

}
