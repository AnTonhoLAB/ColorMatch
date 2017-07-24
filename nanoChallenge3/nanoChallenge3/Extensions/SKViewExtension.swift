//
//  SKViewExtension.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 26/06/17.
//
//
import SpriteKit

extension SKScene {
    func shake() {
    }
}

extension SKView {
    open override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if let scene = self.scene {
            scene.shake()
        }
    }
}
