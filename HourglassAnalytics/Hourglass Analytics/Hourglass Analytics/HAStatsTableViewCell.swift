//
//  HAStatsTableViewCell.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/27/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HAStatsTableViewCell : UITableViewCell {
    var mTitle : UILabel?
    var mCount : UILabel?
    var mPercent : UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        internalInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        internalInitialization()
    }
    
    internal func internalInitialization() {
        mTitle = UILabel(frame: CGRectMake(5.0, 0.0, frame.width/2.0 - 7.5, 44.0))
        mTitle!.text = "Title"
        mTitle!.textColor = UIColor.blackColor()
        mTitle!.adjustsFontSizeToFitWidth = true // May need to remove
        addSubview(mTitle!)
        
        mCount = UILabel(frame: CGRectMake(frame.width/2.0 + 2.5, 0.0, frame.width/4.0 - 5.0, 44.0))
        mCount!.text = "Count"
        mCount!.textColor = UIColor.blackColor()
        mCount!.adjustsFontSizeToFitWidth = true
        addSubview(mCount!)
        
        mPercent = UILabel(frame: CGRectMake(frame.width*3.0/4.0 + 2.5, 0.0, frame.width/4.0 - 7.5, 44.0))
        mPercent!.text = "Percent"
        mPercent!.textColor = UIColor.blackColor()
        mPercent!.adjustsFontSizeToFitWidth = true
        addSubview(mPercent!)
    }
}
