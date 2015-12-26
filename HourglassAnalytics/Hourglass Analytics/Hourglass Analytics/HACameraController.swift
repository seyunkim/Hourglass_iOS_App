//
//  HACameraController.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HACameraController : UIViewController {
    var mSnapButton : UIButton?
    var mCircle : CAShapeLayer?
    var mFlashButton : UIButton?
    var mSwitchButton : UIButton?
    var mSnapButtonPressed = false
    
    var mCancelButton : UIButton?
    var mDownloadButton : UIButton?
    var mUploadButton : UIButton?
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        var frame = self.view.frame
        frame.size.height -= (HAConstants.navBarHeight + UIApplication.sharedApplication().statusBarFrame.size.height)
        
        mSnapButton = UIButton(type: UIButtonType.Custom)
        mSnapButton!.frame = CGRectMake((self.view.frame.width - 70.0) / 2.0, self.view.frame.height - 75.0, 70.0, 70.0)
        mSnapButton!.clipsToBounds = true
        mSnapButton!.layer.cornerRadius = mSnapButton!.frame.width / 2.0
        mSnapButton!.layer.borderColor = UIColor.whiteColor().CGColor
        mSnapButton!.layer.borderWidth = 2.0
        mSnapButton!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        mSnapButton!.layer.rasterizationScale = UIScreen.mainScreen().scale
        mSnapButton!.layer.shouldRasterize = true
        mSnapButton!.layer.anchorPoint = CGPointMake(CGFloat(0.5), CGFloat(0.5))
        mSnapButton!.addTarget(self, action: "snapButtonPressed:", forControlEvents: UIControlEvents.TouchDown)
        mSnapButton!.addTarget(self, action: "snapButtonReleased:", forControlEvents: UIControlEvents.TouchUpInside)
        mSnapButton!.addTarget(self, action: "snapButtonReleased:", forControlEvents: UIControlEvents.TouchUpOutside)
        self.view.addSubview(mSnapButton!)
        
        mFlashButton = UIButton(type: UIButtonType.System)
        mFlashButton!.frame = CGRectMake(self.view.frame.width / 2.0 - 18.0, 29.0, 36.0, 44.0)
        mFlashButton!.tintColor = UIColor.whiteColor()
        mFlashButton!.setImage(UIImage(named:"camera-flash"), forState: UIControlState.Normal)
        mFlashButton!.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mFlashButton!.addTarget(self, action: "flashButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(mFlashButton!)
        
        mSwitchButton = UIButton(type: UIButtonType.System)
        mSwitchButton!.frame = CGRectMake(self.view.frame.width - 64.0, 29.0, 49.0, 42.0)
        mSwitchButton!.tintColor = UIColor.whiteColor()
        mSwitchButton!.setImage(UIImage(named:"camera-switch"), forState: UIControlState.Normal)
        mSwitchButton!.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mSwitchButton!.addTarget(self, action: "switchButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(mSwitchButton!)
        
        mCancelButton = UIButton(type: UIButtonType.System)
        mCancelButton!.frame = CGRectMake(self.view.frame.width - 54.0, 29.0, 49.0, 49.0)
        mCancelButton!.tintColor = UIColor.whiteColor()
        mCancelButton!.setImage(UIImage(named:"cancel"), forState: UIControlState.Normal)
        mCancelButton!.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mCancelButton!.addTarget(self, action: "cancelButtonPressed:", forControlEvents:  UIControlEvents.TouchUpInside)
        mCancelButton!.hidden = true
        mCancelButton!.enabled = false
        self.view.addSubview(mCancelButton!)
        
        mDownloadButton = UIButton(type: UIButtonType.System)
        mDownloadButton!.frame = CGRectMake(self.view.frame.width - 54.0, self.view.frame.height - 54.0, 49.0, 49.0)
        mDownloadButton!.tintColor = UIColor.whiteColor()
        mDownloadButton!.setImage(UIImage(named:"Download"), forState: UIControlState.Normal)
        mDownloadButton!.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mDownloadButton!.addTarget(self, action: "downloadButtonPressed:", forControlEvents:  UIControlEvents.TouchUpInside)
        mDownloadButton!.hidden = true
        mDownloadButton!.enabled = false
        self.view.addSubview(mDownloadButton!)
        
        mUploadButton = UIButton(type: UIButtonType.System)
        mUploadButton!.frame = CGRectMake(5.0, 29.0, 49.0, 49.0)
        mUploadButton!.tintColor = UIColor.whiteColor()
        mUploadButton!.setImage(UIImage(named:"Upload"), forState: UIControlState.Normal)
        mUploadButton!.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mUploadButton!.addTarget(self, action: "uploadButtonPressed", forControlEvents:  UIControlEvents.TouchUpInside)
        mUploadButton!.hidden = true
        mUploadButton!.enabled = false
        self.view.addSubview(mUploadButton!)
    }
    
    // MARK:Camera Controls
    func snapButtonPressed(button : UIButton) {
        mSnapButtonPressed = true
        
    }
    
    func snapButtonReleased(button : UIButton) {
        if mSnapButtonPressed {
            mSnapButtonPressed = false
            
            self.mCancelButton!.alpha = 0.0
            self.mCancelButton!.hidden = false
            self.mDownloadButton!.alpha = 0.0
            self.mDownloadButton!.hidden = false
            self.mUploadButton!.alpha = 0.0
            self.mUploadButton!.hidden = false
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.mSnapButton!.alpha = 0.0
                self.mFlashButton!.alpha = 0.0
                self.mSwitchButton?.alpha = 0.0
                
                self.mCancelButton!.alpha = 1.0
                self.mDownloadButton!.alpha = 1.0
                self.mUploadButton!.alpha = 1.0
                }, completion: { (completed) -> Void in
                    self.mSnapButton!.enabled = false
                    self.mFlashButton!.enabled = false
                    self.mSwitchButton?.enabled = false
                    self.mCancelButton!.enabled = true
                    self.mDownloadButton!.enabled = true
                    self.mUploadButton!.enabled = true
                    
            })
        }
    }
    
    func timeOut() {
        snapButtonReleased(mSnapButton!)
    }
    
    func flashButtonPressed(button : UIButton) {
        
    }
    
    func switchButtonPressed(button : UIButton) {
        
    }
    
    func cancelButtonPressed(button : UIButton) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mCancelButton?.alpha = 0.0
            self.mSnapButton?.alpha = 1.0
            self.mFlashButton?.alpha = 1.0
            self.mSwitchButton?.alpha = 1.0
            self.mDownloadButton?.alpha = 0.0
            self.mUploadButton?.alpha = 0.0
            }) { (finished) -> Void in
                self.mCancelButton?.enabled = false
                self.mSnapButton?.enabled = true
                self.mFlashButton?.enabled = true
                self.mSwitchButton?.enabled = true
                self.mDownloadButton?.enabled = false
                self.mUploadButton?.enabled = false
        }
    }
    
    func downloadButtonPressed(button : UIButton) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mDownloadButton?.hidden = true
            }, completion: { (finished) -> Void in
                self.mDownloadButton?.enabled = false
        })
    }
    
    func uploadButtonPressed() {
        
    }
    
    // MARK:Animation Helper Methods
    func drawCircle() {
        let radius = CGFloat(45.0)
        
        // Create the circle layer
        mCircle = CAShapeLayer()
        
        // Set the center of the circle to be the center of the view
        let center = CGPointMake(self.mSnapButton!.frame.size.width/2.0, self.mSnapButton!.frame.size.height/2.0)
        
        let fractionOfCircle = 1.0
        
        let twoPi = 2.0 * Double(M_PI)
        // The starting angle is given by the fraction of the circle that the point is at, divided by 2 * Pi and less
        // We subtract M_PI_2 to rotate the circle 90 degrees to make it more intuitive (i.e. like a clock face with zero at the top, 1/4 at RHS, 1/2 at bottom, etc.)
        let startAngle = Double(fractionOfCircle) / Double(twoPi) - Double(M_PI_2)
        let endAngle = 0.0 - Double(M_PI_2)
        let clockwise: Bool = true
        
        // `clockwise` tells the circle whether to animate in a clockwise or anti clockwise direction
        mCircle!.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).CGPath
        
        // Configure the circle
        mCircle!.fillColor = UIColor.clearColor().CGColor
        mCircle!.strokeColor = UIColor.redColor().CGColor
        mCircle!.lineWidth = 4
        
        // When it gets to the end of its animation, leave it at 0% stroke filled
        mCircle!.strokeEnd = 0.0
        
        // Add the circle to the parent layer
        self.mSnapButton!.layer.addSublayer(mCircle!)
        
        // Configure the animation
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.repeatCount = 1.0
        
        // Animate from the full stroke being drawn to none of the stroke being drawn
        drawAnimation.fromValue = NSNumber(double: 0.0)
        drawAnimation.toValue = NSNumber(double: fractionOfCircle)
        
        drawAnimation.duration = 15.0
        
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Add the animation to the circle
        mCircle!.addAnimation(drawAnimation, forKey: "drawCircleAnimation")
    }
    
    func stopCircle() {
        let pausedTime = mCircle!.convertTime(CACurrentMediaTime(), fromLayer: nil)
        mCircle!.speed = 0.0
        mCircle!.timeOffset = pausedTime
    }
    
    func removeCircle() {
        mCircle!.removeFromSuperlayer()
    }
    
    func reloadCamera() {
        self.mSnapButton!.frame = CGRectMake((self.view.frame.width - 70.0) / 2.0, self.view.frame.height - 75.0, 70.0, 70.0)
    }
    
    // MARK: Analytics functions
    func reloadButtons() {
        // SNAP
        if HAConstants.buttonTapDictionary.objectForKey("CaptureVideo") != nil {
            let snapPercentage = (HAConstants.buttonTapDictionary.objectForKey("CaptureVideo") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mSnapButton?.backgroundColor = HAConstants.colorForPercentage(snapPercentage)
        }
        
        // FLASH
        if HAConstants.buttonTapDictionary.objectForKey("ToggleFlash") != nil {
            let flashPercentage = (HAConstants.buttonTapDictionary.objectForKey("ToggleFlash") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mFlashButton?.tintColor = HAConstants.colorForPercentage(flashPercentage)
        }
        
        // SWITCH
        if HAConstants.buttonTapDictionary.objectForKey("ToggleCamera") != nil {
            let switchPercentage = (HAConstants.buttonTapDictionary.objectForKey("ToggleCamera") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mSwitchButton?.tintColor = HAConstants.colorForPercentage(switchPercentage)
        }
        
        // DOWNLOAD
        if HAConstants.buttonTapDictionary.objectForKey("DownloadVideo") != nil {
            let downloadPercentage = (HAConstants.buttonTapDictionary.objectForKey("DownloadVideo") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mDownloadButton?.tintColor = HAConstants.colorForPercentage(downloadPercentage)
        }
        
        // UPLOAD
        if HAConstants.buttonTapDictionary.objectForKey("UploadVideo") != nil {
            let uploadPercentage = (HAConstants.buttonTapDictionary.objectForKey("UploadVideo") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mUploadButton?.tintColor = HAConstants.colorForPercentage(uploadPercentage)
        }
        
        // CANCEL
        if HAConstants.buttonTapDictionary.objectForKey("CancelVideo") != nil {
            let cancelPercentage = (HAConstants.buttonTapDictionary.objectForKey("CancelVideo") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mCancelButton?.tintColor = HAConstants.colorForPercentage(cancelPercentage)
        }
    }
    
    func reloadScreenBackgrounds() {
        if HAConstants.screenLoadDictionary.objectForKey("CameraViewController") != nil {
            let percentage = (HAConstants.screenLoadDictionary.objectForKey("CameraViewController") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxScreenLoads).doubleValue * 1.0)
            view.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
    }
    
    func reloadTaps() {
        var frame = view.frame
        frame.origin.y = 0
        frame.origin.x = 0
        let heatMapView = HAHeatmapView(frame: frame)
        heatMapView.drawHeatMap("CameraViewController")
        view.addSubview(heatMapView)
    }
}
