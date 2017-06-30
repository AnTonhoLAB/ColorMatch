 //
//  Level.swift
//  ReadJason
//
//  Created by Eduardo Fornari on 29/06/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import Foundation
import SpriteKit

class Level {
    var subLevels: [SubLevel]!
    
    init(levelJson: [[[String : Any]]]) {
        self.subLevels = [SubLevel]()
        for levelJsonAux in levelJson{
            let subLevel = SubLevel(subLevelJson: levelJsonAux)
            self.subLevels.append(subLevel)
        }
    }
    
    func getSubLevel(subLevel: Int) -> SubLevel?{
        var result: SubLevel? = nil
        if subLevel >= 1 || subLevel <= subLevels.count {
            result = self.subLevels[subLevel-1]
        }
        return result
    }
    
 func numberOfSubLevels() -> Int {
        return self.subLevels.count
    }
}
