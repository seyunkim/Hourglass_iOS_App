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

class VideoPlayerController : AnalyticsViewController, UIGestureRecognizerDelegate {
    var avPlayer : AVPlayer?
    var avPlayerLayer : AVPlayerLayer?
    var cmTime : CMTime?
    
    var videoNames : [String] = ["churchstate", "beer"]
    var videoExtensions : [String] = [".mp4", ".mov"]
    var videoIndex = 0
    
    let tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenName = "VideoPlayerController"
        
        // Initialize AVPlayer
        var value = NSNumber(integer: UIInterfaceOrientation.Portrait.rawValue)
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        var resource = NSBundle.mainBundle().pathForResource(videoNames[videoIndex], ofType: videoExtensions[videoIndex])
        
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
        
        // Set up user interaction
        tapGesture.addTarget(self, action: "moveToNextVideo")
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        tapRec.delegate = self
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
    
    // MARK: User Interaction Methods
    func moveToNextVideo() {
        // First update the index
        videoIndex++
        if (videoIndex >= videoNames.count) {
            videoIndex = 0
        }
        
        // Now stop the current video
        avPlayer?.pause()
        
        // Now start the new video
        var value = NSNumber(integer: UIInterfaceOrientation.Portrait.rawValue)
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        var resource = NSBundle.mainBundle().pathForResource(videoNames[videoIndex], ofType: videoExtensions[videoIndex])
        
        var urlPathOfVideo = NSURL(fileURLWithPath: resource!)
        
        avPlayer!.replaceCurrentItemWithPlayerItem(AVPlayerItem(URL: urlPathOfVideo!))
        
        avPlayer!.play()
        cmTime = kCMTimeZero
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}