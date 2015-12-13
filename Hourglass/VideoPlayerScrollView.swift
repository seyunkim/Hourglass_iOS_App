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
    var restaurantView : RestaurantPromoView?
    var informationView : RestaurantInformationView?
    var topView = "videoView"
    var canChangeVideo = true
    
    var videoNames : [String] = ["churchstate", "beer"]
    var videoExtensions : [String] = [".mp4", ".mov"]
    var videoIndex = 0
    
    let tapGesture = UITapGestureRecognizer()
    
    // MARK: Setup
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationImplementation()
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        initializationImplementation()
    }
    
    internal func initializationImplementation() {
        self.backgroundColor = UIColor.blackColor()
        
        // Set up our video view and content size
        videoView = VideoPlayerView(frame: self.frame)
        videoView!.viewDelegate = self
        self.addSubview(videoView!)
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 3)
        
        // Set up our restaurant view
        restaurantView = RestaurantPromoView(frame: CGRectMake(
            self.frame.origin.x,
            videoView!.frame.origin.y + videoView!.frame.height,
            self.frame.width,
            videoView!.frame.height))
        self.addSubview(restaurantView!)
        
        // Set up our information view
        informationView = RestaurantInformationView(frame: CGRectMake(
            0,
            restaurantView!.frame.origin.y + restaurantView!.frame.height,
            self.frame.width,
            restaurantView!.frame.height))
        self.addSubview(informationView!)
        
        // Set up user interaction
        tapGesture.addTarget(self, action: "moveToNextVideo")
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: AVPlayer Methods
    func pauseVideo() {
        if let vidV = videoView as VideoPlayerView! {
            canChangeVideo = false
            vidV.doPauseVideo()
        }
    }
    
    func resumeVideo() {
        if let vidV = videoView as VideoPlayerView! {
            canChangeVideo = true
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
        if(canChangeVideo) {
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
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pauseVideo()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (decelerate) {
            return
        }
        if contentOffset.y <= videoView!.frame.height / 2.0 {
            // Snap to video view and begin playing again
            topView = "videoView"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.contentOffset.y = self.videoView!.frame.origin.y
            }, completion: { (completed) -> Void in
                    self.resumeVideo()
            })
        } else if contentOffset.y <= (restaurantView!.frame.origin.y + restaurantView!.frame.height / 2.0) {
            // Snap to restaurant view
            topView = "restaurantView"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.contentOffset.y = self.restaurantView!.frame.origin.y
            })
        } else {
            // Snap to information view
            topView = "informationView"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.contentOffset.y = self.informationView!.frame.origin.y
            })
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if contentOffset.y <= videoView!.frame.height / 2.0 {
            // Snap to video view and begin playing again
            topView = "videoView"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.contentOffset.y = self.videoView!.frame.origin.y
                }, completion: { (completed) -> Void in
                    self.resumeVideo()
            })
        } else if contentOffset.y <= (restaurantView!.frame.origin.y + restaurantView!.frame.height / 2.0) {
            // Snap to restaurant view
            topView = "restaurantView"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.contentOffset.y = self.restaurantView!.frame.origin.y
            })
        } else {
            // Snap to information view
            topView = "informationView"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.contentOffset.y = self.informationView!.frame.origin.y
            })
        }
    }
    
    // MARK: Video Loading Methods
    func loadNextVideo() {
        // Shell method for implementation when connecting to database
    }
}