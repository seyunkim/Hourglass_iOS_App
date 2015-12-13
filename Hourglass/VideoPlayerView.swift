//
//  VideoPlayerView.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/12/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol VideoPlayerViewDelegate {
    func pauseVideo()
    func resumeVideo()
    func playerItemDidReachEnd(notification : NSNotification)
}

class VideoPlayerView : UIView {
    // Mark: Internal Variables
    var avPlayer : AVPlayer?
    var avPlayerLayer : AVPlayerLayer?
    var cmTime : CMTime?
    
    var viewDelegate : VideoPlayerViewDelegate?
    
    // MARK: Setup
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationImplementation("churchstate", startingVideoExtension: ".mp4")
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initializationImplementation("churchstate", startingVideoExtension: ".mp4")
    }
    
    init (frame: CGRect, startingVideoName: String, startingVideoExtension: String) {
        super.init(frame: frame)
        initializationImplementation(startingVideoName, startingVideoExtension: startingVideoExtension)
    }
    
    func initializationImplementation(startingVideoName : String, startingVideoExtension : String) {
        // Initialize AVPlayer
        let value = NSNumber(integer: UIInterfaceOrientation.Portrait.rawValue)
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        let resource = NSBundle.mainBundle().pathForResource(startingVideoName, ofType: startingVideoExtension)
        
        let urlPathOfVideo = NSURL(fileURLWithPath: resource!)
        avPlayer = AVPlayer(URL: urlPathOfVideo)
        avPlayer!.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer!)
        avPlayerLayer!.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        self.layer.addSublayer(avPlayerLayer!)
        
        avPlayer!.play()
        cmTime = kCMTimeZero
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            
        }
        
        // AVPlayer Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer!.currentItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseVideo", name: "PauseBgVideo", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resumeVideo", name: "ResumeBgVideo", object: nil)
    }
    
    // MARK: Delegate Methods
    func pauseVideo() {
        if let del = viewDelegate as VideoPlayerViewDelegate! {
            del.pauseVideo()
        }
    }
    
    func resumeVideo() {
        if let del = viewDelegate as VideoPlayerViewDelegate! {
            del.resumeVideo()
        }
    }
    
    func playerItemDidReachEnd(notification : NSNotification) {
        if let del = viewDelegate as VideoPlayerViewDelegate! {
            del.playerItemDidReachEnd(notification)
        }
    }
    
    // MARK: Handle AV Notifications
    func doPauseVideo() {
        avPlayer?.pause()
        cmTime = avPlayer?.currentTime()
    }
    
    func doResumeVideo() {
        avPlayer?.seekToTime(cmTime!, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        avPlayer?.play()
    }
    
    // MARK: Video Navigation
    func doChangeToFile(fileName: String, fileExtension: String) {
        avPlayer!.pause()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer!.currentItem)
        
        let resource = NSBundle.mainBundle().pathForResource(fileName, ofType: fileExtension)
        let urlPathOfVideo = NSURL(fileURLWithPath: resource!)
        avPlayer!.replaceCurrentItemWithPlayerItem(AVPlayerItem(URL: urlPathOfVideo))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer!.currentItem)
        
        avPlayer!.play()
        cmTime = kCMTimeZero
    }
}