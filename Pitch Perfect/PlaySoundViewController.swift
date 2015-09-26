//
//  PlaySoundViewcontrollerViewController.swift
//  Pitch Perfect
//
//  Created by tom shen on 05/09/2015.
//  Copyright © 2015 tom shen. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    var audioplayer:AVAudioPlayer!
    var receiveAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            let filePathUrl = NSURL.fileURLWithPath(filePath)
//            do {
//                try audioplayer = AVAudioPlayer(contentsOfURL: filePathUrl)
//                audioplayer.enableRate = true
//            } catch {
//                print("no audio player")
//            }
//        }else {
//            print("the file path is empty")
//        }
        audioplayer = try! AVAudioPlayer(contentsOfURL: receiveAudio.filePathurl)
        audioplayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receiveAudio.filePathurl)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SlowButton(sender: UIButton) {
        audioEngine.stop()
        audioplayer.rate = 0.5
        audioplayer.currentTime = 0.0
        audioplayer.play()
        
    }

    @IBAction func FastButton(sender: UIButton) {
        audioEngine.stop()
        audioplayer.rate = 1.5
        audioplayer.currentTime = 0.0
        audioplayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        audioEngine.stop()
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarthAudio(sender: UIButton) {
        audioEngine.stop()
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioplayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    
    
    @IBAction func StopButton(sender: UIButton) {
        audioEngine.stop()
        audioplayer.stop()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
