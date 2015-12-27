//
//  HAStatsTableView.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/27/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HAStatsTableView : UITableView, UITableViewDataSource, UITableViewDelegate {
    let mSectionHeaders = ["Special Events", "Enter Background Events", "Button Press Events", "Screen Load Events"]
    let mRowsInSection = [4, 4, 20, 4]
    let mSpecialEventForRow = ["ViewNewRestaurant", "VideoTimeout", "SearchCompleted", "SearchCancelled"]
    let mButtonForRow = ["App Icon", "Profile", "Search", "CaptureVideo", "ToggleFlash", "ToggleCamera", "DownloadVideo", "UploadVideo", "CancelVideo", "OpenMenu", "CallRestaurant", "SuggestOrBrowseContent", "NavigateToRestaurant", "SuggestParking", "CreateAccount", "CancelAccountCreation", "NextAccountCreation", "Category: Ambiance", "Category: Trending", "Category: Soon"]
    let mScreenNames = ["ProfileViewController", "VideoPlayerController", "CameraViewController", "CategoriesViewController"]
    
    // MARK: Table Delegate Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    // MARK: Table Data Source Methods
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mSectionHeaders[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Special Events
        //// ViewNewRestaurant
        //// VideoTimeout
        //// SearchCompleted
        //// SearchCancelled
        // Enter Background Events
        //// ProfileViewController
        //// VideoPlayerController
        //// CameraViewController
        //// CategoriesViewController
        // Button Press Events
        //// Navigation Controller
        ////// App Icon
        ////// Profile
        ////// Search
        //// Camera Controller
        ////// CaptureVideo
        ////// ToggleFlash
        ////// ToggleCamera
        ////// DownloadVideo
        ////// UploadVideo
        ////// CancelVideo
        //// Restaurant Information View
        ////// OpenMenu
        ////// CallRestaurant
        ////// SuggestOrBrowseContent
        ////// NavigateToRestaurant
        ////// SuggestParking
        //// Profile View Controller
        ////// CreateAccount
        //// Account Creation View
        ////// CancelAccountCreation
        ////// NextAccountCreation
        //// Categories View Controller
        ////// Category: Ambiance
        ////// Category: Trending
        ////// Category: Soon
        // Screen Load Events
        //// CategoriesViewController
        //// VideoPlayerController
        //// ProfileViewController
        //// CameraViewController
        return mRowsInSection[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("StatsCell")
        if cell == nil {
            cell = HAStatsTableViewCell(style: .Default, reuseIdentifier: "StatsCell")
        }
        
        if let statsCell = cell as! HAStatsTableViewCell! {
            if indexPath.section == 0 {
                // Special Events
                statsCell.mTitle?.text = mSpecialEventForRow[indexPath.row]
                if HAConstants.specialEventDictionary[mSpecialEventForRow[indexPath.row]] as? NSNumber != nil {
                    statsCell.mCount?.text = String((HAConstants.specialEventDictionary[mSpecialEventForRow[indexPath.row]] as! NSNumber).integerValue)
                    statsCell.mPercent?.text = String(format: "%.2f", (HAConstants.specialEventDictionary[mSpecialEventForRow[indexPath.row]] as! NSNumber).floatValue / Float(HAConstants.totalSpecialEvents) * Float(100)) + "%"
                } else {
                    statsCell.mCount?.text = "0"
                    statsCell.mPercent?.text = "0%"
                }
            } else if indexPath.section == 1 {
                // Enter Background Events
                statsCell.mTitle?.text = mScreenNames[indexPath.row]
                if HAConstants.enterBackgroundDictionary[mScreenNames[indexPath.row]] as? NSNumber != nil {
                    statsCell.mCount?.text = String((HAConstants.enterBackgroundDictionary[mScreenNames[indexPath.row]] as! NSNumber).integerValue)
                    statsCell.mPercent?.text = String(format: "%.2f", (HAConstants.enterBackgroundDictionary[mScreenNames[indexPath.row]] as! NSNumber).floatValue / Float(HAConstants.totalEnterBackgrounds) * Float(100)) + "%"
                } else {
                    statsCell.mCount?.text = "0"
                    statsCell.mPercent?.text = "0%"
                }
            } else if indexPath.section == 2 {
                // Button Press Events
                statsCell.mTitle?.text = mButtonForRow[indexPath.row]
                if HAConstants.buttonTapDictionary[mButtonForRow[indexPath.row]] as? NSNumber != nil {
                    statsCell.mCount?.text = String((HAConstants.buttonTapDictionary[mButtonForRow[indexPath.row]] as! NSNumber).integerValue)
                    statsCell.mPercent?.text = String(format: "%.2f", (HAConstants.buttonTapDictionary[mButtonForRow[indexPath.row]] as! NSNumber).floatValue / Float(HAConstants.totalButtonTaps) * Float(100)) + "%"
                } else {
                    statsCell.mCount?.text = "0"
                    statsCell.mPercent?.text = "0%"
                }
            } else {
                // Screen Load Events
                statsCell.mTitle?.text = mScreenNames[indexPath.row]
                if HAConstants.screenLoadDictionary[mScreenNames[indexPath.row]] as? NSNumber != nil {
                    statsCell.mCount?.text = String((HAConstants.screenLoadDictionary[mScreenNames[indexPath.row]] as! NSNumber).integerValue)
                    statsCell.mPercent?.text = String(format: "%.2f", (HAConstants.screenLoadDictionary[mScreenNames[indexPath.row]] as! NSNumber).floatValue / Float(HAConstants.totalScreenLoads) * Float(100)) + "%"
                } else {
                    statsCell.mCount?.text = "0"
                    statsCell.mPercent?.text = "0%"
                }
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}