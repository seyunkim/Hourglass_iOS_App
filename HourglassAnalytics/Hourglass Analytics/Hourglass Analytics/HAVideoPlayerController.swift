//
//  HAVideoPlayerController.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright (c) 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HAVideoPlayerController : UIViewController {
    // MARK: Internal Variables
    var mScrollView : HAVideoPlayerScrollView?
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        var frame = self.view.frame
        if (frame.origin.y == 0) {
            frame.size.height -= (HAConstants.navBarHeight + UIApplication.sharedApplication().statusBarFrame.size.height)
        } else {
            frame.origin.y = 0
        }
        mScrollView = HAVideoPlayerScrollView(frame: frame)
        HANavigationController.sharedInstance?.updateCategory((mScrollView?.activeCategory)!)
        self.view.addSubview(mScrollView!)
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
    
    // MARK: Analytics Functions
    func reloadButtons() {
        mScrollView?.reloadButtons()
    }
    
    func reloadScreenBackgrounds() {
        if HAConstants.screenLoadDictionary.objectForKey("VideoPlayerController") != nil {
            let percentage = (HAConstants.screenLoadDictionary.objectForKey("VideoPlayerController") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxScreenLoads).doubleValue * 1.0)
            view.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
    }
    
    func reloadTaps() {
        mScrollView?.reloadTaps()
    }
}