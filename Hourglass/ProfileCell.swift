//
//  ProfileCell.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/21/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

class ProfileCell : UITableViewCell {
    var mIcon : UIImageView?
    var mBadge : UILabel?
    var mTitle : UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        internalInitialization()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        internalInitialization()
    }
    
    internal func internalInitialization() {
        mIcon = UIImageView(frame: CGRectMake(5.0, 5.0, 44.0 - 10.0, 44.0 - 10.0))
        mIcon!.image = UIImage(named: "Friends")
        addSubview(mIcon!)
        
        mBadge = UILabel(frame: CGRectMake(mIcon!.frame.origin.x + mIcon!.frame.width + 3.0, 10.0, 44.0 - 10.0, 44.0 - 20.0))
        mBadge!.backgroundColor = UIColor.blackColor()
        mBadge!.textColor = UIColor.whiteColor()
        mBadge!.text = "0"
        mBadge!.textAlignment = .Center
        mBadge!.adjustsFontSizeToFitWidth = true
        mBadge!.layer.cornerRadius = mBadge!.frame.width / 2.75
        mBadge!.layer.masksToBounds = true
        addSubview(mBadge!)
        
        mTitle = UILabel(frame: CGRectMake(mBadge!.frame.origin.x + mBadge!.frame.width + 15.0, 0.0, frame.width - (mBadge!.frame.origin.x + mBadge!.frame.width + 10.0) - 10.0, 44.0))
        mTitle!.text = "Title"
        mTitle!.textColor = UIColor.blackColor()
        mTitle!.adjustsFontSizeToFitWidth = true // May need to remove
        addSubview(mTitle!)
    }
}