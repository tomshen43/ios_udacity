//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by tom shen on 05/09/2015.
//  Copyright © 2015 tom shen. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var RecordingInProgress: UILabel!
    @IBOutlet weak var StopRecording: UIButton!
    @IBOutlet weak var Microphone: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        StopRecording.hidden = true
        Microphone.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func RecordAudio(sender: UIButton) {
        RecordingInProgress.hidden = false
        StopRecording.hidden = false
        Microphone.enabled = false
        //TODO: Record user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "tom_recording.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings :[:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio()
            recordedAudio.filePathurl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("StopRecording", sender: recordedAudio)
        }else{
            print("Recording was unsuccessful!")
            Microphone.enabled = true
            StopRecording.hidden = true
            RecordingInProgress.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject? ) {
        if (segue.identifier == "StopRecording") {
            let playSoundVC:PlaySoundViewController = segue.destinationViewController as!
                PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundVC.receiveAudio = data
        }
    }

    @IBAction func StopRecording(sender: UIButton) {
        RecordingInProgress.hidden = true
        Microphone.enabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

}

