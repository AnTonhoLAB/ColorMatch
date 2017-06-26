//
//  Credits.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 26/06/17.
//
//

import SpriteKit
import GameplayKit




class Credits: SKScene {
    
    var buttons = [SKSpriteNode]()
    var links = ["https://www.facebook.com/douglas.gehring.3", "https://www.linkedin.com/in/eduardo-segura-fornari-a23728a7/", "https://www.linkedin.com/in/georgegomees/", "https://www.linkedin.com/in/laura-corssac-538914a2/", "Juliana"]
    
    let distanceButtons = 19
    
    var heightButtons: CGFloat!
    
    override func didMove(to view: SKView) {
        let levelsTitle = SKSpriteNode(imageNamed: "Credits")
        
        levelsTitle.xScale = 2
        levelsTitle.yScale = 2
        levelsTitle.position = CGPoint(x: 0, y: (self.view?.frame.size.height)!/2 + levelsTitle.size.height/2)
        levelsTitle.zPosition = 100
        addChild(levelsTitle)
        
        let buttonDouglas = SKSpriteNode(imageNamed: "Button_Douglas")
        buttonDouglas.xScale = 2
        buttonDouglas.yScale = 2
        buttonDouglas.position = CGPoint(x: 0, y: levelsTitle.position.y - buttonDouglas.size.height*2)
        addChild(buttonDouglas)
        buttons.append(buttonDouglas)
        
        heightButtons = buttonDouglas.size.height
        
        let buttonEduardo = SKSpriteNode(imageNamed: "Button_Eduardo")
        buttonEduardo.xScale = 2
        buttonEduardo.yScale = 2
        buttonEduardo.position = CGPoint(x: 0, y: buttonDouglas.position.y - CGFloat(distanceButtons) - heightButtons)
        addChild(buttonEduardo)
        buttons.append(buttonEduardo)
        
        let buttonGeorge = SKSpriteNode(imageNamed: "Button_George")
        buttonGeorge.xScale = 2
        buttonGeorge.yScale = 2
        buttonGeorge.position = CGPoint(x: 0, y: buttonEduardo.position.y - CGFloat(distanceButtons) - heightButtons)
        addChild(buttonGeorge)
        buttons.append(buttonGeorge)
        
        let buttonLaura = SKSpriteNode(imageNamed: "Button_Laura")
        buttonLaura.xScale = 2
        buttonLaura.yScale = 2
        buttonLaura.position = CGPoint(x: 0, y: buttonGeorge.position.y - CGFloat(distanceButtons) - heightButtons)
        addChild(buttonLaura)
        buttons.append(buttonLaura)
        
        let buttonJuliana = SKSpriteNode(imageNamed: "Button_Juliana")
        buttonJuliana.xScale = 2
        buttonJuliana.yScale = 2
        buttonJuliana.position = CGPoint(x: 0, y: buttonLaura.position.y - CGFloat(distanceButtons) - heightButtons)
        addChild(buttonJuliana)
        buttons.append(buttonJuliana)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        for (index,button) in buttons.enumerated() {
            if button.contains(touch.location(in: self)) {
                print(links[index])
                
                UIApplication.shared.openURL(NSURL(string:links[index])! as URL)
                break
            }
        }
    }
    
    
    
    
    
}
