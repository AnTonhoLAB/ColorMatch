//
//  World.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 29/06/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//
import Foundation

class World {
    static func numberOfLevels() -> Int {
        var numberOfLevels = -1
        do {
            if let file = Bundle.main.url(forResource: "World", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let world = json as? [[[[String: Any]]]] {
                    numberOfLevels = world.count
                }
                else {
                    print("JSON is invalid")
                }
            } else {
                print("World file was not found")
            }
        } catch {
            print(error.localizedDescription)
        }
        return numberOfLevels
    }
    
    static func getLevel(level: Int) -> Level? {
        do {
            if let file = Bundle.main.url(forResource: "World", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let world = json as? [[[[String: Any]]]] {
                    let level = Level(levelJson: world[level-1], number: level)
                    return level
                }
                else {
                    print("JSON is invalid")
                }
            } else {
                print("World file was not found")
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
