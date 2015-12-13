//
//  RestaurantInformationView.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/12/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class RestaurantInformationView : UIView {
    // MARK: Private Variables
    var mRestaurantName = "Restaurant Name"
    var mRestaurantPriceRating = "$$"
    var mRestaurantPhoneNumber = "972-867-5309"
    var mRestaurantAddress = "1 Market St.\nSan Francisco, CA"
    var mRestaurantCategory = "Steakhouse"
    
    var mNameLabel : UILabel?
    var mPhoneLabel : UILabel?
    var mAddressLabel : UILabel?
    var mCategoryLabel : UILabel?
    var mMapView : MKMapView?
    
    var mRatingLabel : UILabel?
    
    var horizontalOffset : CGFloat?
    let verticalPadding = CGFloat(16)
    
    // MARK: Initialization Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationImplementation()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initializationImplementation()
    }
    
    required init(frame: CGRect, name: String, price: String, phone: String, address: String, category: String) {
        super.init(frame: frame)
        mRestaurantName = name
        mRestaurantPriceRating = price
        mRestaurantPhoneNumber = phone
        mRestaurantAddress = address
        mRestaurantCategory = category
        initializationImplementation()
    }
    
    func initializationImplementation() {
        self.backgroundColor = UIColor(red: CGFloat(245/255.0), green: CGFloat(245/255.0), blue: CGFloat(220/255.0), alpha: CGFloat(1.0))
        horizontalOffset = self.frame.width / 6.0
        
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
        mNameLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mNameLabel!)
        
        // Category
        mCategoryLabel = UILabel(frame: CGRectMake(
            16,
            mNameLabel!.frame.origin.y + mNameLabel!.frame.height,
            self.frame.width - 32,
            CGFloat(32)))
        mCategoryLabel!.backgroundColor = UIColor.clearColor()
        mCategoryLabel!.textColor = UIColor.darkGrayColor()
        //mCategoryLabel!.font = UIFont.systemFontOfSize(24)
        mCategoryLabel!.text = mRestaurantCategory
        mCategoryLabel!.textAlignment = .Center
        mCategoryLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mCategoryLabel!)
        
        // Rating
        mRatingLabel = UILabel(frame: CGRectMake(
            horizontalOffset!,
            mCategoryLabel!.frame.origin.y + mCategoryLabel!.frame.height + verticalPadding,
            self.frame.width - (2 * horizontalOffset!),
            self.frame.height * 3 / 4.0))
        mRatingLabel!.backgroundColor = UIColor.clearColor()
        mRatingLabel!.textColor = UIColor.blackColor()
        mRatingLabel!.font = UIFont.systemFontOfSize(20)
        mRatingLabel!.text = "Price Rating: " + String(mRestaurantPriceRating)
        mRatingLabel!.adjustsFontSizeToFitWidth = true
        mRatingLabel!.sizeToFit()
        self.addSubview(mRatingLabel!)
        
        // Phone
        mPhoneLabel = UILabel(frame: CGRectMake(
            horizontalOffset!,
            mRatingLabel!.frame.origin.y + mRatingLabel!.frame.height + verticalPadding,
            self.frame.width - (2 * horizontalOffset!),
            mRatingLabel!.frame.height))
        mPhoneLabel!.backgroundColor = UIColor.clearColor()
        mPhoneLabel!.textColor = UIColor.blackColor()
        mPhoneLabel!.font = UIFont.systemFontOfSize(20)
        mPhoneLabel!.text = mRestaurantPhoneNumber
        mPhoneLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mPhoneLabel!)
        
        // Map -- PLACEHOLDER
        mMapView = MKMapView(frame: CGRectMake(
            horizontalOffset!,
            self.frame.height / 2.0,
            self.frame.width - (2 * horizontalOffset!),
            self.frame.height / 4.0))
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mRestaurantAddress) { (placemarks, error) -> Void in
            if let pmarks = placemarks as [CLPlacemark]! {
                if pmarks.count > 0 {
                    let topResult = pmarks[0]
                    let placemark = MKPlacemark(placemark: topResult)
                    
                    let region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 4000, 4000)
                    self.mMapView?.setRegion(region, animated: true)
                    self.mMapView?.addAnnotation(placemark)
                }
            }
        }
        self.addSubview(mMapView!)
        
//        let sampleMapView = UIImageView(frame: CGRectMake(
//            horizontalOffset!,
//            self.frame.height / 2.0,
//            self.frame.width - (2 * horizontalOffset!),
//            self.frame.height / 4.0))
//        sampleMapView.image = UIImage(named: "SampleHiRez")
//        self.addSubview(sampleMapView)
        
        // Address
        mAddressLabel = UILabel(frame: CGRectMake(
            horizontalOffset!,
            mMapView!.frame.origin.y + mMapView!.frame.height + verticalPadding,
            self.frame.width - (2 * horizontalOffset!),
            self.frame.height - (mMapView!.frame.origin.y + mMapView!.frame.height) - verticalPadding))
        mAddressLabel!.backgroundColor = UIColor.clearColor()
        mAddressLabel!.textColor = UIColor.blackColor()
        mAddressLabel!.font = UIFont.systemFontOfSize(18)
        mAddressLabel!.text = mRestaurantAddress
        mAddressLabel!.numberOfLines = 0
        mAddressLabel!.sizeToFit()
        self.addSubview(mAddressLabel!)
    }
    
    func changeRestaurant(name: String, price: String, phone: String, address: String, category: String) {
        mRestaurantName = name
        mRestaurantPriceRating = price
        mRestaurantPhoneNumber = phone
        mRestaurantAddress = address
        mRestaurantCategory = category
        
        mNameLabel?.text = mRestaurantName
        
        mCategoryLabel?.text = mRestaurantCategory
        
        mRatingLabel?.frame = CGRectMake(
            horizontalOffset!,
            mCategoryLabel!.frame.origin.y + mCategoryLabel!.frame.height + verticalPadding,
            self.frame.width - (2 * horizontalOffset!),
            self.frame.height * 3 / 4.0)
        mRatingLabel?.text = "Price Rating: " + String(mRestaurantPriceRating)
        mRatingLabel?.sizeToFit()
        
        mPhoneLabel?.text = mRestaurantPhoneNumber
        
        mAddressLabel?.text = mRestaurantAddress
        
        mMapView?.removeAnnotations(mMapView!.annotations)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mRestaurantAddress) { (placemarks, error) -> Void in
            if let pmarks = placemarks as [CLPlacemark]! {
                if pmarks.count > 0 {
                    let topResult = pmarks[0]
                    let placemark = MKPlacemark(placemark: topResult)
                    
                    let region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 4000, 4000)
                    self.mMapView?.setRegion(region, animated: true)
                    self.mMapView?.addAnnotation(placemark)
                }
            }
        }
        
    }
}
