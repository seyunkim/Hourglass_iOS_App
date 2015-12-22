//
//  CameraController.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/18/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation

class CameraController : AnalyticsViewController {
    var camera : LLSimpleCamera?
    
    var mVideoNumber = 0
    var mSnapButton : UIButton?
    var mCircle : CAShapeLayer?
    var mFlashButton : UIButton?
    var mSwitchButton : UIButton?
    
    var mAVPlayer : AVPlayer?
    var mAVPlayerLayer : AVPlayerLayer?
    var mURL : NSURL?
    var mTime : CMTime?
    var mCancelButton : UIButton?
    var mDownloadButton : UIButton?
    
    var mSpinnerView : RTSpinKitView?
    
    override func viewDidLoad() {
        showSpinner()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        mVideoNumber = defaults.integerForKey("hourglassVideoNumber")
        
        var frame = self.view.frame
        frame.size.height -= (HourglassConstants.navBarHeight + UIApplication.sharedApplication().statusBarFrame.size.height)

        camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
        camera?.attachToViewController(self, withFrame: frame)
        // Play with this if we want videos to rotate at all
        camera?.fixOrientationAfterCapture = false
        
        mSnapButton = UIButton(type: UIButtonType.Custom)
        mSnapButton!.frame = CGRectMake((self.view.frame.width - 70.0) / 2.0, self.view.frame.height - 75.0, 70.0, 70.0)
        mSnapButton!.clipsToBounds = true
        mSnapButton!.layer.cornerRadius = mSnapButton!.frame.width / 2.0
        mSnapButton!.layer.borderColor = UIColor.whiteColor().CGColor
        mSnapButton!.layer.borderWidth = 2.0
        mSnapButton!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        mSnapButton!.layer.rasterizationScale = UIScreen.mainScreen().scale
        mSnapButton!.layer.shouldRasterize = true
        mSnapButton!.addTarget(self, action: "snapButtonPressed:", forControlEvents: UIControlEvents.TouchDown)
        mSnapButton!.addTarget(self, action: "snapButtonReleased:", forControlEvents: UIControlEvents.TouchUpInside)
        mSnapButton!.addTarget(self, action: "snapButtonReleased:", forControlEvents: UIControlEvents.TouchUpOutside)
        self.view.addSubview(mSnapButton!)
        self.view.bringSubviewToFront(mSpinnerView!)
        
        mFlashButton = UIButton(type: UIButtonType.System)
        mFlashButton!.frame = CGRectMake(self.view.frame.width / 2.0 - 18.0, 5.0, 36.0, 44.0)
        mFlashButton!.tintColor = UIColor.whiteColor()
        mFlashButton!.setImage(UIImage(named:"camera-flash"), forState: UIControlState.Normal)
        mFlashButton!.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mFlashButton!.addTarget(self, action: "flashButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(mFlashButton!)
        self.view.bringSubviewToFront(mSpinnerView!)
        
        if LLSimpleCamera.isFrontCameraAvailable() && LLSimpleCamera.isRearCameraAvailable() {
            mSwitchButton = UIButton(type: UIButtonType.System)
            mSwitchButton!.frame = CGRectMake(self.view.frame.width - 64.0, 5.0, 49.0, 42.0)
            mSwitchButton!.tintColor = UIColor.whiteColor()
            mSwitchButton!.setImage(UIImage(named:"camera-switch"), forState: UIControlState.Normal)
            mSwitchButton!.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            mSwitchButton!.addTarget(self, action: "switchButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(mSwitchButton!)
            self.view.bringSubviewToFront(mSpinnerView!)
        }
        
        // AVPlayer for video playback
        mAVPlayer = AVPlayer()
        mAVPlayer!.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        mAVPlayerLayer = AVPlayerLayer(player: mAVPlayer!)
        mAVPlayerLayer!.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        mAVPlayerLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        mAVPlayerLayer!.hidden = true
        mTime = kCMTimeZero
        self.view.layer.addSublayer(mAVPlayerLayer!)
        self.view.bringSubviewToFront(mSpinnerView!)
        
        mCancelButton = UIButton(type: UIButtonType.System)
        mCancelButton!.frame = CGRectMake(self.view.frame.width - 54.0, 5.0, 49.0, 49.0)
        mCancelButton!.tintColor = UIColor.whiteColor()
        mCancelButton!.setImage(UIImage(named:"cancel"), forState: UIControlState.Normal)
        mCancelButton!.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mCancelButton!.addTarget(self, action: "cancelButtonPressed:", forControlEvents:  UIControlEvents.TouchUpInside)
        mCancelButton!.hidden = true
        mCancelButton!.enabled = false
        self.view.addSubview(mCancelButton!)
        self.view.bringSubviewToFront(mSpinnerView!)
        
        mDownloadButton = UIButton(type: UIButtonType.System)
        mDownloadButton!.frame = CGRectMake(self.view.frame.width - 54.0, self.view.frame.height - 54.0, 49.0, 49.0)
        mDownloadButton!.tintColor = UIColor.whiteColor()
        mDownloadButton!.setImage(UIImage(named:"Download"), forState: UIControlState.Normal)
        mDownloadButton!.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mDownloadButton!.addTarget(self, action: "downloadButtonPressed:", forControlEvents:  UIControlEvents.TouchUpInside)
        mDownloadButton!.hidden = true
        mDownloadButton!.enabled = false
        self.view.addSubview(mDownloadButton!)
        self.view.bringSubviewToFront(mSpinnerView!)
        
        hideSpinner()
    }
    
    func startCamera() {
        camera?.start()
    }
    
    func stopCamera() {
        camera?.stop()
    }
    
    // MARK:Camera Controls
    func snapButtonPressed(button : UIButton) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mSnapButton!.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            self.mSnapButton!.layer.borderColor = UIColor.clearColor().colorWithAlphaComponent(0.5).CGColor
            self.mSnapButton!.frame = CGRectMake((self.view.frame.width - 90.0) / 2.0, self.view.frame.height - 95.0, 90.0, 90.0)
            self.mSnapButton!.layer.cornerRadius = self.mSnapButton!.frame.width / 2.0
            }, completion: { (finished) -> Void in
                // Finished Code
                let outputURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last?.URLByAppendingPathComponent("HourglassVideo_\(self.mVideoNumber)").URLByAppendingPathExtension("mov")
                self.camera?.startRecordingWithOutputUrl(outputURL)
                
                self.mVideoNumber++
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(self.mVideoNumber, forKey: "hourglassVideoNumber")
                defaults.synchronize()
                
                self.drawCircle()
        })
    }
    
    func snapButtonReleased(button : UIButton) {
        self.stopCircle()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mSnapButton!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            //self.mSnapButton!.layer.borderColor = UIColor.whiteColor().CGColor
            }, completion: { (finished) -> Void in
                // Finished Code
                if self.camera!.recording {
                    self.camera?.stopRecording({ (cam : LLSimpleCamera!, url : NSURL!, error : NSError!) -> Void in
                        // Callback
                        if error != nil {
                            print(error)
                        } else {
                            self.removeCircle()
                            // Prepare playback layer
                            self.mURL = url
                            self.mAVPlayer!.replaceCurrentItemWithPlayerItem(AVPlayerItem(URL: url))
                            NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.mAVPlayer!.currentItem)
                            
                            self.camera?.stop()
                            self.mAVPlayer!.play()
                            
                            UIView.animateWithDuration(0.25, animations: { () -> Void in
                                self.mAVPlayerLayer!.hidden = false
                                
                                self.mSnapButton!.hidden = true
                                self.mFlashButton!.hidden = true
                                self.mSwitchButton?.hidden = true
                                self.mCancelButton!.hidden = false
                                self.mDownloadButton!.hidden = false
                                self.mSnapButton!.frame = CGRectMake((self.view.frame.width - 70.0) / 2.0, self.view.frame.height - 75.0, 70.0, 70.0)
                                self.mSnapButton!.layer.cornerRadius = self.mSnapButton!.frame.width / 2.0
                                }, completion: { (completed) -> Void in
                                    self.mSnapButton!.enabled = false
                                    self.mFlashButton!.enabled = false
                                    self.mSwitchButton?.enabled = false
                                    self.mCancelButton!.enabled = true
                                    self.mDownloadButton!.enabled = true
                                    
                            })
                        }
                    })
                }
        })
    }
    
    func flashButtonPressed(button : UIButton) {
        if self.camera!.flash == LLCameraFlashOff {
            let done = self.camera!.updateFlashMode(LLCameraFlashOn)
            if done {
                mFlashButton!.selected = true
                mFlashButton!.tintColor = UIColor.yellowColor()
            }
        }
        else {
            let done = self.camera!.updateFlashMode(LLCameraFlashOff)
            if done {
                mFlashButton!.selected = false
                mFlashButton!.tintColor = UIColor.whiteColor()
            }
        }
    }
    
    func switchButtonPressed(button : UIButton) {
        camera?.togglePosition()
    }
    
    func cancelButtonPressed(button : UIButton) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mCancelButton?.hidden = true
            self.mSnapButton?.hidden = false
            self.mFlashButton?.hidden = false
            self.mSwitchButton?.hidden = false
            self.mDownloadButton?.hidden = true
            
            self.mAVPlayerLayer!.hidden = true
            }) { (finished) -> Void in
                self.mCancelButton?.enabled = false
                self.mSnapButton?.enabled = true
                self.mFlashButton?.enabled = true
                self.mSwitchButton?.enabled = true
                self.mDownloadButton?.enabled = false
                
                self.mAVPlayer!.pause()
                self.camera!.start()
        }
    }
    
    func downloadButtonPressed(button : UIButton) {
        showSpinner()
        
        ALAssetsLibrary().writeVideoAtPathToSavedPhotosAlbum(self.mURL!, completionBlock: {
            (assetURL:NSURL!, internalError:NSError!) in
            if internalError != nil {
                print(internalError)
            } else {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.mDownloadButton?.hidden = true
                    }, completion: { (finished) -> Void in
                        self.mDownloadButton?.enabled = false
                        self.hideSpinner()
                })
            }
        })
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
        
        drawAnimation.duration = 7.0
        
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
    
    func showSpinner() {
        mSpinnerView = RTSpinKitView(style: RTSpinKitViewStyle.StyleWave)
        mSpinnerView!.spinnerSize = 70.0
        mSpinnerView!.color = HourglassConstants.logoColor.colorWithAlphaComponent(0.8)
        mSpinnerView!.frame = self.view.frame
        mSpinnerView!.sizeToFit()
        mSpinnerView!.center = CGPointMake(self.view.frame.width / 2.0, self.view.frame.height * 2.0 / 5.0)
        view.addSubview(mSpinnerView!)
    }
    
    func hideSpinner() {
        mSpinnerView!.removeFromSuperview()
    }
    
    // MARK: Video Callback
    func playerItemDidReachEnd(notification : NSNotification) {
        if let item = notification.object as! AVPlayerItem! {
            item.seekToTime(kCMTimeZero)
        }
    }
}
