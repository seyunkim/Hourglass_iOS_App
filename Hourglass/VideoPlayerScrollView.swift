//
//  VideoPlayerScrollView.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/12/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class VideoPlayerScrollView : AnalyticsScrollView, UIGestureRecognizerDelegate, VideoPlayerViewDelegate {
    // MARK: Internal Variables
    var videoView : VideoPlayerView?
    
    var videoNames : [String] = ["churchstate", "beer"]
    var videoExtensions : [String] = [".mp4", ".mov"]
    var videoIndex = 0
    
    let tapGesture = UITapGestureRecognizer()
    
    // MARK: Setup
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationImplementation()
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        initializationImplementation()
    }
    
    internal func initializationImplementation() {
        // Set up our video view and content size
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 3)
        videoView = VideoPlayerView(frame: self.frame)
        videoView!.viewDelegate = self
        self.addSubview(videoView!)
        
        // Set up user interaction
        tapGesture.addTarget(self, action: "moveToNextVideo")
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: AVPlayer Methods
    func pauseVideo() {
        if let vidV = videoView as VideoPlayerView! {
            vidV.doPauseVideo()
        }
    }
    
    func resumeVideo() {
        if let vidV = videoView as VideoPlayerView! {
            vidV.doResumeVideo()
        }
    }
    
    func playerItemDidReachEnd(notification : NSNotification) {
        if let p = notification.object as? AVPlayerItem {
            //p.seekToTime(kCMTimeZero)
            moveToNextVideo()
        }
    }
    
    // MARK: User Interaction Methods
    func moveToNextVideo() {
        // First update the index
        videoIndex++
        if (videoIndex >= videoNames.count) {
            videoIndex = 0
        }
        
        // Now start the new video
        if let vidV = videoView as VideoPlayerView! {
            vidV.doChangeToFile(videoNames[videoIndex], fileExtension: videoExtensions[videoIndex])
        }
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Video Loading Methods
    func loadNextVideo() {
        // Shell method for implementation when connecting to database
    }
}