//
//  VideoPlayerController.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/11/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class VideoPlayerController : AnalyticsViewController {
    var avPlayer : AVPlayer?
    var avPlayerLayer : AVPlayerLayer?
    var cmTime : CMTime?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenName = "VideoPlayerController"
        
        // Initialize AVPlayer
        var value = NSNumber(integer: UIInterfaceOrientation.Portrait.rawValue)
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        var resource = NSBundle.mainBundle().pathForResource("churchstate", ofType: ".mp4")
        
        var urlPathOfVideo = NSURL(fileURLWithPath: resource!)
        avPlayer = AVPlayer(URL: urlPathOfVideo)
        avPlayer!.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer!)
        avPlayerLayer!.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        self.view.layer.addSublayer(avPlayerLayer)
        
        avPlayer!.play()
        cmTime = kCMTimeZero
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: nil)
        
        // AVPlayer Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer!.currentItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseVideo", name: "PauseBgVideo", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resumeVideo", name: "ResumeBgVideo", object: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    // MARK: AVPlayer Methods
    func pauseVideo() {
        avPlayer?.pause()
        cmTime = avPlayer?.currentTime()
    }
    
    func resumeVideo() {
        avPlayer?.seekToTime(cmTime!, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        avPlayer?.play()
    }
    
    func playerItemDidReachEnd(notification : NSNotification) {
        if let p = notification.object as? AVPlayerItem {
            p.seekToTime(kCMTimeZero)
        }
    }
}