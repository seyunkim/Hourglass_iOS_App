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

class CameraController : AnalyticsViewController {
    var camera : LLSimpleCamera?
    
    var mVideoNumber = 0
    var mSnapButton : UIButton?
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        mVideoNumber = defaults.integerForKey("hourglassVideoNumber")
        
        var frame = self.view.frame
        if (frame.origin.y == 0) {
            frame.size.height -= (64 + UIApplication.sharedApplication().statusBarFrame.size.height)
        } else {
            frame.origin.y = 0
        }
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
        
    }
    
    func startCamera() {
        camera?.start()
    }
    
    func stopCamera() {
        camera?.stop()
    }
    
    // Camera Controls
    func snapButtonPressed(button : UIButton) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mSnapButton!.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            }, completion: { (finished) -> Void in
                // Finished Code
                let outputURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last?.URLByAppendingPathComponent("HourglassVideo_\(self.mVideoNumber)").URLByAppendingPathExtension("mov")
                self.camera?.startRecordingWithOutputUrl(outputURL)
                
                self.mVideoNumber++
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(self.mVideoNumber, forKey: "hourglassVideoNumber")
        })
    }
    
    func snapButtonReleased(button : UIButton) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mSnapButton!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            }, completion: { (finished) -> Void in
                // Finished Code
                self.camera?.stopRecording({ (cam : LLSimpleCamera!, url : NSURL!, error : NSError!) -> Void in
                    // Callback
                    if error != nil {
                        print(error)
                    } else {
                        ALAssetsLibrary().writeVideoAtPathToSavedPhotosAlbum(url, completionBlock: {
                            (assetURL:NSURL!, internalError:NSError!) in
                            if internalError != nil {
                                print(internalError)
                            } else {
                                //self.resetButtons()
                            }
                        })
                    }
                })
        })
    }
}
