//
//  MusicController.swift
//  nanoChallenge3
//
//  Created by George Vilnei Arboite Gomes on 03/07/17.
//
//

import AVFoundation

public class MusicController{
    
    public var backgroundMusic : AVAudioPlayer!
   
  
    
    public class func sharedInstance() -> MusicController {
        return MusicControllerInstance
    }
    
    
    
    func backGroundMusic(music : String, type : String){
      
        do {
            
            let path = Bundle.main.path(forResource: music, ofType:type)!
            let url = URL(fileURLWithPath: path)
            
            let sound = try AVAudioPlayer(contentsOf: url)
            backgroundMusic = sound
            sound.numberOfLoops = -1
            sound.play()
        } catch {
            print("couldn't load file :(")
        }
    }
    

}
private let MusicControllerInstance = MusicController()
