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
    var restaurantNames : [String] = ["Church State", "Bradshaw Brewhaus"]
    var restaurantCredits : [String] = ["@seyunkim", "@pbradshawusc"]
    var restaurantDescriptions : [String] = ["The Church State is a modern day meeting place for all - religious or not. This Church-side cafe is the perfect place to meet a friend for coffee and a sandwich or to meet someone new entirely! The social atmosphere is augmented by the local congregation that is very open to new people.", "Bradshaw Brewhaus is a local gastropub serving an ecclectic mix of Southern-style dishes and homebrew ales. Known for their italian-twist garlic quesadillas, this is a must-try!"]
    var restaurantImageNames : [String] = ["SampleHiRez", "SampleHiRez"]
    var restaurantLogoNames : [String] = ["SampleRestaurantLogo", "SampleRestaurantLogo"]
    var restaurantCategories : [String] = ["Cafe", "Gastropub, Southern"]
    var restaurantRatings = [1.5, 2]
    var restaurantPhones = ["555-555-5555", "972-867-5309"]
    var restaurantAddresses = ["835 W 30th St\nLos Angeles, CA", "947 W 30th St\nLos Angeles, CA"]
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
    
    internal override func initializationImplementation() {
        super.initializationImplementation()
        self.backgroundColor = UIColor.blackColor()
        
        // Set up our video view and content size
        videoView = VideoPlayerView(frame: self.frame,
            name: restaurantNames[videoIndex],
            credit: restaurantCredits[videoIndex],
            startingVideoName: videoNames[videoIndex],
            startingVideoExtension: videoExtensions[videoIndex])
        videoView!.viewDelegate = self
        self.addSubview(videoView!)
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 3)
        
        // Set up our restaurant view
        restaurantView = RestaurantPromoView(frame: CGRectMake(
            self.frame.origin.x,
            videoView!.frame.origin.y + videoView!.frame.height,
            self.frame.width,
            videoView!.frame.height),
            name: restaurantNames[videoIndex],
            information: restaurantDescriptions[videoIndex],
            background: restaurantImageNames[videoIndex],
            logo: restaurantLogoNames[videoIndex])
        self.addSubview(restaurantView!)
        
        // Set up our information view
        informationView = RestaurantInformationView(frame: CGRectMake(
            0,
            restaurantView!.frame.origin.y + restaurantView!.frame.height,
            self.frame.width,
            restaurantView!.frame.height),
            name: restaurantNames[videoIndex],
            price: restaurantRatings[videoIndex],
            phone: restaurantPhones[videoIndex],
            address: restaurantAddresses[videoIndex],
            category: restaurantCategories[videoIndex])
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
            videoView?.changeRestaurant(restaurantNames[videoIndex],
                source: restaurantCredits[videoIndex],
                fileName: videoNames[videoIndex],
                fileExtension: videoExtensions[videoIndex])
//            if let vidV = videoView as VideoPlayerView! {
//                vidV.doChangeToFile(videoNames[videoIndex], fileExtension: videoExtensions[videoIndex])
//            }
            
            // Update the other screens
            restaurantView?.changeRestaurant(restaurantNames[videoIndex],
                information: restaurantDescriptions[videoIndex],
                background: restaurantImageNames[videoIndex],
                logo: restaurantLogoNames[videoIndex])
            informationView?.changeRestaurant(restaurantNames[videoIndex],
                price: restaurantRatings[videoIndex],
                phone: restaurantPhones[videoIndex],
                address: restaurantAddresses[videoIndex],
                category: restaurantCategories[videoIndex])
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