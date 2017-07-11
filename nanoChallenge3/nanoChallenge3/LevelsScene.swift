//
//  LevelsScene.swift
//  nanoChallenge3
//
//  Created by Laura Corssac on 26/06/17.
//
//


import SpriteKit
import GameplayKit

class LevelsScene: SKScene {
    let spacing = CGFloat(15)
    var sizeButton = CGFloat(0)
    
    var currentPage = 1
    
    var buttons = [SKSpriteNode]()
    
    var numberOfPages: Int!
    
    var buttonBack: SKSpriteNode!
    
    var lastUnlockedLevel: Int!
    var lastUnlockedSublevel: Int!
    
    var blocksDistance = CGFloat(20)
    
    var paging = false
    var startPaging: TimeInterval!
    var timeToPaging = 0.3
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.white
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        lastUnlockedLevel = UserDefaultsManager.getCurrentUserInfo(info: .CurrentLevel)
        lastUnlockedSublevel = UserDefaultsManager.getCurrentUserInfo(info: .CurrentSubLevel)
        
        let levelsTitle = SKSpriteNode(imageNamed: "Levels")
        
        buttonBack = SKSpriteNode(imageNamed: "Back")
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            levelsTitle.xScale = 2
            levelsTitle.yScale = 2
            
            blocksDistance = 60
        }
        else{
            buttonBack.xScale = 0.5
            buttonBack.yScale = 0.5
        }
        levelsTitle.position = CGPoint(x: 0, y: (self.view?.frame.size.height)!/4 + levelsTitle.size.height)
        levelsTitle.zPosition = 100
        addChild(levelsTitle)
        
        buttonBack.position = CGPoint(x: -(view.frame.size.width)/2+buttonBack.size.width/2+25, y: (view.frame.size.height)/2-buttonBack.size.height/2-25)
        addChild(buttonBack)
        
        let numberOfLevels = World.numberOfLevels()
        numberOfPages = numberOfLevels%4==0 ? numberOfLevels/4 : numberOfLevels/4+1
        
        var texture = World.getLevel(level: 1)?.getSubLevel(subLevel: 1)?.getTextureWith(scene: self, andLockedState: false)
        var buttonLevel = SKSpriteNode(texture: texture)
        sizeButton = buttonLevel.size.width
        
        var initialX = -1*(sizeButton+spacing)
        let initialY = sizeButton
        
        var currentX = initialX
        var currentY = initialY
        
        var level: Level!
        
        for page in 1...numberOfPages{
            for numberLevel in (page*4)-3...((page*4) <= numberOfLevels ? (page*4) : numberOfLevels){
                
                level = World.getLevel(level: numberLevel)
                
                for numberSubLevel in 1...3{
                    if (numberLevel > lastUnlockedLevel) || (numberLevel == lastUnlockedLevel && numberSubLevel > lastUnlockedSublevel){
                        
                        texture = level.getSubLevel(subLevel: numberSubLevel)?.getTextureWith(scene: self, andLockedState: true)
                        buttonLevel = SKSpriteNode(texture: texture)
                        buttonLevel.attributeValues.updateValue(SKAttributeValue.init(), forKey: "locked")
                    }
                    else{
                        texture = level.getSubLevel(subLevel: numberSubLevel)?.getTextureWith(scene: self, andLockedState: false)
                        buttonLevel = SKSpriteNode(texture: texture)
                        buttonLevel.attributeValues.updateValue(SKAttributeValue(float: Float(numberLevel)), forKey: "level")
                        buttonLevel.attributeValues.updateValue(SKAttributeValue(float: Float(numberSubLevel)), forKey: "subLevel")
                    }
                    
                    buttonLevel.position = CGPoint(x: currentX, y: currentY)
                    buttons.append(buttonLevel)
                    addChild(buttonLevel)
                    
                    currentX = currentX + spacing + sizeButton
                }
                currentX = initialX
                currentY = currentY - (spacing + sizeButton)
            }
            
            initialX = initialX + 3*sizeButton + spacing*3 + blocksDistance
            currentX = initialX
            currentY = initialY
        }
        
        Background.applyIn(scene: self)
        
        currentPage = lastUnlockedLevel%4 == 0 ? (lastUnlockedLevel/4) : (lastUnlockedLevel/4 + 1)
        
        var newPoint: CGPoint!
        for button in buttons {
            var move = 3*sizeButton + spacing*3 + blocksDistance
            move *= CGFloat(currentPage-1)
            newPoint = CGPoint(x: button.position.x-(move), y: button.position.y)
            button.position = newPoint
        }
        
        createGestureRecognizer()
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        self.removeGestureRecognizers()
    }
    
    func createGestureRecognizer() {
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleAction(with:)))
        rightGesture.direction = .right
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleAction(with:)))
        leftGesture.direction = .left
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(with:)))
        
        self.view?.addGestureRecognizer(rightGesture)
        self.view?.addGestureRecognizer(leftGesture)
        self.view?.addGestureRecognizer(tapRecognizer)
    }
    
    func removeGestureRecognizers() {
        for gesture in self.view?.gestureRecognizers ?? [] {
            self.view?.removeGestureRecognizer(gesture)
        }
    }
    
    func handleAction(with recognizer: UISwipeGestureRecognizer) {
        if !paging {
            var newPoint: CGPoint!
            var move: SKAction!
            switch recognizer.direction {
            case UISwipeGestureRecognizerDirection.right:
                if currentPage > 1 {
                    paging = true
                    self.currentPage -= 1
                    for button in buttons {
                        newPoint = CGPoint(x: button.position.x+(3*sizeButton + spacing*3 + blocksDistance), y: button.position.y)
                        move = SKAction.move(to: newPoint, duration: timeToPaging)
                        button.run(move)
                    }
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                if currentPage < numberOfPages {
                    paging = true
                    self.currentPage += 1
                    for button in buttons {
                        newPoint = CGPoint(x: button.position.x-(3*sizeButton + spacing*3 + blocksDistance), y: button.position.y)
                        move = SKAction.move(to: newPoint, duration: timeToPaging)
                        button.run(move)
                    }
                }
                break
            default:
                print("case not handled")
            }
        }
    }
    
    func handleTap(with recognizer: UITapGestureRecognizer) {
        let location = convertPoint(fromView: recognizer.location(in: recognizer.view))
        
        if buttonBack.contains(location) {
            let mainScene = MainScene(size: self.frame.size)
            mainScene.scaleMode = .aspectFill
            mainScene.createMenuScene()
            self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
        }
        else{
            verifyButtonTouched(with: location)
        }
    }
    
    func verifyButtonTouched(with location: CGPoint){
        for button in self.buttons{
            if button.contains(location) {
                if !button.attributeValues.keys.contains("locked"){
                    let gameScene = GameScene(size: self.frame.size)
                    let level = Int((button.attributeValues.removeValue(forKey: "level")?.floatValue)!)
                    let subLevel = Int((button.attributeValues.removeValue(forKey: "subLevel")?.floatValue)!)
                    gameScene.scaleMode = .aspectFill
                    gameScene.setLevelAndSubLevel(level: level, subLevel: subLevel)
                    self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if paging {
            if         startPaging == nil{
                startPaging = currentTime
            }
            else if currentTime - startPaging > timeToPaging{
                paging = false
                startPaging = nil
            }
        }
    }
}
