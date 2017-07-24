//
//  Level.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 29/06/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import Foundation
import SpriteKit

class Level {
    
    var levelJson: [[[String : Any]]]!
    
    var subLevels: [SubLevel]!
    
    var number: Int!
    
    var color: Int {
        get {
            var count = -1
            for nivel in 1...number{
                count += 1
                if count == 4{
                    count = 0
                }
            }
            return count
        }
    }
    
    
    init(levelJson: [[[String : Any]]], number: Int) {
        self.number = number
        self.levelJson = levelJson
        loadSubLevels()
    }
    
    func getSubLevel(subLevel: Int) -> SubLevel?{
        var result: SubLevel? = nil
        if subLevel-1 >= 0 && subLevel-1 < subLevels.count {
            result = self.subLevels[subLevel-1]
        }
        return result
    }
    
    func loadSubLevels(){
        subLevels = [SubLevel]()
        for (index, levelJsonAux) in levelJson.enumerated(){
            let subLevel = SubLevel(subLevelJson: levelJsonAux, level: self, number: index+1)
            self.subLevels.append(subLevel)
        }
    }
    
    
    func numberOfSubLevels() -> Int {
        return self.subLevels.count
    }
}
