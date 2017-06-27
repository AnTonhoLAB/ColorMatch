//
//  GameScene.swift
//  nanoChallenge3
//
//  Created by George Vilnei Arboite Gomes on 22/06/17.
//
//

import SpriteKit
import GameplayKit


enum GameStatus {
    case GameOverStatus
    case Runing
    case NextSubLevel
    case NextLevel
}


class GameScene: SKScene {
    
    
    var currentLevel = -1
    var currentSubLevel = -1
    
    var vidas = 3
    
    
    let vermelho = UIColor(red: 255.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1)
    let laranja = UIColor(red: 255.0/255.0, green: 190.0/255.0, blue: 71.0/255.0, alpha: 1)
    let ciano = UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 215.0/255.0, alpha: 1)
    
    var gameStatus = GameStatus.Runing
    
    var userDefaults = UserDefaultsManager()
    
    var colors:[UIColor]!
    
    var touched = false
    var touchesCont = 0
    var numberOfColors = 3
    //var outCircle = SKShapeNode()
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
    
    var arcCircle = SKShapeNode()
    
    var redBall:SKShapeNode!
    
    
    
    
    override func didMove(to view: SKView) {
        
        //self.userDefaults.resetUserDefaults()
        
        
        if(self.currentLevel < 0){
        
            self.currentLevel = self.userDefaults.getCurrentUserInfo(info: .CurrentLevel)
            self.currentSubLevel = self.userDefaults.getCurrentUserInfo(info: .CurrentSubLevel)
            
        }
        
        self.loadInitialData()
        
        
    }
    

    
    
    func loadInitialData() {
        
        
        //self.updateSubLevelLabel()
        
        self.colors = [vermelho, laranja, ciano, UIColor.brown, UIColor.blue, UIColor.red, UIColor.green, UIColor.cyan, UIColor.yellow, UIColor.lightGray]
        
        self.circle.name = "InsideCircle"
        self.arcCircle.name = "OutsideCircle"
        
        
        
        radius = (self.view?.frame.size.width)! * 0.20
        
        circle.position = CGPoint(x: 0, y: 0)
 
        
        self.setNextSubLevelAcordingToParameters(currentLevel: self.currentLevel, currentSubLevel: self.currentSubLevel)
        
        
        circle.zRotation = 0
       
        
    }
    
    func  createOutCirclesWith(number: Int){
        
        let angle = Double(360/number)
        
        var currentAngle = 0.0
        
        for index in 0..<number {
            let subCircleShape = OutCircleShape(radius: radius*3, startAngle: CGFloat(currentAngle * (Double.pi/180)), endAngle: CGFloat((currentAngle + angle) * (Double.pi/180)), color: colors[index])
            outCircles.append(subCircleShape)
            currentAngle += angle
        }
        
        
        
    }
    
    func createSubShapesWith(number: Int){
        let angle = Double(360/number)
        
        var currentAngle = 0.0
        
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
        
       
        
        if(!touched){
            
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
                self.arcCircle.removeAllActions()
                
                if let level2OutCircle = self.childNode(withName:"outCircleLvl2"){
                    
                    level2OutCircle.removeAllActions()
                }
                
                ballNodeRemoved?.run(impulse)
                
                removeCounter+=1
                
                shape.run(fadeEffect)
                
            }
            
            
        }
        
        
        
        
        touched = true
   
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        switch self.currentLevel {
        case 1:
            updateLevel1(currentTime)
            break
            
        case 2:
            updateLevel2(currentTime)
        default: break
            //circle.removeAllActions()
        }
        
        
    }
    

    
    func compareColors (c1:UIColor, c2:UIColor) -> Bool{
        // some kind of weird rounding made the colors unequal so had to compare like this
        
        var red:CGFloat = 0
        var green:CGFloat  = 0
        var blue:CGFloat = 0
        var alpha:CGFloat  = 0
        c1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var red2:CGFloat = 0
        var green2:CGFloat  = 0
        var blue2:CGFloat = 0
        var alpha2:CGFloat  = 0
        c2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return (Int(red*255) == Int(red*255) && Int(green*255) == Int(green2*255) && Int(blue*255) == Int(blue*255) )
        
        
    }
    
    
    func updateLevel2(_ currentTime: TimeInterval){
        /*
        
        var removeCounter = 0
        let fadeEffect = SKAction.fadeOut(withDuration: 1)
        
        if(touched){
            
            
            let ballNodeRemoved = self.circle.childNode(withName: "ball_\(removeCounter)") as! SKShapeNode
            
            let outSideLevel2Circle = self.childNode(withName: "outCircleLvl2") as! ShapeLevel2
            
            let point = self.convert((ballNodeRemoved.position), from: self.circle)
            
            if(sqrt(pow(point.x, 2) + pow(point.y, 2)) >= outSideLevel2Circle.radius - 10){
                
                print("Colisao aleatoria")
                
                
                while(removeCounter<numberOfColors){
                    
                    if let circles = outSideLevel2Circle.children as? [SKShapeNode]{
                        
                        
                        print("Entrou")
                        
                        for circleSelected in circles{
                            
                            
                             print("Entrou - EACH")
                            
                            if(self.compareColors(c1: circleSelected.fillColor, c2: ballNodeRemoved.fillColor)){
                                
                                print("Encontrou a cor")
                                
                                    if(ballNodeRemoved.intersects(circleSelected.)){
                                        
                                        print("Corrected Colision")
                                        
                                        //self.gameStatus = .NextSubLevel
                                        
                                        
                                    }else{
                                        
                                        
                                            self.gameStatus = .GameOverStatus
                                            
                                            self.userDefaults.resetUserDefaults()
                                            
                                        
 
                                        
                                    }
                                }
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    removeCounter+=1
                    
                }
                
                if(self.gameStatus == .GameOverStatus){
                    
                    if let scene = SKScene(fileNamed: "MainScene") {
                        scene.scaleMode = .aspectFill
                        let mainScene = scene as! MainScene
                        mainScene.createGameOverScene()
                        self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                    }
                    
                }
                else if(self.gameStatus == .NextSubLevel){
                    
                    self.touched = false
                    
                    self.currentSubLevel += 1
                    
                    self.userDefaults.updateDefaultsToNextSubLevel()
                    
                    if(self.currentSubLevel >= 4){
                        
                        self.currentLevel += 1
                        self.userDefaults.updateDefaultstoNextLevel()
                        
                    }
                    
                    self.setNextSubLevelAcordingToParameters(currentLevel: self.currentLevel, currentSubLevel: self.currentSubLevel)
                    
                }
                
            }
            
 */
            
            
}
        
        
        
        
        
        
    

    func updateLevel1(_ currentTime: TimeInterval) {
        
        var removeCounter = 0
        let fadeEffect = SKAction.fadeOut(withDuration: 1)
        
        if(touched){
            
            
            let ballNodeRemoved = self.circle.childNode(withName: "ball_\(removeCounter)") as! SKShapeNode
            
            let point = self.convert((ballNodeRemoved.position), from: self.circle)
            
            if(sqrt(pow(point.x, 2) + pow(point.y, 2)) >= (self.outCircles.first?.radius)!-10){
                
                print("Colisao aleatoria")
                
                
                while(removeCounter<numberOfColors){
                    
                    if let circles = self.arcCircle.children as? [OutCircleShape]{
                        
                        
                        for circleSelected in circles{
                            
                            
                            if(self.compareColors(c1: circleSelected.color, c2: ballNodeRemoved.fillColor)){
                                
                                
                                print("Mesma cor")
                                
                                for child in circleSelected.children{
                                    
                                    if(ballNodeRemoved.intersects(child)){
                                        
                                        print("Corrected Colision")
                                        
                                        self.gameStatus = .NextSubLevel
                                        
                                        
                                    }else{
                                        
                                            
                                            self.gameStatus = .GameOverStatus
                                            
                                            self.userDefaults.resetUserDefaults()
                                            
                                        
                                        
                                    }
                                }
                                
                                
                            }
                            
                        }

                        
                    }
                    
                  removeCounter+=1
                    
                }
                
                if(self.gameStatus == .GameOverStatus){
                    
                    if let scene = SKScene(fileNamed: "MainScene") {
                        scene.scaleMode = .aspectFill
                        let mainScene = scene as! MainScene
                        mainScene.createGameOverScene()
                        self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: 1))
                    }

               }
                else if(self.gameStatus == .NextSubLevel){
                    
                    self.touched = false
                    
                    self.currentSubLevel += 1
                    
                    self.userDefaults.updateDefaultsToNextSubLevel()
                    
                    if(self.currentSubLevel >= 4){
                        
                        self.currentLevel = 1
                        self.currentSubLevel = 1
                        self.userDefaults.updateDefaultstoNextLevel()
                        
                    }
                    
                   // self.updateSubLevelLabel()
                    
                    self.setNextSubLevelAcordingToParameters(currentLevel: self.currentLevel, currentSubLevel: self.currentSubLevel)
                    
                }
            
          }
        
        
         
      }

    
    
   }
    
    
    
    func setConfigurationsForSubLevel1(numberOfColors:Int, insideCircleVelocity:Double, outsideCircleVelocity:Double, directionOutCircle:CGFloat, directionInsideCircle:CGFloat){
        
        let outCircleToRemove = self.childNode(withName: "OutsideCircle")
        let insideCircleToRemove = self.childNode(withName: "InsideCircle")
        
        outCircleToRemove?.removeFromParent()
        insideCircleToRemove?.removeFromParent()
        
        outCircleToRemove?.removeAllChildren()
        insideCircleToRemove?.removeAllChildren()
        
        let rotateAction  = SKAction.rotate(byAngle: directionInsideCircle * CGFloat( Float.pi), duration: insideCircleVelocity)
        let fasterRotation = SKAction.rotate(byAngle: directionOutCircle *  CGFloat (2 * (Float.pi)), duration: outsideCircleVelocity)
        
        let infiniteRotation = SKAction.repeatForever(rotateAction)
        let infiniteRotationFaster = SKAction.repeatForever(fasterRotation)
        
        
        self.subShapes = []
        self.outCircles = []
        
        
        createSubShapesWith(number: numberOfColors)
        createOutCirclesWith(number: numberOfColors)
  
        
        for subShape in subShapes {
            circle.addChild(subShape)
        }
        
        addChild(circle)
        
        for semiCircle in self.outCircles{
            
            arcCircle.addChild(semiCircle)
            
        }
        
        self.addChild(arcCircle)
        self.circle.run(infiniteRotation)
        self.arcCircle.run(infiniteRotationFaster)
    }
    
    
    func firstLevelSetNextSubLevel(currentSubLevel:Int){
        
        
        switch(currentSubLevel){
            
        case 1: setConfigurationsForSubLevel1(numberOfColors: 3, insideCircleVelocity: 1, outsideCircleVelocity: 1, directionOutCircle: 0, directionInsideCircle: 1)
            break
        case 2: setConfigurationsForSubLevel1(numberOfColors: 3, insideCircleVelocity: 1, outsideCircleVelocity: 1, directionOutCircle: -1, directionInsideCircle: 1)
            break
        case 3: setConfigurationsForSubLevel1(numberOfColors: 4, insideCircleVelocity: 1, outsideCircleVelocity: 1, directionOutCircle: -1, directionInsideCircle: 1)
            break
            
        default:
            break
            
        }
        
        
    }
    
    
    
    func secondLevelSetNextSubLevel(currentSubLevel:Int){
        
        let testShape = ShapeLevel2(radius: (self.view?.frame.size.width)! * 0.60, colors: [
            UIColor(red: 255.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1),
            UIColor(red: 255.0/255.0, green: 190.0/255.0, blue: 71.0/255.0, alpha: 1),
            UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 215.0/255.0, alpha: 1)], numberOfNodesInEachColor: [4, 10, 10])
        
        testShape.name = "outCircleLvl2"
        
        addChild(testShape)
        
        
        createSubShapesWith(number: 3)
        
        for subShape in subShapes {
            circle.addChild(subShape)
        }
        
        
        addChild(circle)
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 2)
        let forever = SKAction.repeatForever(rotate)
        circle.run(forever)
        testShape.run(forever)

        
        
    }
    
    func setTopAndDownLayoutForGameScene(currentLevel:Int){
        
        
        let topLayout = self.childNode(withName: "TopShape") as! SKSpriteNode
        let downLayout = self.childNode(withName: "DownShape") as! SKSpriteNode
        
       
        
        switch(currentLevel){
            
        case 1:  topLayout.run(SKAction.setTexture(SKTexture(imageNamed: "lv1top.png")))
                 downLayout.run(SKAction.setTexture(SKTexture(imageNamed: "lv1down.png")))
            break
        
            
        case 2:topLayout.run(SKAction.setTexture(SKTexture(imageNamed: "lv2top.png")))
              downLayout.run(SKAction.setTexture(SKTexture(imageNamed: "lv2down.png")))
            break
            
        case 3:topLayout.run(SKAction.setTexture(SKTexture(imageNamed: "lv3top.png")))
               downLayout.run(SKAction.setTexture(SKTexture(imageNamed: "lv3down.png")))
        
        default:
            break
            
            
        }
        
        
        
    }
    
    func setNextSubLevelAcordingToParameters(currentLevel:Int, currentSubLevel:Int){
        
       
        
        switch(currentLevel){
            
        case 1: firstLevelSetNextSubLevel(currentSubLevel: currentSubLevel)
                setTopAndDownLayoutForGameScene(currentLevel:currentLevel)
            break
            
        case 2: secondLevelSetNextSubLevel(currentSubLevel: currentSubLevel)
                setTopAndDownLayoutForGameScene(currentLevel:currentLevel)
            break
        default:
            break
            
        }
        
    }
    
    func fixLevelAccordingToLevelScreen(currentLevel:Int, subLevel:Int){
        
        self.currentLevel = currentLevel
        self.currentSubLevel = subLevel
        
    }
    
    func updateSubLevelLabel(){
        
        let subLevelLabel = self.childNode(withName: "subLevelLabel") as! SKLabelNode
        
        subLevelLabel.text = "\(self.currentSubLevel)/3"
        
    }
    
    
    

}
