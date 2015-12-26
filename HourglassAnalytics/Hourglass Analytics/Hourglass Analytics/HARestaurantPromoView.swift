//
//  HARestaurantPromoView.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HARestaurantPromoView : UIView {
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
        backgroundColor = UIColor.clearColor()
        
        // Set up ratio constants
        let percentForLogo = CGFloat(1.0/3)
        let verticalOffset = CGFloat(64)
        
        // Then Load in the Restaurant Logo
        let logoWidth = CGFloat(86)
        mRestaurantLogoView = UIImageView(frame: CGRectMake(
            (self.frame.width * percentForLogo - logoWidth) / 2,
            verticalOffset,
            logoWidth,
            logoWidth))
        if mRestaurantLogo == "blank" {
            mRestaurantLogoView?.image = UIImage()
        } else {
            let restaurantLogo = UIImage(named: mRestaurantLogo)
            mRestaurantLogoView!.image = restaurantLogo
        }
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
        mNameLabel!.font = UIFont(name: "Montserrat-Regular", size: 36.0)
        mNameLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mNameLabel!)
        
        mInfoLabel = UILabel(frame: CGRectMake(
            (self.frame.width * percentForLogo / 1.5),
            verticalOffset + mNameLabel!.frame.height,
            self.frame.width - (self.frame.width * percentForLogo / 1.5) - CGFloat(18),
            self.frame.height - (verticalOffset + mNameLabel!.frame.height)))
        //mInfoLabel?.center = CGPoint(x:self.frame.width/2, y:self.frame.height - (verticalOffset + mNameLabel!.frame.height))
        mInfoLabel!.backgroundColor = UIColor.clearColor()
        mInfoLabel!.textColor = UIColor.whiteColor()
        mInfoLabel!.font = UIFont.italicSystemFontOfSize(20)
        mInfoLabel!.text = mRestaurantInformation
        mInfoLabel!.numberOfLines = 0
        mInfoLabel!.font = UIFont(name: "Titillium-Regular", size: 20.0)
        mInfoLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mInfoLabel!)
    }
    
    func changeRestaurant(name: String, information: String, background: String, logo: String) {
        mRestaurantName = name
        mRestaurantInformation = information
        mHiRezBackground = background
        mRestaurantLogo = logo
        
        
        mNameLabel?.text = mRestaurantName
        mInfoLabel?.text = mRestaurantInformation
        if mRestaurantLogo == "blank" {
            mRestaurantLogoView?.image = UIImage()
        } else {
            let restaurantLogo = UIImage(named: mRestaurantLogo)
            mRestaurantLogoView?.image = restaurantLogo
        }
        let mHiRezBackgroundImage = UIImage(named: mHiRezBackground)
        mHiRezBackgroundView!.image = mHiRezBackgroundImage
    }
    
    // MARK: Analytics Functions
    func reloadButtons() {
        
    }
}
