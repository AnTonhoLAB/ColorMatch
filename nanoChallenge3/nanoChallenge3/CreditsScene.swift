//
//  CreditsScene.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 26/06/17.
//
//

import SpriteKit
import GameplayKit

class CreditsScene: SKScene {
    
    var buttons = [SKSpriteNode]()
    var links = ["https://www.facebook.com/douglas.gehring.3", "https://www.linkedin.com/in/eduardo-segura-fornari-a23728a7/", "https://www.linkedin.com/in/georgegomees/", "https://www.linkedin.com/in/laura-corssac-538914a2/", "https://www.behance.net/user/?username=jcaardoso"]
    
    let distanceButtons = CGFloat(19)
    
    var heightButtons: CGFloat!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.white
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let creditsTitle = SKSpriteNode(imageNamed: "Credits")
        let buttonDouglas = SKSpriteNode(imageNamed: "Button_Douglas")
        let buttonEduardo = SKSpriteNode(imageNamed: "Button_Eduardo")
        let buttonGeorge = SKSpriteNode(imageNamed: "Button_George")
        let buttonLaura = SKSpriteNode(imageNamed: "Button_Laura")
        let buttonJuliana = SKSpriteNode(imageNamed: "Button_Juliana")
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            creditsTitle.xScale = 2
            creditsTitle.yScale = 2
            
            buttonDouglas.xScale = 2
            buttonDouglas.yScale = 2
            
            buttonEduardo.xScale = 2
            buttonEduardo.yScale = 2
            
            buttonGeorge.xScale = 2
            buttonGeorge.yScale = 2
            
            buttonLaura.xScale = 2
            buttonLaura.yScale = 2
            
            buttonJuliana.xScale = 2
            buttonJuliana.yScale = 2
        }
        
        heightButtons = buttonDouglas.size.height
        
        var levelsTitlePositionY = (creditsTitle.size.height + (5 * heightButtons) + (4 * distanceButtons))
        levelsTitlePositionY = levelsTitlePositionY/2
        
        creditsTitle.position = CGPoint(x: 0, y: levelsTitlePositionY)
        
        buttonDouglas.position = CGPoint(x: 0, y: creditsTitle.position.y - creditsTitle.size.height/2 - heightButtons - heightButtons/2)
        
        buttonEduardo.position = CGPoint(x: 0, y: buttonDouglas.position.y - CGFloat(distanceButtons) - heightButtons)
        buttonGeorge.position = CGPoint(x: 0, y: buttonEduardo.position.y - CGFloat(distanceButtons) - heightButtons)
        buttonLaura.position = CGPoint(x: 0, y: buttonGeorge.position.y - CGFloat(distanceButtons) - heightButtons)
        buttonJuliana.position = CGPoint(x: 0, y: buttonLaura.position.y - CGFloat(distanceButtons) - heightButtons)
        
        creditsTitle.zPosition = 100
        buttonDouglas.zPosition = 100
        buttonEduardo.zPosition = 100
        buttonGeorge.zPosition = 100
        buttonLaura.zPosition = 100
        buttonJuliana.zPosition = 100
        
        addChild(creditsTitle)
        addChild(buttonDouglas)
        addChild(buttonEduardo)
        addChild(buttonGeorge)
        addChild(buttonLaura)
        addChild(buttonJuliana)
        
        buttons.append(buttonDouglas)
        buttons.append(buttonEduardo)
        buttons.append(buttonGeorge)
        buttons.append(buttonLaura)
        buttons.append(buttonJuliana)
        
        Background.applyIn(scene: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        for (index,button) in buttons.enumerated() {
            if button.contains(touch.location(in: self)) {
                let url = URL(string: links[index])!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                break
            }
        }
    }
    
    override func shake() {
        let mainScene = MainScene(size: self.frame.size)
        mainScene.scaleMode = .aspectFill
        mainScene.createMenuScene()
        self.view?.presentScene(mainScene, transition: SKTransition.fade(with: UIColor.lightGray, duration: Preferences.durationTransitions))
    }
}
