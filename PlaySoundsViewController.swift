//
//  PlaySoundsViewController.swift
//  
//
//  Created by Edilson Junior on 6/7/15.
//
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // GLOBAL VARIABLES
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    // OUTLETS
    @IBOutlet weak var stopAudio: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
    }

    // STOPS ALL PLAYBACKS
    func stopAllSounds(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    //THIS FUNCTION RECEIVES A FLOAT (rate) WHICH MAY VARY FROM 0.5 TO 2.0
    //rate IS A PROPERTY OF AVAudioPlayer
    func playAudioWithVariableRate(rate:Float){
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    //THIS FUNCTION RECEIVES A FLOAT (pitch) WHICH MAY VARY FROM -2400 TO 2400
    //pitch IS A PROPERTY OF AVAudioUnitTimePitch
    func playAudioWithVariablePitch(pitch: Float){
        var changePitchEffect = AVAudioUnitTimePitch()
        var audioPlayerNode = AVAudioPlayerNode()

        changePitchEffect.pitch = pitch
        
        audioEngine.attachNode(changePitchEffect)
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }
    
    //ASSOCIATED WITH THE SNAIL BUTTON, IT PLAYS A LOW RATE PLAYBACK
    @IBAction func playSlowAudio(sender: UIButton) {
        stopAllSounds()
        playAudioWithVariableRate(0.5)
    }
    
    //ASSOCIATED WITH THE RABBIT BUTTON, IT PLAYS A HIGH RATE PLAYBACK
    @IBAction func playFastAudio(sender: UIButton) {
        stopAllSounds()
        playAudioWithVariableRate(1.5)
    }
    
    //ASSOCIATED WITH THE CHIPMUNK BUTTON, IT PLAYS A HIGH PITCH PLAYBACK
    @IBAction func playChipmunkAudio(sender: UIButton) {
        stopAllSounds()
        playAudioWithVariablePitch(1000)
    }
    
    //ASSOCIATED WITH THE DARTHVADER BUTTON, IT PLAYS A LOW PITCH PLAYBACK
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        stopAllSounds()
        playAudioWithVariablePitch(-1000)
    }
    
    //ASSOCIATED WITH THE PARROT BUTTON, IT PLAYS AN ECHOED PLAYBACK
    //delayTime IS A PROPERTY OF AVAudioUnitDelay WHICH MAY VARY FROM 0 TO 2
    //feedback IS A PROPERTY OF AVAudioUnitDelay WHICH MAY VARY FROM -100 TO 100
    @IBAction func playEchoedAudio(sender: UIButton) {
        stopAllSounds()
        
        var changeDelayEffect = AVAudioUnitDelay()
        var audioPlayerNode = AVAudioPlayerNode()
        
        changeDelayEffect.delayTime = 0.5
        changeDelayEffect.feedback = 60

        audioEngine.attachNode(changeDelayEffect)
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: changeDelayEffect, format: nil)
        audioEngine.connect(changeDelayEffect, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }
    
    //ASSOCIATED WITH THE WAVE BUTTON, IT PLAYS A REVERBERED PLAYBACK
    //wetDryMix IS A PROPERTY OF AVAudioUnitReverb WHICH MAY VARY FROM 0 TO 100
    @IBAction func playReverberedAudio(sender: UIButton) {
        stopAllSounds()
        
        var changeReverbEffect = AVAudioUnitReverb()
        var audioPlayerNode = AVAudioPlayerNode()

        changeReverbEffect.wetDryMix = 70
        
        audioEngine.attachNode(changeReverbEffect)
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }
    
    //ASSOCIATED WITH THE STOP BUTTON
    @IBAction func stopAudio(sender: UIButton) {
        stopAllSounds()
    }

}
