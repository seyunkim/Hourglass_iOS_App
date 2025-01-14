//
//  VideoPlayerController.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/11/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

class VideoPlayerController : AnalyticsViewController {
    // MARK: Internal Variables
    var mScrollView : VideoPlayerScrollView?
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenName = "VideoPlayerController"
        AnalyticsController.sharedController.screenHeight = Double(view.frame.size.height)
        AnalyticsController.sharedController.screenWidth = Double(view.frame.size.width)
        
        var frame = self.view.frame
        if (frame.origin.y == 0) {
            frame.size.height -= (HourglassConstants.navBarHeight + UIApplication.sharedApplication().statusBarFrame.size.height)
        } else {
            frame.origin.y = 0
        }
        mScrollView = VideoPlayerScrollView(frame: frame)
        HourglassNavigationController.sharedInstance?.updateCategory((mScrollView?.activeCategory)!)
        self.view.addSubview(mScrollView!)
        tapRec.delegate = mScrollView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //mScrollView!.setContentOffset(CGPointMake(0, self.view.frame.size.height / 2), animated: true)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    func pauseVideo() {
        mScrollView!.pauseVideo()
    }
    
    func resumeVideo() {
        mScrollView!.resumeVideo()
    }
    
    func ignoreTap(value : Bool) {
        mScrollView!.ignoreTap = value
    }
    
    func setActive(value : Bool) {
        mScrollView!.activeView = value
    }
    
    func updateCategory(category: String) {
        mScrollView!.activeCategory = category
    }
    
    func getCategory() -> String? {
        return mScrollView?.activeCategory
    }
    
    func reset() {
        mScrollView!.reset()
    }
}