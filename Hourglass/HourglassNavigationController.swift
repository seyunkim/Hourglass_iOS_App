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
    var mVideoController : VideoPlayerController?
    var mProfileController : ProfileViewController?
    var mCategoriesController : CategoriesViewController?
    var mActiveController = 1
    var subFrame : CGRect?
    
    var leftButton : UIButton?
    var rightButton : UIButton?
    var searchBar : UISearchBar?
    
    let navViewHeight = CGFloat(64)
    let buttonHeight = CGFloat(56)
    
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
        mVideoController = VideoPlayerController()
        
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
            navViewHeight + statusBarHeight))
        navView.backgroundColor = UIColor.darkGrayColor()
        self.view.addSubview(navView)
        
        let statusView = UIView(frame: CGRectMake(
            0,
            0,
            self.view.frame.width,
            statusBarHeight))
        statusView.backgroundColor = UIColor.lightGrayColor()
        navView.addSubview(statusView)
        
        leftButton = UIButton(frame: CGRectMake(
            10,
            statusBarHeight + (navViewHeight - buttonHeight) / 2,
            self.view.frame.width / 5.0,
            buttonHeight))
        leftButton!.setTitle("Profile", forState: UIControlState.Normal)
        leftButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        leftButton!.backgroundColor = UIColor.clearColor()
        navView.addSubview(leftButton!)
        leftButton!.addTarget(self, action: "cycleLeft", forControlEvents: UIControlEvents.TouchUpInside)
        
        rightButton = UIButton(frame: CGRectMake(
            self.view.frame.width - 10 - self.view.frame.width / 5.0,
            statusBarHeight + (navViewHeight - buttonHeight) / 2,
            self.view.frame.width / 5.0,
            buttonHeight))
        rightButton!.setTitle("Browse", forState: UIControlState.Normal)
        rightButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rightButton!.backgroundColor = UIColor.clearColor()
        navView.addSubview(rightButton!)
        rightButton!.addTarget(self, action: "cycleRight", forControlEvents: UIControlEvents.TouchUpInside)
        
        searchBar = UISearchBar(frame: CGRectMake(
            self.view.frame.width / 5.0 + 10,
            statusBarHeight + (navViewHeight - buttonHeight) / 2,
            self.view.frame.width * 3 / 5.0 - 20,
            buttonHeight))
        searchBar?.searchBarStyle = UISearchBarStyle.Default
        searchBar?.barTintColor = UIColor.clearColor()
        searchBar?.backgroundImage = UIImage()
        searchBar?.returnKeyType = UIReturnKeyType.Search
        searchBar?.delegate = self
        navView.addSubview(searchBar!)
        
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
        
        self.addChildViewController(mProfileController!)
        mProfileController!.view.frame = leftOffscreenFrame
        self.view.addSubview(mProfileController!.view)
        
        self.addChildViewController(mCategoriesController!)
        mCategoriesController!.view.frame = rightOffscreenFrame
        self.view.addSubview(mCategoriesController!.view)
    }
    
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
                    self.mProfileController!.view.frame = self.subFrame!
                    self.mVideoController!.view.frame = middleOffscreenFrame
                    self.mCategoriesController!.view.frame = rightOffscreenFrame
                
                    self.leftButton!.setTitle("", forState: .Normal)
                    self.rightButton!.setTitle("Feed", forState: .Normal)
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
                self.mProfileController!.view.frame = leftOffscreenFrame
                self.mVideoController!.view.frame = self.subFrame!
                self.mCategoriesController!.view.frame = rightOffscreenFrame
                
                self.leftButton!.setTitle("Profile", forState: .Normal)
                self.rightButton!.setTitle("Browse", forState: .Normal)
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
                self.mProfileController!.view.frame = leftOffscreenFrame
                self.mVideoController!.view.frame = self.subFrame!
                self.mCategoriesController!.view.frame = rightOffscreenFrame
                
                self.leftButton!.setTitle("Profile", forState: .Normal)
                self.rightButton!.setTitle("Browse", forState: .Normal)
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
                self.mProfileController!.view.frame = leftOffscreenFrame
                self.mVideoController!.view.frame = middleOffscreenFrame
                self.mCategoriesController!.view.frame = self.subFrame!
                
                self.leftButton!.setTitle("Feed", forState: .Normal)
                self.rightButton!.setTitle("", forState: .Normal)
                }, completion: { (finished) -> Void in
                    // Finished Code
                    self.mActiveController = 2
            })
        } else if mActiveController == 2 {
            // We are already on the right screen, do nothing
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // MARK: Search Functions
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // For now, just cancel
        AnalyticsController.logSpecial("SearchCompleted", details: searchBar.text!)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        mVideoController?.ignoreTap(true)
        mVideoController?.pauseVideo()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        let alert = UIAlertController(title: "Coming Soon!", message: "Thanks for using Hourglass! Our search feature is coming in a new release soon!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Can't Wait!", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.mVideoController?.ignoreTap(false)
            self.mVideoController?.resumeVideo()
        }))
        self.presentViewController(alert, animated: true) { () -> Void in
            
        }
    }
    
    func tappedScreen(tgr : UITapGestureRecognizer){
        let touchPoint : CGPoint = tgr.locationInView(self.view)
        if touchPoint.y > navViewHeight + UIApplication.sharedApplication().statusBarFrame.size.height {
            if searchBar!.isFirstResponder() {
                AnalyticsController.logSpecial("SearchCancelled", details: "")
                searchBar?.text = ""
                searchBar?.resignFirstResponder()
            }
        }
    }
}
