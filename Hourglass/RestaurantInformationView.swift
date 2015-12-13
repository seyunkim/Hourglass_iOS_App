//
//  RestaurantInformationView.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/12/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

class RestaurantInformationView : UIView {
    // MARK: Private Variables
    var mRestaurantName = "Restaurant Name"
    var mRestaurantPriceRating = 2.5
    var mRestaurantPhoneNumber = "972-867-5309"
    var mRestaurantAddress = "1 Market St.\nSan Francisco, CA"
    var mRestaurantCategory = "Steakhouse"
    
    var mNameLabel : UILabel?
    var mPhoneLabel : UILabel?
    var mAddressLabel : UILabel?
    var mCategoryLabel : UILabel?
    
    // MARK: Initialization Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationImplementation()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initializationImplementation()
    }
    
    func initializationImplementation() {
        self.backgroundColor = UIColor(red: CGFloat(245/255.0), green: CGFloat(245/255.0), blue: CGFloat(220/255.0), alpha: CGFloat(1.0))
        
        let horizontalOffset = self.frame.width / 6.0
        let verticalPadding = CGFloat(16)
        
        // Name Label
        mNameLabel = UILabel(frame: CGRectMake(
            CGFloat(0),
            CGFloat(32),
            self.frame.width,
            CGFloat(64)))
        mNameLabel!.backgroundColor = UIColor.clearColor()
        mNameLabel!.textColor = UIColor.blackColor()
        mNameLabel!.textAlignment = NSTextAlignment.Center
        mNameLabel!.font = UIFont.systemFontOfSize(36)
        mNameLabel!.text = mRestaurantName
        self.addSubview(mNameLabel!)
        
        // Category
        mCategoryLabel = UILabel(frame: CGRectMake(
            self.frame.width / 5.0,
            mNameLabel!.frame.origin.y + mNameLabel!.frame.height,
            self.frame.width * CGFloat(3) / 5.0,
            CGFloat(32)))
        mCategoryLabel!.backgroundColor = UIColor.clearColor()
        mCategoryLabel!.textColor = UIColor.darkGrayColor()
        mCategoryLabel!.font = UIFont.systemFontOfSize(24)
        mCategoryLabel!.text = mRestaurantCategory
        mCategoryLabel!.sizeToFit()
        self.addSubview(mCategoryLabel!)
        
        // Rating
        let ratingLabel = UILabel(frame: CGRectMake(
            horizontalOffset,
            mCategoryLabel!.frame.origin.y + mCategoryLabel!.frame.height + verticalPadding,
            self.frame.width - (2 * horizontalOffset),
            self.frame.height * 3 / 4.0))
        ratingLabel.backgroundColor = UIColor.clearColor()
        ratingLabel.textColor = UIColor.blackColor()
        ratingLabel.font = UIFont.systemFontOfSize(20)
        ratingLabel.text = "Price Rating: " + String(mRestaurantPriceRating)
        ratingLabel.sizeToFit()
        self.addSubview(ratingLabel)
        
        // Phone
        mPhoneLabel = UILabel(frame: CGRectMake(
            horizontalOffset,
            ratingLabel.frame.origin.y + ratingLabel.frame.height + verticalPadding,
            self.frame.width - (2 * horizontalOffset),
            ratingLabel.frame.height))
        mPhoneLabel!.backgroundColor = UIColor.clearColor()
        mPhoneLabel!.textColor = UIColor.blackColor()
        mPhoneLabel!.font = UIFont.systemFontOfSize(20)
        mPhoneLabel!.text = mRestaurantPhoneNumber
        self.addSubview(mPhoneLabel!)
        
        // Map -- PLACEHOLDER
        let sampleMapView = UIImageView(frame: CGRectMake(
            horizontalOffset,
            self.frame.height / 2.0,
            self.frame.width - (2 * horizontalOffset),
            self.frame.height / 4.0))
        sampleMapView.image = UIImage(named: "SampleHiRez")
        self.addSubview(sampleMapView)
        
        // Address
        mAddressLabel = UILabel(frame: CGRectMake(
            horizontalOffset,
            sampleMapView.frame.origin.y + sampleMapView.frame.height + verticalPadding,
            self.frame.width - (2 * horizontalOffset),
            self.frame.height - (sampleMapView.frame.origin.y + sampleMapView.frame.height) - verticalPadding))
        mAddressLabel!.backgroundColor = UIColor.clearColor()
        mAddressLabel!.textColor = UIColor.blackColor()
        mAddressLabel!.font = UIFont.systemFontOfSize(18)
        mAddressLabel!.text = mRestaurantAddress
        mAddressLabel!.numberOfLines = 0
        mAddressLabel!.sizeToFit()
        self.addSubview(mAddressLabel!)
    }
}
