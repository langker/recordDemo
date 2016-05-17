//
//  ViewController.swift
//  recordDemo
//
//  Created by langker on 16/5/16.
//  Copyright © 2016年 langker. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var play: UIButton!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var waveformView:SCSiriWaveformView!
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),//编码格式
        AVNumberOfChannelsKey : NSNumber(int: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]//音频质量
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bounds = UIScreen.mainScreen().bounds
        
        waveformView = SCSiriWaveformView(frame: CGRectMake(0, 0, bounds.width, 100))
        waveformView.waveColor = UIColor.whiteColor()
        waveformView.primaryWaveLineWidth = 3.0
        waveformView.secondaryWaveLineWidth = 1.0
        self.view.addSubview(waveformView)
        
        do {
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!, settings: recordSettings)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            audioRecorder.prepareToRecord()
            audioRecorder.meteringEnabled = true
        } catch {
        }
        
        let displayLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(ViewController.updateMeters))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func updateMeters() {
        audioRecorder.updateMeters()
        let normalizedValue:CGFloat = pow(10, CGFloat(audioRecorder.averagePowerForChannel(0))/20)
        waveformView.updateWithLevel(normalizedValue)
    }
    func directoryURL() -> NSURL? {
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".caf"
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent(recordingName)
        return soundURL
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func OnStart(sender: AnyObject) {
        if !audioRecorder.recording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {
            
            }
        }
    }

    @IBAction func OnStop(sender: AnyObject) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
        
        }

    }
    @IBAction func OnPlay(sender: AnyObject) {
        if (!audioRecorder.recording){
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
                audioPlayer.play()
            } catch {
                
            }
        }
    }
}

