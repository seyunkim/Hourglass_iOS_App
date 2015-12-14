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
    
    var videoNames : [String] = ["churchstate", "beer", "takami","sprinkles", "wurstkuche", "nickel","yangi"]
    var videoExtensions : [String] = [".mp4", ".mov", ".mp4", ".mov", ".mov", ".mov",".mov"]
    var restaurantNames : [String] = ["Love and Salt", "Il Cielo", "Takami", "Sprinkles Cupcakes", "Wurstkuche","Nickel Diner", "Yangi Gamjatang"]
    var restaurantCredits : [String] = ["@pbradshawusc", "@sarahbas", "@seyunkm", "@rossregen", "@asoni","@seyunkm","@pbradshawusc"]
    var restaurantDescriptions : [String] = ["Love and Salt is an Italian style restaurant with a California soul. Located in the heart of Manhattan Beach, Love & Salt is the go to spot for brunch, an upscale dinner, and everything in between. Be sure to try their homemade English muffins with rosemary herb butter.", "Since 1986, il Cielo has brought \"the sky\" to Beverly Hills. Often called, \"The most romantic restaurant in Los Angeles\", il Cielo is more than just an Italian restaurant; it is a landmark. With fine dining for lunch and dinner, private rooms and tranquil gardens, il Cielo is the perfect location for almost any occasion, day or night. il Cielo has established itself as a place to impress; \"A country restaurant in the city.\"", "21 floors above Downtown LA's Financial District floats one of the most unique restaurant concepts Southern California has ever experienced.  Takami Sushi & Robata Restaurant® serves high quality Sushi, Robata, and Japanese-influenced entrees, all while boasting unparalleled views of the LA area with outdoor patio dining.", "Sprinkles Cupcakes are handcrafted from the finest ingredients, including sweet cream butter, bittersweet Belgian chocolate. Sprinkles cupcakes are a deliciously sophisticated update on an American classic.", "An exotic sausage grill, serving sausage sandwiches , Belgian fries with homemade dipping sauces, 24 imported biers on tap, and a gourmet collection of sodas.", "Cozy vintage-style diner serves updated versions of old-school comfort fare, plus creative desserts. Known for their famous maple flavored bacon donuts.", "Gamjatang, which is the Korean term for pork neck. The clay potted simmered Gamjatang here is delicious! It was cooked to perfection where the meat was very tender. When served, my Gamjatang looks appetizing as the chili soup base is still simmering."]
    var restaurantImageNames : [String] = ["LoveAndSaltHiRez", "IlCieloHiRez", "TakamiHiRez", "sprinklesphoto", "wurstkuche", "nickel", "yangi"]
    var restaurantLogoNames : [String] = ["LoveAndSaltLogo", "blank", "TakamiLogo", "sprinkleslogo", "blank","nickeld", "blank" ]
    var restaurantCategories : [String] = ["Ambiance, Italian, Californian, Brunch", "Romantic, Ambiance, Italian, Fine Dining", "Sushi, Ambiance", "Trendy, Desert", "Exotic, Hotdog", "Diner, American, Modern", "Korean, Long-Cooked Stews, Gamjatang"]
    var restaurantRatings = ["$$$", "$$$", "$$$", "$", "$$", "$$", "$"]
    var restaurantPhones = ["310-545-5252", "310-276-9990", "213-236-9600", "213-228-2100", "213-687-4444", "213-623-8301", "(213) 388-1105"]
    var restaurantAddresses = ["317 Manhattan Beach Boulevard \nManhattan Beach, CA 90266", "9018 Butron Way \nBeverly Hills, CA 90211", "811 Wilshire Blvd. Ste 2100 \nLos Angeles, CA 90017" ,"735 S Figueroa St #210\nLos Angeles, CA 90017","800 E 3rd St, Los Angeles, CA 90013", "524 S Main St, Los Angeles, CA 90013","3470 W 6th St, Los Angeles, CA 90020"]
    var videoIndex = 0
    
    let tapGesture = UITapGestureRecognizer()
    var ignoreTap = false
    
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
            if (!ignoreTap) {
                canChangeVideo = true
                vidV.doResumeVideo()
            }
        }
    }
    
    func playerItemDidReachEnd(notification : NSNotification) {
//        if let p = notification.object as? AVPlayerItem {
            //p.seekToTime(kCMTimeZero)
            moveToNextVideo()
//        }
    }
    
    // MARK: User Interaction Methods
    func moveToNextVideo() {
        if(canChangeVideo && !ignoreTap) {
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
            AnalyticsController.logSpecial("ViewNewRestaurant", details: restaurantNames[videoIndex] + ": " + videoNames[videoIndex] + videoExtensions[videoIndex])
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
        } else if(canChangeVideo) {
            ignoreTap = false
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