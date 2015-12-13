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
    var mRestaurantLogo : UIImage?
    var mRestaurantName = "Restaurant Name"
    var mHiRezBackground : UIImage?
    var mRestaurantInformation = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc sit amet dignissim sapien, et malesuada tortor. Fusce congue lorem eu tortor elementum, eget rhoncus quam pellentesque. Donec quis viverra augue. Cras sem urna, fringilla iaculis facilisis id, molestie vel est. Duis euismod suscipit ex quis hendrerit. Donec vitae magna magna. Nullam iaculis ultricies tincidunt. Nullam tincidunt hendrerit commodo."
    
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
        // First load in the High Resolution Background
        mHiRezBackground = UIImage(named: "SampleHiRez")
        var hiRezFrame = self.frame
        hiRezFrame.origin.y = 0
        hiRezFrame.origin.x = 0
        let hiRezView = UIImageView(frame: hiRezFrame)
        hiRezView.image = mHiRezBackground
        self.addSubview(hiRezView)
        let darkenView = UIView(frame: hiRezView.frame)
        darkenView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.addSubview(darkenView)
        
        // Set up ratio constants
        let percentForLogo = CGFloat(1.0/4)
        let verticalOffset = CGFloat(64)
        
        // Then Load in the Restaurant Logo
        let logoWidth = CGFloat(64)
        mRestaurantLogo = UIImage(named: "SampleRestaurantLogo")
        let logoView = UIImageView(frame: CGRectMake(
            (self.frame.width * percentForLogo - logoWidth) / 2,
            verticalOffset,
            logoWidth,
            logoWidth))
        logoView.image = mRestaurantLogo
        self.addSubview(logoView)
        
        // Add the Restaurant Name and Description Labels
        let nameLabel = UILabel(frame: CGRectMake(
            (self.frame.width * percentForLogo),
            verticalOffset,
            self.frame.width * (CGFloat(1) - percentForLogo),
            logoWidth))
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont.systemFontOfSize(36)
        nameLabel.text = mRestaurantName
        self.addSubview(nameLabel)
        
        let descriptionLabel = UILabel(frame: CGRectMake(
            (self.frame.width * percentForLogo / 1.5),
            verticalOffset + nameLabel.frame.height,
            self.frame.width - (self.frame.width * percentForLogo / 1.5) - CGFloat(18),
            self.frame.height - (verticalOffset + nameLabel.frame.height)))
        descriptionLabel.backgroundColor = UIColor.clearColor()
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.font = UIFont.italicSystemFontOfSize(24)
        descriptionLabel.text = mRestaurantInformation
        descriptionLabel.numberOfLines = 0
        self.addSubview(descriptionLabel)
    }
}
