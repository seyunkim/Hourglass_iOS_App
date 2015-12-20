//
//  HourglassNavigationController.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/12/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

class HourglassNavigationController : UIViewController, UISearchBarDelegate {
    // MARK: Private variables
    static var sharedInstance : HourglassNavigationController?
    
    var mVideoController : VideoPlayerController?
    var mCameraController : CameraController?
    var mProfileController : ProfileViewController?
    var mCategoriesController : CategoriesViewController?
    var mActiveController = 1
    var mPreviousController = 1
    var mActiveCategory = "Trending"
    var subFrame : CGRect?
    
    var mSearchButton : AnalyticsUIButton?
    var searchBar : UISearchBar?
    var mAppIcon : AnalyticsUIButton?
    var mProfileButton : AnalyticsUIButton?
    
    var mVideoLabel : UILabel?
    var mCameraLabel : UILabel?
    var mCategoriesLabel: UILabel?
    
    
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
        HourglassNavigationController.sharedInstance = self
        
        mVideoController = VideoPlayerController()
        mCameraController = CameraController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        mProfileController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
        mCategoriesController = storyboard.instantiateViewControllerWithIdentifier("CategoriesViewController") as? CategoriesViewController
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
        
        let cancelSearchRec = UITapGestureRecognizer()
        cancelSearchRec.addTarget(self, action: "tappedScreen:")
        self.view.addGestureRecognizer(cancelSearchRec)
        
        // Build our nav view
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navView = UIView(frame: CGRectMake(
            0,
            0,
            self.view.frame.width,
            HourglassConstants.navBarHeight + statusBarHeight))
        navView.backgroundColor = HourglassConstants.logoColor
        self.view.addSubview(navView)
        
        let statusView = UIView(frame: CGRectMake(
            0,
            0,
            self.view.frame.width,
            statusBarHeight))
        statusView.backgroundColor = UIColor.lightGrayColor()
        navView.addSubview(statusView)
        
        mSearchButton = AnalyticsUIButton(type: .System)
        mSearchButton?.mAnalyticsButtonIdentifier = "Search"
        mSearchButton?.backgroundColor = UIColor.clearColor()
        mSearchButton?.frame = CGRectMake(view.frame.width - (HourglassConstants.navBarHeight - 8.0) - 5.0, statusBarHeight + 4.0, HourglassConstants.navBarHeight - 8.0, HourglassConstants.navBarHeight - 8.0)
        mSearchButton?.setImage(UIImage(named: "Search"), forState: UIControlState.Normal)
        mSearchButton?.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mSearchButton?.tintColor = UIColor.whiteColor()
        mSearchButton?.addTarget(self, action: "openSearch", forControlEvents: .TouchUpInside)
        navView.addSubview(mSearchButton!)
        
        searchBar = UISearchBar(frame: mSearchButton!.frame)
        searchBar?.frame = CGRectMake(5.0, self.mSearchButton!.frame.origin.y, self.view.frame.width - 10.0, self.mSearchButton!.frame.height)
        let originY = searchBar!.frame.origin.y
        let originX = searchBar!.frame.origin.x
        searchBar?.searchBarStyle = UISearchBarStyle.Default
        searchBar?.barTintColor = UIColor.clearColor()
        searchBar?.backgroundImage = UIImage()
        searchBar?.returnKeyType = UIReturnKeyType.Search
        searchBar?.delegate = self
        searchBar?.hidden = true
        searchBar?.placeholder = "Search"
        searchBar?.layer.anchorPoint = CGPointMake(CGFloat(1.0), CGFloat(0.0))
        searchBar?.layer.position = CGPointMake(originX + searchBar!.frame.size.width, originY)
        searchBar?.transform = CGAffineTransformMakeScale(0, 1)
        navView.addSubview(searchBar!)
        
        mAppIcon = AnalyticsUIButton(type: .Custom)
        mAppIcon?.mAnalyticsButtonIdentifier = "App Icon"
        mAppIcon?.backgroundColor = UIColor.clearColor()
        mAppIcon?.frame = CGRectMake(view.frame.width / 2.0 - (HourglassConstants.navBarHeight - 8.0) / 2.0, statusBarHeight + 4.0, HourglassConstants.navBarHeight - 8.0, HourglassConstants.navBarHeight - 8.0)
        // We need a new transparent version of the icon for here
        mAppIcon?.setImage(UIImage(named: "icon"), forState: .Normal)
        navView.addSubview(mAppIcon!)
        
        mProfileButton = AnalyticsUIButton(type: .System)
        mProfileButton?.mAnalyticsButtonIdentifier = "Profile"
        mProfileButton?.backgroundColor = UIColor.clearColor()
        mProfileButton?.frame = CGRectMake(5.0, statusBarHeight + 4.0, HourglassConstants.navBarHeight - 8.0, HourglassConstants.navBarHeight - 8.0)
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
        
        self.addChildViewController(mCategoriesController!)
        mCategoriesController!.view.frame = rightOffscreenFrame
        self.view.addSubview(mCategoriesController!.view)
        
        self.addChildViewController(mCameraController!)
        mCameraController!.view.frame = leftOffscreenFrame
        self.view.addSubview(mCameraController!.view)
        
        self.addChildViewController(mProfileController!)
        mProfileController!.view.frame = topOffsetFrame
        self.view.addSubview(mProfileController!.view)
        
        // Add our page titles
        let pageTitleView = UIView(frame: CGRectMake(0, navView.frame.origin.y + navView.frame.height, view.frame.width, 24))
        pageTitleView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        view.addSubview(pageTitleView)
        
        mCameraLabel = UILabel(frame: CGRectMake(5.0, 2.0, (self.view.frame.width - 20.0) / 3.0, 20.0))
        mCameraLabel?.textColor = UIColor.whiteColor()
        mCameraLabel?.backgroundColor = UIColor.clearColor()
        mCameraLabel?.text = "Camera"
        mCameraLabel?.adjustsFontSizeToFitWidth = true
        mCameraLabel?.textAlignment = .Center
        pageTitleView.addSubview(mCameraLabel!)
        
        mVideoLabel = UILabel(frame: CGRectMake(self.view.frame.width / 2.0 - ((self.view.frame.width - 20.0) / 3.0) / 2.0, 2.0, (self.view.frame.width - 20.0) / 3.0, 20.0))
        mVideoLabel?.textColor = UIColor.whiteColor()
        mVideoLabel?.backgroundColor = UIColor.clearColor()
        mVideoLabel?.text = "Trending"
        mVideoLabel?.adjustsFontSizeToFitWidth = true
        mVideoLabel?.textAlignment = .Center
        pageTitleView.addSubview(mVideoLabel!)
        
        mCategoriesLabel = UILabel(frame: CGRectMake(self.view.frame.width - ((self.view.frame.width - 20.0) / 3.0) - 5.0, 2.0, (self.view.frame.width - 20.0) / 3.0, 20.0))
        mCategoriesLabel?.textColor = UIColor.whiteColor()
        mCategoriesLabel?.backgroundColor = UIColor.clearColor()
        mCategoriesLabel?.text = "Browse"
        mCategoriesLabel?.adjustsFontSizeToFitWidth = true
        mCategoriesLabel?.textAlignment = .Center
        pageTitleView.addSubview(mCategoriesLabel!)
        
        view.bringSubviewToFront(navView)
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
                    self.mCameraController!.startCamera()
                    self.mCameraController!.view.frame = self.subFrame!
                    self.mVideoController!.view.frame = middleOffscreenFrame
                    self.mCategoriesController!.view.frame = rightOffscreenFrame
                
                    self.mCategoriesLabel?.frame.origin.x += (self.mCategoriesLabel!.frame.width + 5.0)
                    self.mVideoLabel?.frame.origin.x += (self.mCategoriesLabel!.frame.width + 5.0)
                    self.mCameraLabel?.frame.origin.x += (self.mCategoriesLabel!.frame.width + 5.0)
                }, completion: { (finished) -> Void in
                    // Finished Code
                    self.mVideoController!.screenName = "ProfileViewController"
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
                    self.mVideoController!.screenName = "VideoPlayerController"
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
                    self.mVideoController!.screenName = "VideoPlayerController"
                    self.mActiveController = 1
                    self.mVideoController!.setActive(true)
                    self.mVideoController!.resumeVideo()
                    self.mCameraController!.stopCamera()
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
                    self.mVideoController!.screenName = "CategoriesViewrController"
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
    
    // MARK: Search Functions
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // For now, just cancel
        searchBar.text = ""
        searchBar.resignFirstResponder()
        AnalyticsController.logSpecial("SearchCompleted", details: searchBar.text!)
        let alert = UIAlertController(title: "Coming Soon!", message: "Thanks for using Hourglass! Our search feature is coming in a new release soon!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Can't Wait!", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        self.presentViewController(alert, animated: true) { () -> Void in
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        mVideoController?.ignoreTap(true)
        mVideoController?.pauseVideo()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.mVideoController?.ignoreTap(false)
        self.mVideoController?.resumeVideo()
        
        closeSearch()
    }
    
    func tappedScreen(tgr : UITapGestureRecognizer){
        let touchPoint : CGPoint = tgr.locationInView(self.view)
        if touchPoint.y > HourglassConstants.navBarHeight + UIApplication.sharedApplication().statusBarFrame.size.height {
            if searchBar!.isFirstResponder() {
                AnalyticsController.logSpecial("SearchCancelled", details: "")
                searchBar?.text = ""
                searchBar?.resignFirstResponder()
            }
        }
    }
    
    func openSearch() {
        self.searchBar?.alpha = 0.0
        self.searchBar?.hidden = false
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.mSearchButton?.alpha = 0.0
            self.mAppIcon?.alpha = 0.0
            self.mProfileButton?.alpha = 0.0
            
            self.searchBar?.alpha = 1.0
            }) { (finished) -> Void in
                self.mSearchButton?.enabled = false
                self.mSearchButton?.hidden = true
                self.mAppIcon?.enabled = false
                self.mAppIcon?.hidden = true
                self.mProfileButton?.enabled = false
                self.mProfileButton?.hidden = true
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.searchBar?.transform = CGAffineTransformIdentity
                    }, completion: { (done) -> Void in
                        // Finished
                        self.searchBar?.becomeFirstResponder()
                })
        }
    }
    
    func closeSearch() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.searchBar?.transform = CGAffineTransformMakeScale(0, 1)
            }) { (finished) -> Void in
                self.mSearchButton?.hidden = false
                self.mAppIcon?.hidden = false
                self.mProfileButton?.hidden = false
                
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.searchBar?.alpha = 0.0
                    self.mSearchButton?.alpha = 1.0
                    self.mAppIcon?.alpha = 1.0
                    self.mProfileButton?.alpha = 1.0
                    }, completion: { (done) -> Void in
                        // Finished
                        self.mSearchButton?.enabled = true
                        self.mAppIcon?.enabled = true
                        self.mProfileButton?.enabled = true
                        self.searchBar?.hidden = true
                })
        }
    }
}
