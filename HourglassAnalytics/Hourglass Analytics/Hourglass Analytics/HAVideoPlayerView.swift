//
//  HAVideoPlayerView.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright (c) 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HAVideoPlayerView : UIView {
    // Mark: Internal Variables
    var mNameLabel : UILabel?
    var mCreditLabel : UILabel?
    
    // MARK: Setup
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationImplementation("The Church State", source: "@seyunkim", startingVideoName: "churchstate", startingVideoExtension: ".mp4")
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initializationImplementation("The Church State", source: "@seyunkim", startingVideoName: "churchstate", startingVideoExtension: ".mp4")
    }
    
    init (frame: CGRect, name: String, credit: String, startingVideoName: String, startingVideoExtension: String) {
        super.init(frame: frame)
        initializationImplementation(name, source: credit, startingVideoName: startingVideoName, startingVideoExtension: startingVideoExtension)
    }
    
    func initializationImplementation(name : String, source : String, startingVideoName : String, startingVideoExtension : String) {
        
        backgroundColor = UIColor.clearColor()
        
        // Translucent bottom bar
        let translucentView = UIView(frame: CGRectMake(self.frame.origin.x, self.frame.origin.y+(self.frame.height * 4 / 5.0), self.frame.width, (self.frame.height / 5.0)))
        translucentView.backgroundColor = UIColor.clearColor()
        let gradientLayer = CAGradientLayer()
        var gradientFrame = translucentView.frame
        gradientFrame.origin.x = 0
        gradientFrame.origin.y = 0
        gradientLayer.frame = gradientFrame
        
        let blackColor = UIColor.blackColor()
        var colorArray = NSArray(objects: blackColor.CGColor,
            blackColor.colorWithAlphaComponent(0.9).CGColor,
            blackColor.colorWithAlphaComponent(0.8).CGColor,
            blackColor.colorWithAlphaComponent(0.7).CGColor,
            blackColor.colorWithAlphaComponent(0.6).CGColor,
            blackColor.colorWithAlphaComponent(0.3).CGColor,
            UIColor.clearColor().CGColor)
        colorArray = colorArray.reverseObjectEnumerator().allObjects
        
        gradientLayer.colors = colorArray as [AnyObject]
        translucentView.layer.insertSublayer(gradientLayer, atIndex: 0)
        self.addSubview(translucentView)
        
        // Labels for restaurant name and credit
        let horizontalOffset = CGFloat(96)
        mNameLabel = UILabel(frame: CGRectMake(
            translucentView.frame.origin.x + horizontalOffset,
            translucentView.frame.origin.y,
            translucentView.frame.width - horizontalOffset,
            translucentView.frame.height / 2))
        mNameLabel!.backgroundColor = UIColor.clearColor()
        mNameLabel!.textColor = UIColor.whiteColor()
        mNameLabel!.text = name
        mNameLabel!.font = UIFont.systemFontOfSize(36)
        mNameLabel!.font = UIFont(name: "Montserrat-Regular", size: 36.0)
        mNameLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mNameLabel!)
        
        mCreditLabel = UILabel(frame: CGRectMake(
            translucentView.frame.origin.x + horizontalOffset,
            translucentView.frame.origin.y + translucentView.frame.height / 2,
            translucentView.frame.width - horizontalOffset,
            translucentView.frame.height / 2))
        mCreditLabel!.backgroundColor = UIColor.clearColor()
        mCreditLabel!.textColor = UIColor.whiteColor()
        mCreditLabel!.text = "Credit: " + source
        mCreditLabel!.font = UIFont.systemFontOfSize(18)
        mCreditLabel!.font = UIFont(name: "Montserrat-Regular", size: 18.0)
        mCreditLabel!.adjustsFontSizeToFitWidth = true
        mCreditLabel!.sizeToFit()
        self.addSubview(mCreditLabel!)
        
        // Image View for down arrow
        let imageDimensions = CGFloat(64)
        let downImage = UIImageView(frame: CGRectMake(
            translucentView.frame.origin.x + (horizontalOffset - imageDimensions) / 2,
            translucentView.frame.origin.y + (translucentView.frame.height - imageDimensions) / 3,
            imageDimensions,
            imageDimensions))
        downImage.backgroundColor = UIColor.clearColor()
        downImage.image = UIImage(named: "DownArrow")
        self.addSubview(downImage)
    }
    
    // MARK: Delegate Methods
    func pauseVideo() {
        
    }
    
    func resumeVideo() {
        
    }
    
    func playerItemDidReachEnd(notification : NSNotification) {
        
    }
    
    // MARK: Handle AV Notifications
    func doPauseVideo() {
        
    }
    
    func doResumeVideo() {
        
    }
    
    // MARK: Video Navigation
    internal func doChangeToFile(fileName: String, fileExtension: String) {
        
    }
    
    func changeRestaurant(name: String, source: String, fileName: String, fileExtension: String) {
        doChangeToFile(fileName, fileExtension: fileExtension)
        
        mNameLabel?.text = name
        mCreditLabel?.frame = CGRectMake(mCreditLabel!.frame.origin.x, mCreditLabel!.frame.origin.y, (self.frame.width - 2 * mCreditLabel!.frame.origin.x), (self.frame.height - mCreditLabel!.frame.origin.y))
        mCreditLabel?.text = "Credit: " + source
        mCreditLabel?.sizeToFit()
    }
    
    // MARK: Analytics Functions
    func reloadButtons() {
        
    }
}