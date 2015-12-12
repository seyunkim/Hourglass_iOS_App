//
//  AnalyticsUIButton.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/11/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

class AnalyticsUIButton : UIButton {
    var mAnalyticsButtonIdentifier : String = "Unknown"
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            if let touchEvent = touch as? UITouch {
                var touchLocation = touchEvent.locationInView(self)
                var myFrame = self.frame
                myFrame.origin.x = 0
                myFrame.origin.y = 0
                if CGRectContainsPoint(myFrame, touchLocation) {
                    // We ended our touch in the frame, so we should log the event
                    AnalyticsController.logButtonPress(mAnalyticsButtonIdentifier)
                }
            }
        }
        
        super.touchesEnded(touches, withEvent: event)
    }
}