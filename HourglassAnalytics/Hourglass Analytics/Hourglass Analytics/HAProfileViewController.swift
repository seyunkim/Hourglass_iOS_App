//
//  HAProfileViewController.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import UIKit


class HAProfileViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var mProfilePicture : UIImageView?
    var mNameLabel : UILabel?
    var mHandleLabel : UILabel?
    var mPhoneLabel : UILabel?
    var mEmailLabel : UILabel?
    var mTableView : UITableView?
    
    var mCreateAccountButton : UIButton?
    var mAccountCreationView : HAAccountCreationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
    }
    
    func load() {
        mProfilePicture = UIImageView(frame: CGRectMake(10.0, 34.0, view.frame.width / 3.0, view.frame.width / 3.0))
        mProfilePicture!.image = UIImage(named: "SampleProfile")
        mProfilePicture!.layer.cornerRadius = mProfilePicture!.frame.width / 2.0
        mProfilePicture!.layer.borderWidth = CGFloat(3.0)
        mProfilePicture!.layer.borderColor = UIColor.darkGrayColor().CGColor
        mProfilePicture!.layer.masksToBounds = true
        mProfilePicture!.userInteractionEnabled = true
        view.addSubview(mProfilePicture!)
        
        
        mNameLabel = UILabel(frame: CGRectMake(mProfilePicture!.frame.origin.x + mProfilePicture!.frame.width + 10.0, mProfilePicture!.frame.origin.y, view.frame.width - (mProfilePicture!.frame.origin.x + mProfilePicture!.frame.width + 10.0) - 10.0, mProfilePicture!.frame.height / 3.0))
        mNameLabel!.text = "Anonymous User"
        mNameLabel!.textColor = UIColor.blackColor()
        mNameLabel!.adjustsFontSizeToFitWidth = true
        view.addSubview(mNameLabel!)
        
        mHandleLabel = UILabel(frame: CGRectMake(mNameLabel!.frame.origin.x, mNameLabel!.frame.origin.y + mNameLabel!.frame.height, mNameLabel!.frame.width * 2.0 / 3.0, mNameLabel!.frame.height))
        mHandleLabel!.text = "@anonymous"
        mHandleLabel!.textColor = UIColor.grayColor()
        mHandleLabel!.font = UIFont.italicSystemFontOfSize(18.0)
        mHandleLabel!.adjustsFontSizeToFitWidth = true
        view.addSubview(mHandleLabel!)
        
        mPhoneLabel = UILabel(frame: CGRectMake(15.0, mProfilePicture!.frame.origin.y + mProfilePicture!.frame.height + 15.0, view.frame.width - 30.0, 20.0))
        mPhoneLabel!.text = "Phone: Unknown"
        mPhoneLabel!.textColor = UIColor.darkGrayColor()
        mPhoneLabel!.adjustsFontSizeToFitWidth = true
        view.addSubview(mPhoneLabel!)
        
        mEmailLabel = UILabel(frame: CGRectMake(15.0, mPhoneLabel!.frame.origin.y + mPhoneLabel!.frame.height + 5.0, view.frame.width - 30.0, 20.0))
        mEmailLabel!.text = "Email: Unknown"
        mEmailLabel!.textColor = UIColor.darkGrayColor()
        mEmailLabel!.adjustsFontSizeToFitWidth = true
        view.addSubview(mEmailLabel!)
        
        mCreateAccountButton = UIButton(type: .Custom)
        mCreateAccountButton!.frame = CGRectMake(30.0, mEmailLabel!.frame.origin.y + mEmailLabel!.frame.height + 10.0, view.frame.width - 60.0, view.frame.height/2.0 - (mEmailLabel!.frame.origin.y + mEmailLabel!.frame.height + 10.0) - 10.0)
        mCreateAccountButton!.backgroundColor = UIColor.whiteColor()
        mCreateAccountButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mCreateAccountButton!.setTitle("Create Account", forState: .Normal)
        mCreateAccountButton!.layer.cornerRadius = mCreateAccountButton!.frame.height / 4.0
        mCreateAccountButton!.layer.masksToBounds = true
        mCreateAccountButton!.addTarget(self, action: "createAccountTouchDown", forControlEvents: .TouchDown)
        mCreateAccountButton!.addTarget(self, action: "createAccountTouchUpOutside", forControlEvents: .TouchUpOutside)
        mCreateAccountButton!.addTarget(self, action: "createAccountTouchUpInside", forControlEvents: .TouchUpInside)
        view.addSubview(mCreateAccountButton!)
        
        mTableView = UITableView(frame: CGRectMake(0, view.frame.height / 2.0, view.frame.width, view.frame.height / 2.0), style: UITableViewStyle.Plain)
        mTableView!.delegate = self
        mTableView!.dataSource = self
        mTableView!.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(mTableView!)
        
        let borderView = UIView(frame: CGRectMake(0, view.frame.height/2.0-0.5, view.frame.width, 1.0))
        borderView.backgroundColor = UIColor.blackColor()
        view.addSubview(borderView)
    }
    
    // MARK: Account Creation Methods
    func createAccountTouchDown() {
        
    }
    
    func createAccountTouchUpOutside() {
        
    }
    
    func createAccountTouchUpInside() {
        createAccountTouchUpOutside()
        
        var accountFrame = view.frame
        accountFrame.origin.y = 0
        mAccountCreationView = HAAccountCreationView(frame: accountFrame)
        mAccountCreationView!.alpha = 0.0
        view.addSubview(mAccountCreationView!)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mAccountCreationView!.alpha = 1.0
            }) { (finished) -> Void in
                // Finished
        }
    }
    
    // MARK: Table Delegate Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: Table Data Source Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("HAProfileCell")
        if cell == nil {
            cell = HAProfileCell(style: .Default, reuseIdentifier: "HAProfileCell")
        }
        
        if let profileCell = cell as! HAProfileCell! {
            if indexPath.row == 0 {
                // Friends
                if HAConstants.buttonTapDictionary.objectForKey("Friends") != nil {
                    let percentage = (HAConstants.buttonTapDictionary.objectForKey("Friends") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
                    profileCell.backgroundColor = HAConstants.colorForPercentage(percentage)
                }
                
                profileCell.mIcon?.image = UIImage(named: "Friends")
                profileCell.mTitle?.text = "Friends"
                profileCell.mBadge?.text = "0"
            } else if indexPath.row == 1 {
                // Posts
                if HAConstants.buttonTapDictionary.objectForKey("Posts") != nil {
                    let percentage = (HAConstants.buttonTapDictionary.objectForKey("Posts") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
                    profileCell.backgroundColor = HAConstants.colorForPercentage(percentage)
                }
                
                profileCell.mIcon?.image = UIImage(named: "Posts")
                profileCell.mTitle?.text = "Posts"
                profileCell.mBadge?.text = "0"
            }
        }
        
        return cell!
    }
    
    // MARK: Analytics Functions
    func reloadButtons() {
        // CREATE ACCOUNT
        if HAConstants.buttonTapDictionary.objectForKey("CreateAccount") != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("CreateAccount") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mCreateAccountButton?.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
        
        // TABLE
        mTableView?.reloadData()
        
        mAccountCreationView?.reloadButtons()
    }
    
    func reloadScreenBackgrounds() {
        if HAConstants.screenLoadDictionary.objectForKey("ProfileViewController") != nil {
            let percentage = (HAConstants.screenLoadDictionary.objectForKey("ProfileViewController") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxScreenLoads).doubleValue * 1.0)
            view.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
    }
    
    func reloadTaps() {
        var frame = view.frame
        frame.origin.y = 0
        let heatMapView = HAHeatmapView(frame: frame)
        heatMapView.drawHeatMap("ProfileViewController")
        view.addSubview(heatMapView)
    }
}
