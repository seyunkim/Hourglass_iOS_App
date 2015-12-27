//
//  HourglassNavigationController.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HANavigationController : UIViewController {
    // MARK: Private variables
    static var sharedInstance : HANavigationController?
    
    var mVideoController : HAVideoPlayerController?
    var mCameraController : HACameraController?
    var mProfileController : HAProfileViewController?
    var mCategoriesController : HACategoriesViewController?
    var mActiveCategory = "Trending"
    var mActiveController = 1
    var mPreviousController = 1
    var subFrame : CGRect?
    
    var mSearchButton : UIButton?
    var mAppIcon : UIButton?
    var mProfileButton : UIButton?
    
    var mVideoLabel : UILabel?
    var mCameraLabel : UILabel?
    var mCategoriesLabel: UILabel?
    
    var mButtonsLoaded = false
    var mEnterBackgroundsLoaded = false
    var mScreenLoadsLoaded = false
    var mSpecialEventsLoaded = false
    var mTapsLoaded = false
    
    var mStatsView : HAStatsTableView?
    var mStatsUp = false
    
    var mLoadingView : UIView?
    
    
    // MARK: Initialization methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationImplementation()
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializationImplementation()
    }
    
    func initializationImplementation() {
        HANavigationController.sharedInstance = self
        
        mVideoController = HAVideoPlayerController()
        mCameraController = HACameraController()
        mProfileController = HAProfileViewController()
        mCategoriesController = HACategoriesViewController(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        let leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.addTarget(self, action: "handleSwipes:")
        leftSwipe.direction = .Left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.addTarget(self, action: "handleSwipes:")
        rightSwipe.direction = .Right
        self.view.addGestureRecognizer(rightSwipe)
        
        // Build our nav view
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navView = UIView(frame: CGRectMake(
            0,
            0,
            self.view.frame.width,
            HAConstants.navBarHeight + statusBarHeight))
        navView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(navView)
        
        let statusView = UIView(frame: CGRectMake(
            0,
            0,
            self.view.frame.width,
            statusBarHeight))
        statusView.backgroundColor = UIColor.lightGrayColor()
        navView.addSubview(statusView)
        
        mSearchButton = UIButton(type: .System)
        mSearchButton?.backgroundColor = UIColor.clearColor()
        mSearchButton?.frame = CGRectMake(view.frame.width - (HAConstants.navBarHeight - 8.0) - 5.0, statusBarHeight + 4.0, HAConstants.navBarHeight - 8.0, HAConstants.navBarHeight - 8.0)
        mSearchButton?.setImage(UIImage(named: "Search"), forState: UIControlState.Normal)
        mSearchButton?.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mSearchButton?.tintColor = UIColor.whiteColor()
        mSearchButton?.addTarget(self, action: "openSearch", forControlEvents: .TouchUpInside)
        navView.addSubview(mSearchButton!)
        
        mAppIcon = UIButton(type: .Custom)
        mAppIcon?.backgroundColor = UIColor.whiteColor()
        mAppIcon?.frame = CGRectMake((view.frame.width / 2.0 - (HAConstants.navBarHeight + 25.0) / 2.0) , statusBarHeight + 4.0, HAConstants.navBarHeight + 80.0, HAConstants.navBarHeight - 8.0)
        mAppIcon?.center = CGPointMake(navView.frame.size.width/2, navView.frame.size.height * 0.70)
        mAppIcon?.setTitle("Hourglass", forState: .Normal)
        mAppIcon?.addTarget(self, action: "iconPressed", forControlEvents: .TouchUpInside)
        navView.addSubview(mAppIcon!)
        
        mProfileButton = UIButton(type: .System)
        mProfileButton?.backgroundColor = UIColor.clearColor()
        mProfileButton?.frame = CGRectMake(5.0, statusBarHeight + 4.0, HAConstants.navBarHeight - 8.0, HAConstants.navBarHeight - 8.0)
        mProfileButton?.setImage(UIImage(named: "Profile"), forState: .Normal)
        mProfileButton?.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        mProfileButton?.tintColor = UIColor.whiteColor()
        mProfileButton?.addTarget(self, action: "toggleProfile", forControlEvents: .TouchUpInside)
        navView.addSubview(mProfileButton!)
        
        // Add our content views
        subFrame = self.view.frame
        subFrame?.origin.y += navView.frame.height
        subFrame?.size.height -= navView.frame.height
        
        self.addChildViewController(mVideoController!)
        mVideoController!.view.frame = subFrame!
        self.view.addSubview(mVideoController!.view)
        
        var leftOffscreenFrame = subFrame!
        leftOffscreenFrame.origin.x -= subFrame!.width
        var rightOffscreenFrame = subFrame!
        rightOffscreenFrame.origin.x += subFrame!.width
        var topOffsetFrame = subFrame!
        topOffsetFrame.origin.y -= subFrame!.height
        var bottomOffsetFrame = subFrame!
        bottomOffsetFrame.origin.y += subFrame!.height
        
        self.addChildViewController(mCategoriesController!)
        mCategoriesController!.view.frame = rightOffscreenFrame
        self.view.addSubview(mCategoriesController!.view)
        
        self.addChildViewController(mCameraController!)
        mCameraController!.view.frame = leftOffscreenFrame
        mCameraController!.reloadCamera()
        self.view.addSubview(mCameraController!.view)
        
        self.addChildViewController(mProfileController!)
        mProfileController!.view.frame = topOffsetFrame
        mProfileController!.load()
        self.view.addSubview(mProfileController!.view)
        
        // Add our page titles
        let pageTitleView = UIView(frame: CGRectMake(0, navView.frame.origin.y + navView.frame.height, view.frame.width, 24))
        pageTitleView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        view.addSubview(pageTitleView)
        
        mCameraLabel = UILabel(frame: CGRectMake(5.0, 2.0, (self.view.frame.width - 20.0) / 3.0, 20.0))
        mCameraLabel?.textColor = UIColor.whiteColor()
        mCameraLabel?.backgroundColor = UIColor.clearColor()
        mCameraLabel?.text = "Camera"
        mCameraLabel?.font = UIFont(name: "Montserrat-Regular", size: 15.0)
        mCameraLabel?.adjustsFontSizeToFitWidth = true
        mCameraLabel?.textAlignment = .Center
        pageTitleView.addSubview(mCameraLabel!)
        
        mVideoLabel = UILabel(frame: CGRectMake(self.view.frame.width / 2.0 - ((self.view.frame.width - 20.0) / 3.0) / 2.0, 2.0, (self.view.frame.width - 20.0) / 3.0, 20.0))
        mVideoLabel?.textColor = UIColor.whiteColor()
        mVideoLabel?.backgroundColor = UIColor.clearColor()
        mVideoLabel?.text = "Trending"
        mVideoLabel?.font = UIFont(name: "Montserrat-Regular", size: 15.0)
        mVideoLabel?.adjustsFontSizeToFitWidth = true
        mVideoLabel?.textAlignment = .Center
        pageTitleView.addSubview(mVideoLabel!)
        
        mCategoriesLabel = UILabel(frame: CGRectMake(self.view.frame.width - ((self.view.frame.width - 20.0) / 3.0) - 5.0, 2.0, (self.view.frame.width - 20.0) / 3.0, 20.0))
        mCategoriesLabel?.textColor = UIColor.whiteColor()
        mCategoriesLabel?.backgroundColor = UIColor.clearColor()
        mCategoriesLabel?.text = "Browse"
        mCategoriesLabel?.font = UIFont(name: "Montserrat-Regular", size: 15.0)
        mCategoriesLabel?.adjustsFontSizeToFitWidth = true
        mCategoriesLabel?.textAlignment = .Center
        pageTitleView.addSubview(mCategoriesLabel!)
        
        mStatsView = HAStatsTableView(frame: bottomOffsetFrame)
        mStatsView?.delegate = mStatsView!
        mStatsView?.dataSource = mStatsView!
        view.addSubview(mStatsView!)
        
        view.bringSubviewToFront(navView)
        
        showLoading()
    }
    
    // MARK: Navigation Methods
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            cycleRight()
        } else if (sender.direction == .Right) {
            cycleLeft()
        }
    }
    
    func cycleLeft() {
        if mActiveController == 0 {
            // We are already on the left screen, do nothing
        } else if mActiveController == 1 {
            // We are on the center screen
            mVideoController!.pauseVideo()
            mVideoController!.setActive(false)
            
            var middleOffscreenFrame = subFrame!
            middleOffscreenFrame.origin.x += subFrame!.width
            var rightOffscreenFrame = subFrame!
            rightOffscreenFrame.origin.x += subFrame!.width * 2
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.mCameraController!.view.frame = self.subFrame!
                self.mVideoController!.view.frame = middleOffscreenFrame
                self.mCategoriesController!.view.frame = rightOffscreenFrame
                
                self.mCategoriesLabel?.frame.origin.x += (self.mCategoriesLabel!.frame.width + 5.0)
                self.mVideoLabel?.frame.origin.x += (self.mCategoriesLabel!.frame.width + 5.0)
                self.mCameraLabel?.frame.origin.x += (self.mCategoriesLabel!.frame.width + 5.0)
                }, completion: { (finished) -> Void in
                    // Finished Code
                    self.mActiveController = 0
            })
        } else if mActiveController == 2 {
            // We are on the right screen
            var leftOffscreenFrame = subFrame!
            leftOffscreenFrame.origin.x -= subFrame!.width
            var rightOffscreenFrame = subFrame!
            rightOffscreenFrame.origin.x += subFrame!.width
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.mCameraController!.view.frame = leftOffscreenFrame
                self.mVideoController!.view.frame = self.subFrame!
                self.mCategoriesController!.view.frame = rightOffscreenFrame
                
                self.mCategoriesLabel?.frame.origin.x += (self.mCategoriesLabel!.frame.width + 5.0)
                self.mVideoLabel?.frame.origin.x += (self.mCategoriesLabel!.frame.width + 5.0)
                self.mCameraLabel?.frame.origin.x += (self.mCategoriesLabel!.frame.width + 5.0)
                }, completion: { (finished) -> Void in
                    // Finished Code
                    self.mActiveController = 1
                    self.mVideoController!.setActive(true)
                    self.mVideoController!.resumeVideo()
            })
        }
    }
    
    func cycleRight() {
        if mActiveController == 0 {
            // We are on the left screen
            var leftOffscreenFrame = subFrame!
            leftOffscreenFrame.origin.x -= subFrame!.width
            var rightOffscreenFrame = subFrame!
            rightOffscreenFrame.origin.x += subFrame!.width
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.mCameraController!.view.frame = leftOffscreenFrame
                self.mVideoController!.view.frame = self.subFrame!
                self.mCategoriesController!.view.frame = rightOffscreenFrame
                
                self.mCategoriesLabel?.frame.origin.x -= (self.mCategoriesLabel!.frame.width + 5.0)
                self.mVideoLabel?.frame.origin.x -= (self.mCategoriesLabel!.frame.width + 5.0)
                self.mCameraLabel?.frame.origin.x -= (self.mCategoriesLabel!.frame.width + 5.0)
                }, completion: { (finished) -> Void in
                    // Finished Code
                    self.mActiveController = 1
                    self.mVideoController!.setActive(true)
                    self.mVideoController!.resumeVideo()
            })
        } else if mActiveController == 1 {
            // We are on the center screen
            mVideoController!.pauseVideo()
            mVideoController!.setActive(false)
            
            var middleOffscreenFrame = subFrame!
            middleOffscreenFrame.origin.x -= subFrame!.width
            var leftOffscreenFrame = subFrame!
            leftOffscreenFrame.origin.x -= subFrame!.width * 2
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.mCameraController!.view.frame = leftOffscreenFrame
                self.mVideoController!.view.frame = middleOffscreenFrame
                self.mCategoriesController!.view.frame = self.subFrame!
                
                self.mCategoriesLabel?.frame.origin.x -= (self.mCategoriesLabel!.frame.width + 5.0)
                self.mVideoLabel?.frame.origin.x -= (self.mCategoriesLabel!.frame.width + 5.0)
                self.mCameraLabel?.frame.origin.x -= (self.mCategoriesLabel!.frame.width + 5.0)
                }, completion: { (finished) -> Void in
                    // Finished Code
                    self.mActiveController = 2
            })
        } else if mActiveController == 2 {
            // We are already on the right screen, do nothing
        }
    }
    
    func cycleUp() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mCameraController!.view.frame.origin.y -= self.subFrame!.height
            self.mVideoController!.view.frame.origin.y -= self.subFrame!.height
            self.mCategoriesController!.view.frame.origin.y -= self.subFrame!.height
            
            self.mProfileController!.view.frame.origin.y -= self.subFrame!.height
            
            self.mProfileButton?.alpha = 0.0
            
            self.mCategoriesLabel?.alpha = 0.0
            self.mVideoLabel?.alpha = 0.0
            self.mCameraLabel?.alpha = 0.0
            
            }) { (finished) -> Void in
                self.mActiveController = self.mPreviousController
                if self.mActiveController == 0 {
                    self.mCameraLabel?.text = "Camera"
                } else if self.mActiveController == 1 {
                    self.mVideoController?.resumeVideo()
                    self.mVideoLabel?.text = self.mActiveCategory
                } else if self.mActiveController == 2 {
                    self.mCategoriesLabel?.text = "Browse"
                }
                self.mProfileButton?.setImage(UIImage(named: "Profile"), forState: .Normal)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.mProfileButton?.alpha = 1.0
                    
                    self.mCameraLabel?.alpha = 1.0
                    self.mVideoLabel?.alpha = 1.0
                    self.mCategoriesLabel?.alpha = 1.0
                    }, completion: { (done) -> Void in
                        // Code
                })
        }
    }
    
    func cycleDown() {
        mPreviousController = mActiveController
        mVideoController?.pauseVideo()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mCameraController!.view.frame.origin.y += self.subFrame!.height
            self.mVideoController!.view.frame.origin.y += self.subFrame!.height
            self.mCategoriesController!.view.frame.origin.y += self.subFrame!.height
            
            self.mProfileController!.view.frame.origin.y += self.subFrame!.height
            
            self.mProfileButton?.alpha = 0.0
            
            self.mCameraLabel?.alpha = 0.0
            self.mVideoLabel?.alpha = 0.0
            self.mCategoriesLabel?.alpha = 0.0
            
            }) { (finished) -> Void in
                if self.mActiveController == 0 {
                    self.mCameraLabel?.text = "Profile"
                } else if self.mActiveController == 1 {
                    self.mVideoLabel?.text = "Profile"
                } else if self.mActiveController == 2 {
                    self.mCategoriesLabel?.text = "Profile"
                }
                
                self.mActiveController = 3
                self.mProfileButton?.setImage(UIImage(named: "cancel"), forState: .Normal)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.mProfileButton?.alpha = 1.0
                    
                    if self.mPreviousController == 0 {
                        self.mCameraLabel?.alpha = 1.0
                    } else if self.mPreviousController == 1 {
                        self.mVideoLabel?.alpha = 1.0
                    } else if self.mPreviousController == 2 {
                        self.mCategoriesLabel?.alpha = 1.0
                    }
                    }, completion: { (done) -> Void in
                        // Code
                })
        }
    }
    
    func updateCategory(category: String) {
        mVideoController?.updateCategory(category)
        mVideoLabel?.text = category
        mActiveCategory = category
    }
    
    func reloadVideos() {
        mVideoController?.reset()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func toggleProfile() {
        if mActiveController != 3 {
            cycleDown()
        } else {
            cycleUp()
        }
    }
    
    func iconPressed() {
        if mStatsUp {
            var bottomOffsetFrame = subFrame!
            bottomOffsetFrame.origin.y += subFrame!.height
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.mStatsView?.frame = bottomOffsetFrame
            })
        } else {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.mStatsView?.frame = self.subFrame!
            })
        }
        mStatsUp = !mStatsUp
    }
    
    // MARK: Search Functions
    func openSearch() {
        
    }
    
    // MARK: Analytics Functions
    func buttonsLoaded() {
        mButtonsLoaded = true
        
        if (mButtonsLoaded && mEnterBackgroundsLoaded && mScreenLoadsLoaded && mSpecialEventsLoaded && mTapsLoaded) {
            reloadAnalytics()
        }
    }
    
    func enterBackgroundsLoaded() {
        mEnterBackgroundsLoaded = true
        
        if (mButtonsLoaded && mEnterBackgroundsLoaded && mScreenLoadsLoaded && mSpecialEventsLoaded && mTapsLoaded) {
            reloadAnalytics()
        }
    }
    
    func screenLoadsLoaded() {
        mScreenLoadsLoaded = true
        
        if (mButtonsLoaded && mEnterBackgroundsLoaded && mScreenLoadsLoaded && mSpecialEventsLoaded && mTapsLoaded) {
            reloadAnalytics()
        }
    }
    
    func specialEventsLoaded() {
        mSpecialEventsLoaded = true
        
        if (mButtonsLoaded && mEnterBackgroundsLoaded && mScreenLoadsLoaded && mSpecialEventsLoaded && mTapsLoaded) {
            reloadAnalytics()
        }
    }
    
    func tapsLoaded() {
        mTapsLoaded = true
        
        if (mButtonsLoaded && mEnterBackgroundsLoaded && mScreenLoadsLoaded && mSpecialEventsLoaded && mTapsLoaded) {
            reloadAnalytics()
        }
    }
    
    internal func reloadAnalytics() {
        reloadButtons()
        reloadScreenBackgrounds()
        reloadTaps()
        reloadStats()
        
        hideLoading()
    }
    
    internal func reloadButtons() {
        // Reload my own button colors
        // SEARCH
        if HAConstants.buttonTapDictionary.objectForKey("Search") != nil {
            let searchPercentage = (HAConstants.buttonTapDictionary.objectForKey("Search") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mSearchButton?.tintColor = HAConstants.colorForPercentage(searchPercentage)
        }
        
        // APP
        if HAConstants.buttonTapDictionary.objectForKey("App Icon") != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("App Icon") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mAppIcon?.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
        
        // PROFILE
        if HAConstants.buttonTapDictionary.objectForKey("Profile") != nil {
            let profilePercentage = (HAConstants.buttonTapDictionary.objectForKey("Profile") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mProfileButton?.tintColor = HAConstants.colorForPercentage(profilePercentage)
        }
        
        // Cycle through my views and reload their buttons
        mVideoController?.reloadButtons()
        mCameraController?.reloadButtons()
        mProfileController?.reloadButtons()
        mCategoriesController?.reloadButtons()
    }
    
    internal func reloadScreenBackgrounds() {
        mVideoController?.reloadScreenBackgrounds()
        mCameraController?.reloadScreenBackgrounds()
        mProfileController?.reloadScreenBackgrounds()
        mCategoriesController?.reloadScreenBackgrounds()
    }
    
    internal func reloadTaps() {
        mVideoController?.reloadTaps()
        mCameraController?.reloadTaps()
        mProfileController?.reloadTaps()
        mCategoriesController?.reloadTaps()
    }
    
    internal func reloadStats() {
        mStatsView?.reloadData()
    }
    
    // MARK: Loading Functions
    internal func showLoading() {
        mLoadingView = UIView(frame: subFrame!)
        
        let loadingHeight = CGFloat(60.0)
        let loadingLabel = UILabel(frame: CGRectMake(0, mLoadingView!.frame.height / 2.0 - loadingHeight / 2.0, mLoadingView!.frame.width, loadingHeight))
        loadingLabel.textAlignment = .Center
        loadingLabel.text = "Loading..."
        loadingLabel.adjustsFontSizeToFitWidth = true
        loadingLabel.backgroundColor = UIColor.blackColor()
        loadingLabel.textColor = UIColor.whiteColor()
        mLoadingView?.addSubview(loadingLabel)
        
        view.addSubview(mLoadingView!)
    }
    
    internal func hideLoading() {
        mLoadingView?.removeFromSuperview()
    }
}
