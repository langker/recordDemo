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
    var waveformView:SCSiriWaveformView!
    var recorder:Recorder!
    var displayLink:CADisplayLink!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recorder = Recorder()
        initWaveFormView()
        displayLink = CADisplayLink(target: self, selector: #selector(ViewController.updateMeters))
    }
    
    func updateMeters() {
        recorder.updateMeters()
        let normalizedValue:CGFloat = pow(10, CGFloat(recorder.getAveragePowerForChannel())/20)
        waveformView.updateWithLevel(normalizedValue)
    }

    func initWaveFormView() {
        let bounds = UIScreen.mainScreen().bounds
        waveformView = SCSiriWaveformView(frame: CGRectMake(0, 0, bounds.width, 100))
        waveformView.waveColor = UIColor.whiteColor()
        waveformView.primaryWaveLineWidth = 3.0
        waveformView.secondaryWaveLineWidth = 1.0
        self.view.addSubview(waveformView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func OnStart(sender: AnyObject) {
        recorder.recordNow()
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }

    @IBAction func OnStop(sender: AnyObject) {
        recorder.stopRecord()
        displayLink.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    @IBAction func OnPlay(sender: AnyObject) {
       recorder.playRecord()
    }
}

