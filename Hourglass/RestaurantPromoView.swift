//
//  RestaurantPromoView.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/12/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

class RestaurantPromoView : UIView {
    // MARK: Private Variables
    var mRestaurantLogo = "SampleRestaurantLogo"
    var mRestaurantName = "Restaurant Name"
    var mHiRezBackground = "SampleHiRez"
    var mRestaurantInformation = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc sit amet dignissim sapien, et malesuada tortor. Fusce congue lorem eu tortor elementum, eget rhoncus quam pellentesque. Donec quis viverra augue. Cras sem urna, fringilla iaculis facilisis id, molestie vel est. Duis euismod suscipit ex quis hendrerit. Donec vitae magna magna. Nullam iaculis ultricies tincidunt. Nullam tincidunt hendrerit commodo."
    
    var mRestaurantLogoView : UIImageView?
    var mHiRezBackgroundView : UIImageView?
    var mNameLabel : UILabel?
    var mInfoLabel : UILabel?
    
    // MARK: Initialization Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationImplementation()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initializationImplementation()
    }
    
    required init(frame: CGRect, name: String, information: String, background: String, logo: String) {
        super.init(frame: frame)
        mRestaurantName = name
        mRestaurantInformation = information
        mHiRezBackground = background
        mRestaurantLogo = logo
        initializationImplementation()
    }
    
    func initializationImplementation() {
        // First load in the High Resolution Background
        let mHiRezBackgroundImage = UIImage(named: mHiRezBackground)
        var hiRezFrame = self.frame
        hiRezFrame.origin.y = 0
        hiRezFrame.origin.x = 0
        mHiRezBackgroundView = UIImageView(frame: hiRezFrame)
        mHiRezBackgroundView!.image = mHiRezBackgroundImage
        self.addSubview(mHiRezBackgroundView!)
        let darkenView = UIView(frame: mHiRezBackgroundView!.frame)
        darkenView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.addSubview(darkenView)
        
        // Set up ratio constants
        let percentForLogo = CGFloat(1.0/4)
        let verticalOffset = CGFloat(64)
        
        // Then Load in the Restaurant Logo
        let logoWidth = CGFloat(64)
        let restaurantLogo = UIImage(named: mRestaurantLogo)
        mRestaurantLogoView = UIImageView(frame: CGRectMake(
            (self.frame.width * percentForLogo - logoWidth) / 2,
            verticalOffset,
            logoWidth,
            logoWidth))
        mRestaurantLogoView!.image = restaurantLogo
        self.addSubview(mRestaurantLogoView!)
        
        // Add the Restaurant Name and Description Labels
        mNameLabel = UILabel(frame: CGRectMake(
            (self.frame.width * percentForLogo),
            verticalOffset,
            self.frame.width * (CGFloat(1) - percentForLogo),
            logoWidth))
        mNameLabel!.backgroundColor = UIColor.clearColor()
        mNameLabel!.textColor = UIColor.whiteColor()
        mNameLabel!.font = UIFont.systemFontOfSize(36)
        mNameLabel!.text = mRestaurantName
        mNameLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mNameLabel!)
        
        mInfoLabel = UILabel(frame: CGRectMake(
            (self.frame.width * percentForLogo / 1.5),
            verticalOffset + mNameLabel!.frame.height,
            self.frame.width - (self.frame.width * percentForLogo / 1.5) - CGFloat(18),
            self.frame.height - (verticalOffset + mNameLabel!.frame.height)))
        mInfoLabel!.backgroundColor = UIColor.clearColor()
        mInfoLabel!.textColor = UIColor.whiteColor()
        mInfoLabel!.font = UIFont.italicSystemFontOfSize(24)
        mInfoLabel!.text = mRestaurantInformation
        mInfoLabel!.numberOfLines = 0
        self.addSubview(mInfoLabel!)
    }
    
    func changeRestaurant(name: String, information: String, background: String, logo: String) {
        mRestaurantName = name
        mRestaurantInformation = information
        mHiRezBackground = background
        mRestaurantLogo = logo
        
        
        mNameLabel?.text = mRestaurantName
        mInfoLabel?.text = mRestaurantInformation
        let restaurantLogo = UIImage(named: mRestaurantLogo)
        mRestaurantLogoView?.image = restaurantLogo
        let mHiRezBackgroundImage = UIImage(named: mHiRezBackground)
        mHiRezBackgroundView!.image = mHiRezBackgroundImage
    }
}
