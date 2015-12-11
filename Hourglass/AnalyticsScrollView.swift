//
//  AnalyticsScrollView.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/11/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

protocol AnalyticsScrollViewDelegate {
    func didDragYBy(amountDragged : Int)
}

class AnalyticsScrollView : UIScrollView, UIScrollViewDelegate {
    var mAnalyticsDelegate : AnalyticsScrollViewDelegate!
    var mAnalyticsDelegateSet = false
    var mAnalyticsLastContentOffsetY : Int = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    func setAnalyticsDelegate(del : AnalyticsScrollViewDelegate) {
        mAnalyticsDelegate = del
        mAnalyticsDelegateSet = true
    }
    
    func scrollViewDidScroll(scrollView : UIScrollView) {
        if (!mAnalyticsDelegateSet && AnalyticsController.hasTopViewController()) {
            setAnalyticsDelegate(AnalyticsController.getTopViewController()!)
        }
        
        if (mAnalyticsDelegateSet) {
            mAnalyticsDelegate.didDragYBy(Int(scrollView.contentOffset.y) - mAnalyticsLastContentOffsetY)
            mAnalyticsLastContentOffsetY = Int(scrollView.contentOffset.y)
        }
    }
}