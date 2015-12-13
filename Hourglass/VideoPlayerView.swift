//
//  VideoPlayerView.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/12/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol VideoPlayerViewDelegate {
    func pauseVideo()
    func resumeVideo()
    func playerItemDidReachEnd(notification : NSNotification)
}

class VideoPlayerView : UIView {
    // Mark: Internal Variables
    var avPlayer : AVPlayer?
    var avPlayerLayer : AVPlayerLayer?
    var cmTime : CMTime?
    
    var viewDelegate : VideoPlayerViewDelegate?
    
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
        // Initialize AVPlayer
        let value = NSNumber(integer: UIInterfaceOrientation.Portrait.rawValue)
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        let resource = NSBundle.mainBundle().pathForResource(startingVideoName, ofType: startingVideoExtension)
        
        let urlPathOfVideo = NSURL(fileURLWithPath: resource!)
        avPlayer = AVPlayer(URL: urlPathOfVideo)
        avPlayer!.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer!)
        avPlayerLayer!.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        self.layer.addSublayer(avPlayerLayer!)
        
        avPlayer!.play()
        cmTime = kCMTimeZero
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            
        }
        
        // AVPlayer Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer!.currentItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseVideo", name: "PauseBgVideo", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resumeVideo", name: "ResumeBgVideo", object: nil)
        
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
        if let del = viewDelegate as VideoPlayerViewDelegate! {
            del.pauseVideo()
        }
    }
    
    func resumeVideo() {
        if let del = viewDelegate as VideoPlayerViewDelegate! {
            del.resumeVideo()
        }
    }
    
    func playerItemDidReachEnd(notification : NSNotification) {
        if let del = viewDelegate as VideoPlayerViewDelegate! {
            del.playerItemDidReachEnd(notification)
        }
    }
    
    // MARK: Handle AV Notifications
    func doPauseVideo() {
        avPlayer?.pause()
        cmTime = avPlayer?.currentTime()
    }
    
    func doResumeVideo() {
        avPlayer?.seekToTime(cmTime!, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        avPlayer?.play()
    }
    
    // MARK: Video Navigation
    internal func doChangeToFile(fileName: String, fileExtension: String) {
        avPlayer!.pause()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer!.currentItem)
        
        let resource = NSBundle.mainBundle().pathForResource(fileName, ofType: fileExtension)
        let urlPathOfVideo = NSURL(fileURLWithPath: resource!)
        avPlayer!.replaceCurrentItemWithPlayerItem(AVPlayerItem(URL: urlPathOfVideo))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer!.currentItem)
        
        avPlayer!.play()
        cmTime = kCMTimeZero
    }
    
    func changeRestaurant(name: String, source: String, fileName: String, fileExtension: String) {
        doChangeToFile(fileName, fileExtension: fileExtension)
        
        mNameLabel?.text = name
        mCreditLabel?.frame = CGRectMake(mCreditLabel!.frame.origin.x, mCreditLabel!.frame.origin.y, (self.frame.width - 2 * mCreditLabel!.frame.origin.x), (self.frame.height - mCreditLabel!.frame.origin.y))
        mCreditLabel?.text = "Credit: " + source
        mCreditLabel?.sizeToFit()
    }
}