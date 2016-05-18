//
//  Reocrder.swift
//  recordDemo
//
//  Created by langker on 16/5/18.
//  Copyright © 2016年 langker. All rights reserved.
//

import Foundation
import AVFoundation

class Recorder: NSObject {
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),//编码格式
        AVNumberOfChannelsKey : NSNumber(int: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]//音频质量
    
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
    
    func recordNow() {
        do {
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!, settings: recordSettings)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            audioRecorder.prepareToRecord()
            audioRecorder.meteringEnabled = true
        } catch {
            
        }
        
        if !isRecordindNow() {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {
                
            }
        }
    }
    
    func stopRecord() {
        audioRecorder.stop()
    }
    
    func playRecord() {
        if (!isRecordindNow()) {
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
                audioPlayer.play()
            } catch {
                
            }
        }
    }
    func stopPlayRecord() {
        audioPlayer.stop()
    }
    func isRecordindNow()->Bool {
        return audioRecorder.recording
    }
    func updateMeters() {
        audioRecorder.updateMeters()
    }
    func getAveragePowerForChannel()->Float {
        return audioRecorder.averagePowerForChannel(0)
    }
}