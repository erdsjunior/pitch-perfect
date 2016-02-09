//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Edilson Junior on 6/7/15.
//  Copyright (c) 2015 Edilson Junior. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //GLOBAL VARIABLES
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var isTheFirstTimeRecording = true
    
    //OUTLETS
    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var recordingInstruction: UILabel!
    @IBOutlet weak var stopRecording: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    //OVERRIDE viewWillAppear HIDING AND ENABLING SOME BUTTONS
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        stopRecording.hidden = true
        recordButton.enabled = true
        recordingStatus.hidden = true
    }
    
    //OVERRIDE prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    //ASSOCIATED WITH THE RECORD BUTTON
    @IBAction func recordAudio(sender: UIButton) {
        recordButton.hidden = true
        pauseButton.hidden = false
        stopButton.hidden = false
        stopRecording.hidden = false
        
        recordingStatus.hidden = false
        recordingInstruction.text = "tap to pause"

        //USING UIView.animateWithDuration TO CREATE THE BLINK EFFECT
        self.recordingStatus.alpha = 0.1;
        UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse, animations: {
            self.recordingStatus.alpha = 1
            },
            completion:nil)
        
        //CREATES A NEW RECORD IF IT'S THE FIRST TIME RECORDING
        //AND RESUMES THE EXISTENT RECORD IN CASE THERE IS ONE RECORDING IN PROGRESS
        if (isTheFirstTimeRecording){
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
            recordingStatus.text = "recording"
        }else{
            recordingStatus.text = "recording resumed"
            audioRecorder.record()
        }
    }
    
    //VALIDATES THE RECORD ACTION HAS FINISHED SUCCESSFULLY
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl:recorder.url, title:recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not sucessful")
            recordButton.enabled = true
            stopButton.enabled = true
        }
    }
    
    //ASSOCIATED WITH THE PAUSE BUTTON
    @IBAction func pauseRecording(sender: UIButton) {
        self.recordingStatus.layer.removeAllAnimations()
        pauseButton.hidden = true
        recordButton.hidden = false
        recordingStatus.text = "paused"
        recordingInstruction.text = "tap to record"

        isTheFirstTimeRecording = false

        audioRecorder.pause()
    }
    
    //ASSOCIATED WITH THE STOP BUTTON
    @IBAction func stopAudio(sender: UIButton) {
        self.recordingStatus.layer.removeAllAnimations()
        pauseButton.hidden = true
        recordButton.hidden = false
        recordingStatus.hidden = true
        recordingStatus.text = "recording"
        recordingInstruction.text = "tap to record"

        isTheFirstTimeRecording = true
        
        audioRecorder.stop()
    }
}