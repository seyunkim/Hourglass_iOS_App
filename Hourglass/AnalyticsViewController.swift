//
//  AnalyticsViewController.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/10/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

// New base class for view controllers to create tap gesture recognizers and record all taps on the view controller
class AnalyticsViewController : UIViewController, AnalyticsScrollViewDelegate {
    // This records the name of the screen which is necessary for identifying taps
    var screenName : String = "UnidentifiedScreen"
    // Our tap gesture recognizer that covers the entirety of the view
    let tapRec = UITapGestureRecognizer();
    // Modifier to record how far the screen has been dragged
    var yDrag : Int = 0
    
    // Initialize our gesture recognizers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapRec.addTarget(self, action: "tappedView:")
        self.view.addGestureRecognizer(tapRec)
        self.view.userInteractionEnabled = true
    }
    
    // Handle Taps
    func tappedView(tgr : UITapGestureRecognizer){
        let touchPoint : CGPoint = tgr.locationInView(self.view)
        AnalyticsController.logTapEvent(screenName, xPos: Int(touchPoint.x), yPos: yDrag + Int(touchPoint.y))
    }
    
    // Handle Pans
    func didDragYBy(amountDragged: Int) {
        yDrag += amountDragged
    }
    
    // Resister as top View Controller and record returning to top view controller, also log the event of appearing
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsController.logScreenLoad(screenName)
        AnalyticsController.registerTopViewController(self)
    }
}