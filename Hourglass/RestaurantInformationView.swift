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
    
   
    
    var mBackgroundImage: UIImageView?
    var mrecentImage1: UIImageView?
    var mNameLabel : UILabel?
    var mRecentLabel: UILabel?
    var mHoursLabel : UILabel?
    var mAddressLabel : UILabel?
    var mCategoryLabel : UILabel?
    var mMapView : MKMapView?
    var mPlacemark : MKPlacemark?
    
    var mMenuButton: UIButton?
    var mCallButton: UIButton?
    var mSubmitContentButton: UIButton?
    
    
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
        horizontalOffset = self.frame.width / 12.0
        
        //background 
        mBackgroundImage = UIImageView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        mBackgroundImage?.image = UIImage(named: "InformationBackground")
        self.addSubview(mBackgroundImage!)
            
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
            mNameLabel!.frame.origin.y + mNameLabel!.frame.height * 0.7,
            self.frame.width - 32,
            CGFloat(32)))
        mCategoryLabel!.backgroundColor = UIColor.clearColor()
        mCategoryLabel!.textColor = UIColor.darkGrayColor()
        //mCategoryLabel!.font = UIFont.systemFontOfSize(24)
        mCategoryLabel!.text = mRestaurantCategory
        mCategoryLabel!.textAlignment = .Center
        mCategoryLabel!.adjustsFontSizeToFitWidth = true
        self.addSubview(mCategoryLabel!)
        
        //MenuButton
        mMenuButton = UIButton(frame: CGRectMake(
            15.0,
            mCategoryLabel!.frame.origin.y + mCategoryLabel!.frame.height * 0.5,
            self.frame.width/4,
            self.frame.width/4))
        mMenuButton?.setImage(UIImage(named: "MenuButton"), forState: UIControlState.Normal)
        mMenuButton!.center = CGPoint(x: self.frame.width/2, y: mCategoryLabel!.frame.origin.y + mMenuButton!.frame.height)
        mMenuButton?.addTarget(self, action: "openMenu", forControlEvents: .TouchUpInside)
        self.addSubview(mMenuButton!)
        
        
        //Call Button
        
        mCallButton = UIButton(frame: CGRectMake(
            15.0,
            mCategoryLabel!.frame.origin.y + mCategoryLabel!.frame.height * 0.5,
            self.frame.width/4,
            self.frame.width/4))
        mCallButton?.setImage(UIImage(named: "CallButton"), forState: UIControlState.Normal)
        mCallButton!.center = CGPoint(x: (mMenuButton?.center.x)! * 0.40, y: mCategoryLabel!.frame.origin.y + mMenuButton!.frame.height)
        mCallButton!.addTarget(self, action: "call", forControlEvents: .TouchUpInside)
        self.addSubview(mCallButton!)
        
        //Submit Video/Photo Button
        mSubmitContentButton = UIButton(frame: CGRectMake(
            15.0,
            mCategoryLabel!.frame.origin.y + mCategoryLabel!.frame.height * 0.5,
            self.frame.width/4,
            self.frame.width/4))
        mSubmitContentButton?.setImage(UIImage(named: "CameraButton"), forState: UIControlState.Normal)
        mSubmitContentButton!.center = CGPoint(x: (mMenuButton?.center.x)! * 1.60, y: mCategoryLabel!.frame.origin.y + mMenuButton!.frame.height)
        mSubmitContentButton!.addTarget(self, action: "submitContent", forControlEvents: .TouchUpInside)
        self.addSubview(mSubmitContentButton!)
        
        
        
        // Map -- PLACEHOLDER
        mMapView = MKMapView(frame: CGRectMake(
            horizontalOffset!,
            self.frame.height * 0.7,
            self.frame.width,
            self.frame.height / 4.0))
        mMapView?.center = CGPoint( x:self.frame.size.width/2, y:self.frame.size.height * 0.80)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mRestaurantAddress) { (placemarks, error) -> Void in
            if let pmarks = placemarks as [CLPlacemark]! {
                if pmarks.count > 0 {
                    let topResult = pmarks[0]
                    let placemark = MKPlacemark(placemark: topResult)
                    self.mPlacemark = placemark
                    let newCenter = CLLocationCoordinate2DMake(placemark.coordinate.latitude + 0.01, placemark.coordinate.longitude)
                    
                    let region = MKCoordinateRegionMakeWithDistance(newCenter, 4000, 4000)
                    self.mMapView?.setRegion(region, animated: true)
                    self.mMapView?.addAnnotation(placemark)
                    self.mMapView?.selectAnnotation(self.mMapView!.annotations[0], animated: true)
                }
            }
        }
        self.addSubview(mMapView!)
        
        // recently visited picture
            mrecentImage1 = UIImageView(frame: CGRectMake(
            horizontalOffset!,
            mMapView!.frame.origin.y - (mMapView?.frame.height)!/3,
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
        mRatingLabel!.adjustsFontSizeToFitWidth = true
        mRatingLabel!.sizeToFit()
        self.addSubview(mRatingLabel!)
        
        
//        // Address
//        mAddressLabel = UILabel(frame: CGRectMake(
//            horizontalOffset!,
//            mMapView!.frame.origin.y - mMapView!.frame.height - verticalPadding,
//            self.frame.width - (2 * horizontalOffset!),
//            self.frame.height - (mMapView!.frame.origin.y + mMapView!.frame.height) - verticalPadding))
//        mAddressLabel!.backgroundColor = UIColor.clearColor()
//        mAddressLabel!.textColor = UIColor.blackColor()
//        mAddressLabel!.font = UIFont.systemFontOfSize(18)
//        mAddressLabel!.text = mRestaurantAddress
//        mAddressLabel!.numberOfLines = 0
//        mAddressLabel!.sizeToFit()
//        self.addSubview(mAddressLabel!)
        
        //navigate Button
        var navigateButton:UIButton
        navigateButton = UIButton(frame: CGRectMake(
            15.0,
            mMapView!.frame.origin.y + mMapView!.frame.height * 0.5,
            self.frame.width/2,
            self.frame.height - (mMapView!.frame.origin.y + mMapView!.frame.height)))
        navigateButton.center = CGPoint(x: self.frame.width/4, y: mMapView!.frame.origin.y + mMapView!.frame.height + navigateButton.frame.height/2)
        navigateButton.backgroundColor = UIColor(red: 76.0/255.0, green: 218.0/255.0, blue: 101.0/255.0, alpha: 1)
        navigateButton.setTitle("Navigate", forState: UIControlState.Normal)
        navigateButton.layer.cornerRadius = 10
        navigateButton.addTarget(self, action: "navigate", forControlEvents: .TouchUpInside)
        self.addSubview(navigateButton)
        
        //suggested parking button
        var suggestParkingButton:UIButton
        suggestParkingButton = UIButton(frame: CGRectMake(
            15.0,
            mMapView!.frame.origin.y + mMapView!.frame.height * 0.5,
            self.frame.width/2,
            self.frame.height - (mMapView!.frame.origin.y + mMapView!.frame.height)))
        suggestParkingButton.center = CGPoint(x: self.frame.width * 0.75, y: mMapView!.frame.origin.y + mMapView!.frame.height + navigateButton.frame.height/2)
        suggestParkingButton.backgroundColor = HourglassConstants.logoColor
        suggestParkingButton.setTitle("Suggested Parking", forState: UIControlState.Normal)
        suggestParkingButton.layer.cornerRadius = 10
        suggestParkingButton.addTarget(self, action: "suggestParking", forControlEvents: .TouchUpInside)
        self.addSubview(suggestParkingButton)
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
        
        mMapView?.removeAnnotations(mMapView!.annotations)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mRestaurantAddress) { (placemarks, error) -> Void in
            if let pmarks = placemarks as [CLPlacemark]! {
                if pmarks.count > 0 {
                    let topResult = pmarks[0]
                    let placemark = MKPlacemark(placemark: topResult)
                    self.mPlacemark = placemark
                    let region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 4000, 4000)
                    self.mMapView?.setRegion(region, animated: true)
                    self.mMapView?.addAnnotation(placemark)
                }
            }
        }
        
    }
    
    func navigate() {
        let destinationItem = MKMapItem(placemark: mPlacemark!)
        destinationItem.name = mRestaurantName
        let options = NSDictionary(objects: [MKLaunchOptionsDirectionsModeDriving], forKeys: [MKLaunchOptionsDirectionsModeKey])
        MKMapItem.openMapsWithItems([destinationItem], launchOptions: options as? [String : AnyObject])
    }
    
    func suggestParking() {
        UIAlertView(title: "Coming Soon", message: "Thanks for using Hourglass! The suggested parking feature is coming soon!", delegate: nil, cancelButtonTitle: "Ok").show()
    }
    
    func openMenu() {
        UIAlertView(title: "Coming Soon", message: "Thanks for using Hourglass! The menu feature is coming soon!", delegate: nil, cancelButtonTitle: "Ok").show()
    }
    
    func call() {
        var phoneNumber = mRestaurantPhoneNumber
        phoneNumber = phoneNumber.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + phoneNumber)!)
    }
    
    func submitContent() {
        UIAlertView(title: "Coming Soon", message: "Thanks for using Hourglass! The content submission and browsing feature is coming soon!", delegate: nil, cancelButtonTitle: "Ok").show()
    }
}
