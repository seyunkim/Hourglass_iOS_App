//
//  HARestaurantInformationView.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HARestaurantInformationView : UIView {
    // MARK: Private Variables
    var mRestaurantName = "Restaurant Name"
    var mRestaurantPriceRating = "$$"
    var mRestaurantPhoneNumber = "972-867-5309"
    var mRestaurantAddress = "1 Market St.\nSan Francisco, CA"
    var mRestaurantCategory = "Steakhouse"
    
    
    
    var mBackgroundImage: UIImageView?
    var mrecentImage1: UIImageView?
    var mNameLabel : UILabel?
    var mRecentLabel: UILabel?
    var mHoursLabel : UILabel?
    var mAddressLabel : UILabel?
    var mCategoryLabel : UILabel?
    //var mMapView : MKMapView?
    var mPlacemark : MKPlacemark?
    
    var mMenuButton: UIButton?
    var mCallButton: UIButton?
    var mSubmitContentButton: UIButton?
    
    var mNavigateButton: UIButton?
    var mParkingButton: UIButton?
    
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
        self.backgroundColor = UIColor.clearColor()
        horizontalOffset = self.frame.width / 12.0
        
        // Name Label
        mNameLabel = UILabel(frame: CGRectMake(
            CGFloat(0),
            CGFloat(32),
            self.frame.width,
            CGFloat(64)))
        mNameLabel!.backgroundColor = UIColor.clearColor()
        mNameLabel!.textColor = UIColor.blackColor()
        mNameLabel!.text = mRestaurantName
        mNameLabel!.textAlignment = NSTextAlignment.Center
        
        mNameLabel!.font = UIFont(name: "Montserrat-Regular", size: 36.0)
        
        mNameLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mNameLabel!)
        
        // Category
        mCategoryLabel = UILabel(frame: CGRectMake(
            16,
            mNameLabel!.frame.origin.y + mNameLabel!.frame.height * 0.7,
            self.frame.width - 32,
            CGFloat(32)))
        mCategoryLabel!.backgroundColor = UIColor.clearColor()
        mCategoryLabel!.textColor = UIColor.darkGrayColor()
        //mCategoryLabel!.font = UIFont.systemFontOfSize(24)
        mCategoryLabel!.text = mRestaurantCategory
        mCategoryLabel!.textAlignment = .Center
        
        mCategoryLabel!.font = UIFont(name: "Titillium-Regular", size: 20.0)
        mCategoryLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mCategoryLabel!)
        
        //MenuButton
        mMenuButton = UIButton(frame: CGRectMake(
            15.0,
            mCategoryLabel!.frame.origin.y + mCategoryLabel!.frame.height * 0.5,
            self.frame.width/4,
            self.frame.width/4))
        mMenuButton?.setTitle("MenuButton", forState: .Normal)
        mMenuButton?.backgroundColor = UIColor.whiteColor()
        mMenuButton!.center = CGPoint(x: self.frame.width/2, y: mCategoryLabel!.frame.origin.y + mMenuButton!.frame.height)
        mMenuButton?.addTarget(self, action: "openMenu", forControlEvents: .TouchUpInside)
        self.addSubview(mMenuButton!)
        
        
        //Call Button
        
        mCallButton = UIButton(frame: CGRectMake(
            15.0,
            mCategoryLabel!.frame.origin.y + mCategoryLabel!.frame.height * 0.5,
            self.frame.width/4,
            self.frame.width/4))
        mCallButton?.setTitle("CallButton", forState: .Normal)
        mCallButton?.backgroundColor = UIColor.whiteColor()
        mCallButton!.center = CGPoint(x: (mMenuButton?.center.x)! * 0.40, y: mCategoryLabel!.frame.origin.y + mMenuButton!.frame.height)
        mCallButton!.addTarget(self, action: "call", forControlEvents: .TouchUpInside)
        self.addSubview(mCallButton!)
        
        //Submit Video/Photo Button
        mSubmitContentButton = UIButton(frame: CGRectMake(
            15.0,
            mCategoryLabel!.frame.origin.y + mCategoryLabel!.frame.height * 0.5,
            self.frame.width/4,
            self.frame.width/4))
        mSubmitContentButton?.setTitle("CameraButton", forState: .Normal)
        mSubmitContentButton?.backgroundColor = UIColor.whiteColor()
        mSubmitContentButton!.center = CGPoint(x: (mMenuButton?.center.x)! * 1.60, y: mCategoryLabel!.frame.origin.y + mMenuButton!.frame.height)
        mSubmitContentButton!.addTarget(self, action: "submitContent", forControlEvents: .TouchUpInside)
        self.addSubview(mSubmitContentButton!)
        
        
        
        // Map -- PLACEHOLDER
//        mMapView = MKMapView(frame: CGRectMake(
//            horizontalOffset!,
//            self.frame.height * 0.7,
//            self.frame.width,
//            self.frame.height / 4.0))
//        mMapView?.center = CGPoint( x:self.frame.size.width/2, y:self.frame.size.height * 0.80)
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(mRestaurantAddress) { (placemarks, error) -> Void in
//            if let pmarks = placemarks as [CLPlacemark]! {
//                if pmarks.count > 0 {
//                    let topResult = pmarks[0]
//                    let placemark = MKPlacemark(placemark: topResult)
//                    self.mPlacemark = placemark
//                    let newCenter = CLLocationCoordinate2DMake(placemark.coordinate.latitude + 0.01, placemark.coordinate.longitude)
//                    
//                    let region = MKCoordinateRegionMakeWithDistance(newCenter, 4000, 4000)
//                    self.mMapView?.setRegion(region, animated: true)
//                    self.mMapView?.addAnnotation(placemark)
//                    self.mMapView?.selectAnnotation(self.mMapView!.annotations[0], animated: true)
//                }
//            }
//        }
//        self.addSubview(mMapView!)
        
        // recently visited picture
        mrecentImage1 = UIImageView(frame: CGRectMake(
            horizontalOffset!,
            self.frame.height * 0.7 - (self.frame.height / 4.0)/3,
            40,
            40))
        mrecentImage1?.image = UIImage(named: "Sample Headshot")
        mrecentImage1!.layer.cornerRadius = mrecentImage1!.frame.size.height/2
        mrecentImage1!.layer.masksToBounds = true
        self.addSubview(mrecentImage1!)
        
        // recently visted label
        mRecentLabel = UILabel(frame: CGRectMake(
            horizontalOffset!,
            mrecentImage1!.frame.origin.y - mrecentImage1!.frame.height,
            self.frame.width - (2 * horizontalOffset!),
            mrecentImage1!.frame.height))
        mRecentLabel!.backgroundColor = UIColor.clearColor()
        mRecentLabel!.textColor = UIColor.blackColor()
        mRecentLabel!.font = UIFont.systemFontOfSize(20)
        mRecentLabel!.text = "Recently Visited: "
        mRecentLabel!.font = UIFont(name: "Titillium-Regular", size: 20.0)
        mRecentLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mRecentLabel!)
        
        
        // hours
        mHoursLabel = UILabel(frame: CGRectMake(
            horizontalOffset!,
            mRecentLabel!.frame.origin.y - mRecentLabel!.frame.height + verticalPadding/3,
            self.frame.width - (2 * horizontalOffset!),
            mRecentLabel!.frame.height))
        mHoursLabel!.backgroundColor = UIColor.clearColor()
        mHoursLabel!.textColor = UIColor.blackColor()
        mHoursLabel!.font = UIFont.systemFontOfSize(20)
        mHoursLabel!.text = "Hours Today: 8am - 11pm" //+ eventually add in hours
        mHoursLabel!.font = UIFont(name: "Titillium-Regular", size: 20.0)
        mHoursLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mHoursLabel!)
        
        // Rating
        mRatingLabel = UILabel(frame: CGRectMake(
            horizontalOffset!, mHoursLabel!.frame.origin.y - mHoursLabel!.frame.height/2,
            self.frame.width - (2 * horizontalOffset!),
            self.frame.height * 3 / 4.0))
        mRatingLabel!.backgroundColor = UIColor.clearColor()
        mRatingLabel!.textColor = UIColor.blackColor()
        mRatingLabel!.font = UIFont.systemFontOfSize(20)
        mRatingLabel!.text = "Price Rating: " + String(mRestaurantPriceRating)
        
        mRatingLabel!.font = UIFont(name: "Titillium-Regular", size: 20.0)
        mRatingLabel!.adjustsFontSizeToFitWidth = true
        mRatingLabel!.sizeToFit()
        self.addSubview(mRatingLabel!)
        
        //navigate Button
        mNavigateButton = UIButton(frame: CGRectMake(
            15.0,
            self.frame.height * 0.7 + (self.frame.height / 4.0) * 0.5,
            self.frame.width/2,
            self.frame.height - (self.frame.height * 0.7 + (self.frame.height / 4.0))))
        mNavigateButton?.center = CGPoint(x: self.frame.width/4, y: self.frame.height * 0.7 + (self.frame.height / 4.0) + mNavigateButton!.frame.height/2)
        mNavigateButton?.backgroundColor = UIColor.whiteColor()
        mNavigateButton?.setTitle("Navigate", forState: UIControlState.Normal)
        mNavigateButton?.layer.cornerRadius = 10
        mNavigateButton?.addTarget(self, action: "navigate", forControlEvents: .TouchUpInside)
        mNavigateButton?.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20.0)
        mNavigateButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(mNavigateButton!)
        
        //suggested parking button
        mParkingButton = UIButton(frame: CGRectMake(
            15.0,
            self.frame.height * 0.7 + (self.frame.height / 4.0) * 0.5,
            self.frame.width/2,
            self.frame.height - (self.frame.height * 0.7 + (self.frame.height / 4.0))))
        mParkingButton!.center = CGPoint(x: self.frame.width * 0.75, y: self.frame.height * 0.7 + (self.frame.height / 4.0) + mNavigateButton!.frame.height/2)
        mParkingButton!.backgroundColor = UIColor.whiteColor()
        mParkingButton!.setTitle("Suggested Parking", forState: UIControlState.Normal)
        mParkingButton!.layer.cornerRadius = 10
        mParkingButton!.addTarget(self, action: "suggestParking", forControlEvents: .TouchUpInside)
        mParkingButton!.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20.0)
        mParkingButton!.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(mParkingButton!)
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
            horizontalOffset!, mHoursLabel!.frame.origin.y - mHoursLabel!.frame.height/2,
            self.frame.width - (2 * horizontalOffset!),
            self.frame.height * 3 / 4.0)
        mRatingLabel?.text = "Price Rating: " + String(mRestaurantPriceRating)
        mRatingLabel?.sizeToFit()
        
        //mPhoneLabel?.text = mRestaurantPhoneNumber
        
        mAddressLabel?.text = mRestaurantAddress
        
//        mMapView?.removeAnnotations(mMapView!.annotations)
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(mRestaurantAddress) { (placemarks, error) -> Void in
//            if let pmarks = placemarks as [CLPlacemark]! {
//                if pmarks.count > 0 {
//                    let topResult = pmarks[0]
//                    let placemark = MKPlacemark(placemark: topResult)
//                    self.mPlacemark = placemark
//                    let region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 4000, 4000)
//                    self.mMapView?.setRegion(region, animated: true)
//                    self.mMapView?.addAnnotation(placemark)
//                }
//            }
//        }
        
    }
    
    func navigate() {
        
    }
    
    func suggestParking() {
        
    }
    
    func openMenu() {
        
    }
    
    func call() {
        
    }
    
    func submitContent() {
        
    }
    
    // MARK: Analytics Functions
    func reloadButtons() {
        // MENU
        if HAConstants.buttonTapDictionary.objectForKey("OpenMenu") != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("OpenMenu") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mMenuButton?.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
        
        // CALL
        if HAConstants.buttonTapDictionary.objectForKey("CallRestaurant") != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("CallRestaurant") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mCallButton?.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
        
        // SUBMIT CONTENT
        if HAConstants.buttonTapDictionary.objectForKey("SubmitOrBrowseContent") != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("SubmitOrBrowseContent") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mSubmitContentButton?.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
        
        // NAVIGATE
        if HAConstants.buttonTapDictionary.objectForKey("NavigateToRestaurant") != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("NavigateToRestaurant") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mNavigateButton?.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
        
        // PARKING
        if HAConstants.buttonTapDictionary.objectForKey("SuggestParking") != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("SuggestParking") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mParkingButton?.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
    }
}
