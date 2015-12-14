//
//  AnalyticsScrollView.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/11/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

// This delegate definition will allow our AnalyticsViewController to handle the distance scrolled
protocol AnalyticsScrollViewDelegate {
    func didDragYBy(amountDragged : Int)
}

class AnalyticsScrollView : UIScrollView, UIScrollViewDelegate {
    // Private variables needed to handle sending scrolls to a delegate if one exists
    var mAnalyticsDelegate : AnalyticsScrollViewDelegate!
    var mAnalyticsDelegateSet = false
    var mAnalyticsLastContentOffsetY : Int = 0
    
    // Unfortunately, we have to set ourselves as our own delegate in order to get the scrolling and send to our internal delegate
    // This is something we may need to alter in the future
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationImplementation()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initializationImplementation()
    }
    
    internal func initializationImplementation() {
        self.delegate = self
    }
    
    // Internal function used to set our analytics delegate - can be called externally if the user wishes to send the scrolling to a view controller that is not on top
    func setAnalyticsDelegate(del : AnalyticsScrollViewDelegate) {
        mAnalyticsDelegate = del
        mAnalyticsDelegateSet = true
    }
    
    // Delegate function to receive the scrolling and pass it on to the delegate
    func scrollViewDidScroll(scrollView : UIScrollView) {
        // If we don't currently have a delegate but one exists in the Singleton Analytics Controller, then set it here first
        // This takes care of automatically setting the delegate for us so that we don't have to call it externally
        if (!mAnalyticsDelegateSet && AnalyticsController.hasTopViewController()) {
            setAnalyticsDelegate(AnalyticsController.getTopViewController()!)
        }
        
        // Actually pass on the scroll distance to our delegate
        if (mAnalyticsDelegateSet) {
            mAnalyticsDelegate.didDragYBy(Int(scrollView.contentOffset.y) - mAnalyticsLastContentOffsetY)
            mAnalyticsLastContentOffsetY = Int(scrollView.contentOffset.y)
        }
    }
    
    // Function to allow gesture recognizers to work simultaneously with scrolling
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}