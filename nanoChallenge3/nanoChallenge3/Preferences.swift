//
//  Preferences.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 29/06/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import UIKit

class Preferences {
    static let colors = [UIColor(red: 255.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1),
                  UIColor(red: 255.0/255.0, green: 190.0/255.0, blue: 71.0/255.0, alpha: 1),
                  UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 215.0/255.0, alpha: 1),
                  UIColor(red: 118.0/255.0, green: 177.0/255.0, blue: 71.0/255.0, alpha: 1),
                  UIColor(red: 221.0/255.0, green: 222.0/255.0, blue: 225.0/255.0, alpha: 1)]
    
    static let durationTransitions: TimeInterval = 0.5
    
    static let arcBitMask = UInt32(2)
    static let circleBitMask = UInt32(1)
}
