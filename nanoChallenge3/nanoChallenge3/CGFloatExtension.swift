//
//  CGFloatExtension.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 27/06/17.
//

import UIKit

extension CGFloat {
    static func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees*CGFloat(Double.pi/180)
    }
    
    static func radiansToDegrees(radians: CGFloat) -> CGFloat {
        return CGFloat((radians*180)/CGFloat(Double.pi))
    }
}
