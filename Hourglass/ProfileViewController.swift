//
//  ProfileViewController.swift
//  Hourglass
//
//  Created by Seyun Kim on 12/12/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import UIKit


class ProfileViewController : AnalyticsViewController, UITableViewDelegate, UITableViewDataSource, AccountCreationDelegate {
    var mProfilePicture : UIImageView?
    var mNameLabel : UILabel?
    var mHandleLabel : UILabel?
    var mPhoneLabel : UILabel?
    var mEmailLabel : UILabel?
    var mTableView : UITableView?
    
    var mCreateAccountButton : AnalyticsUIButton?
    var mAccountCreationView : AccountCreationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenName = "ProfileViewController"
        view.backgroundColor = UIColor.whiteColor()
    }
    
    func load() {
        mProfilePicture = UIImageView(frame: CGRectMake(10.0, 34.0, view.frame.width / 3.0, view.frame.width / 3.0))
        mProfilePicture!.image = UIImage(named: "SampleProfile")
        mProfilePicture!.layer.cornerRadius = mProfilePicture!.frame.width / 2.0
        mProfilePicture!.layer.borderWidth = CGFloat(3.0)
        mProfilePicture!.layer.borderColor = UIColor.darkGrayColor().CGColor
        mProfilePicture!.layer.masksToBounds = true
        view.addSubview(mProfilePicture!)
        
        let profileTapRec = UITapGestureRecognizer(target: self, action: "photoTapped")
        mProfilePicture!.addGestureRecognizer(profileTapRec)
        
        do {
            try PFUser.currentUser()?.fetch()
        } catch {
            
        }
        if PFUser.currentUser()?.valueForKey("claimed") == nil {
            PFUser.currentUser()?.setValue(false, forKey: "claimed")
        }
        
        if PFUser.currentUser() != nil && PFUser.currentUser()!.valueForKey("claimed") as! Bool {
            mNameLabel = UILabel(frame: CGRectMake(mProfilePicture!.frame.origin.x + mProfilePicture!.frame.width + 10.0, mProfilePicture!.frame.origin.y, view.frame.width - (mProfilePicture!.frame.origin.x + mProfilePicture!.frame.width + 10.0) - 10.0, mProfilePicture!.frame.height / 3.0))
            mNameLabel!.textColor = UIColor.blackColor()
            mNameLabel!.adjustsFontSizeToFitWidth = true
            view.addSubview(mNameLabel!)
            var firstName = "Anonymous"
            if PFUser.currentUser()!.valueForKey("firstName") != nil {
                firstName = PFUser.currentUser()!.valueForKey("firstName") as! String
            }
            var lastName = "User"
            if PFUser.currentUser()!.valueForKey("lastName") != nil {
                lastName = PFUser.currentUser()!.valueForKey("lastName") as! String
            }
            if firstName != "Anonymous" && lastName != "User" {
                mNameLabel!.text = firstName + " " + lastName
            } else if firstName != "Anonymous" {
                mNameLabel!.text = firstName
            } else if lastName != "User" {
                mNameLabel!.text = lastName
            } else {
                mNameLabel!.text = "Anonymous User"
            }
            
            mHandleLabel = UILabel(frame: CGRectMake(mNameLabel!.frame.origin.x, mNameLabel!.frame.origin.y + mNameLabel!.frame.height, mNameLabel!.frame.width * 2.0 / 3.0, mNameLabel!.frame.height))
            mHandleLabel!.text = "@" + (PFUser.currentUser()!.valueForKey("username") as! String)
            mHandleLabel!.textColor = UIColor.grayColor()
            mHandleLabel!.font = UIFont.italicSystemFontOfSize(18.0)
            mHandleLabel!.adjustsFontSizeToFitWidth = true
            view.addSubview(mHandleLabel!)
            
            mPhoneLabel = UILabel(frame: CGRectMake(15.0, mProfilePicture!.frame.origin.y + mProfilePicture!.frame.height + 15.0, view.frame.width - 30.0, 20.0))
            mPhoneLabel!.text = "Phone: Unknown"
            mPhoneLabel!.textColor = UIColor.darkGrayColor()
            mPhoneLabel!.adjustsFontSizeToFitWidth = true
            view.addSubview(mPhoneLabel!)
            if PFUser.currentUser()!.valueForKey("phoneNumber") != nil {
                mPhoneLabel!.text = "Phone: " + (PFUser.currentUser()!.valueForKey("phoneNumber") as! String)
            }
            
            mEmailLabel = UILabel(frame: CGRectMake(15.0, mPhoneLabel!.frame.origin.y + mPhoneLabel!.frame.height + 5.0, view.frame.width - 30.0, 20.0))
            mEmailLabel!.text = "Email: Unknown"
            mEmailLabel!.textColor = UIColor.darkGrayColor()
            mEmailLabel!.adjustsFontSizeToFitWidth = true
            view.addSubview(mEmailLabel!)
            if PFUser.currentUser()!.valueForKey("email") != nil {
                mEmailLabel!.text = "Email: " + (PFUser.currentUser()!.valueForKey("email") as! String)
            }
        } else {
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
            
            mCreateAccountButton = AnalyticsUIButton(type: .Custom)
            mCreateAccountButton!.mAnalyticsButtonIdentifier = "CreateAccount"
            mCreateAccountButton!.frame = CGRectMake(30.0, mEmailLabel!.frame.origin.y + mEmailLabel!.frame.height + 10.0, view.frame.width - 60.0, view.frame.height/2.0 - (mEmailLabel!.frame.origin.y + mEmailLabel!.frame.height + 10.0) - 10.0)
            mCreateAccountButton!.backgroundColor = HourglassConstants.logoColor
            mCreateAccountButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            mCreateAccountButton!.setTitle("Create Account", forState: .Normal)
            mCreateAccountButton!.layer.cornerRadius = mCreateAccountButton!.frame.height / 4.0
            mCreateAccountButton!.layer.masksToBounds = true
            mCreateAccountButton!.addTarget(self, action: "createAccountTouchDown", forControlEvents: .TouchDown)
            mCreateAccountButton!.addTarget(self, action: "createAccountTouchUpOutside", forControlEvents: .TouchUpOutside)
            mCreateAccountButton!.addTarget(self, action: "createAccountTouchUpInside", forControlEvents: .TouchUpInside)
            view.addSubview(mCreateAccountButton!)
        }
        
        mTableView = UITableView(frame: CGRectMake(0, view.frame.height / 2.0, view.frame.width, view.frame.height / 2.0), style: UITableViewStyle.Plain)
        mTableView!.delegate = self
        mTableView!.dataSource = self
        mTableView!.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(mTableView!)
        
        let borderView = UIView(frame: CGRectMake(0, view.frame.height/2.0-0.5, view.frame.width, 1.0))
        borderView.backgroundColor = UIColor.blackColor()
        view.addSubview(borderView)
    }
    
    func reloadData() {
        // Profile picture to come when that is integrated with the user
        
        if PFUser.currentUser()!.valueForKey("claimed") as! Bool {
            var firstName = "Anonymous"
            if PFUser.currentUser()!.valueForKey("firstName") != nil {
                firstName = PFUser.currentUser()!.valueForKey("firstName") as! String
            }
            var lastName = "User"
            if PFUser.currentUser()!.valueForKey("lastName") != nil {
                lastName = PFUser.currentUser()!.valueForKey("lastName") as! String
            }
            if firstName != "Anonymous" && lastName != "User" {
                mNameLabel!.text = firstName + " " + lastName
            } else if firstName != "Anonymous" {
                mNameLabel!.text = firstName
            } else if lastName != "User" {
                mNameLabel!.text = lastName
            } else {
                mNameLabel!.text = "Anonymous User"
            }
            
            mHandleLabel!.text = "@" + (PFUser.currentUser()!.valueForKey("username") as! String)
            
            if PFUser.currentUser()!.valueForKey("phoneNumber") != nil {
                mPhoneLabel!.text = "Phone: " + (PFUser.currentUser()!.valueForKey("phoneNumber") as! String)
            }
            
            if PFUser.currentUser()!.valueForKey("email") != nil {
                mEmailLabel!.text = "Email: " + (PFUser.currentUser()!.valueForKey("email") as! String)
            }
            
            mCreateAccountButton!.removeFromSuperview()
        }
    }
    
    func photoTapped() {
        AnalyticsController.logButtonPress("ProfilePhoto")
        UIAlertView(title: "Coming Soon", message: "Thanks for using Hourglass! Changing your profile photo is coming in an update soon!", delegate: nil, cancelButtonTitle: "Ok").show()
    }
    
    // MARK: Account Creation Methods
    func accountCreated() {
        reloadData()
    }
    
    func createAccountTouchDown() {
        UIView.animateWithDuration(0.1) { () -> Void in
            var r : CGFloat = CGFloat(0.0)
            var g : CGFloat = CGFloat(0.0)
            var b : CGFloat = CGFloat(0.0)
            var a : CGFloat = CGFloat(0.0)
            HourglassConstants.logoColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            r -= 0.2
            if r < 0 {
                r = 0
            }
            g -= 0.2
            if g < 0 {
                g = 0
            }
            b -= 0.2
            if g < 0 {
                g = 0
            }
            self.mCreateAccountButton!.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: a)
        }
    }
    
    func createAccountTouchUpOutside() {
        UIView.animateWithDuration(0.1) { () -> Void in
            self.mCreateAccountButton!.backgroundColor = HourglassConstants.logoColor
        }
    }
    
    func createAccountTouchUpInside() {
        createAccountTouchUpOutside()
        
        var accountFrame = view.frame
        accountFrame.origin.y = 0
        mAccountCreationView = AccountCreationView(frame: accountFrame)
        mAccountCreationView!.alpha = 0.0
        mAccountCreationView!.mDelegate = self
        view.addSubview(mAccountCreationView!)
        
        AnalyticsController.logButtonPress("BeginCreateAccount")
        
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
        var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell")
        if cell == nil {
            cell = ProfileCell(style: .Default, reuseIdentifier: "ProfileCell")
        }
        
        if let profileCell = cell as! ProfileCell! {
            if indexPath.row == 0 {
                // Friends
                profileCell.mIcon?.image = UIImage(named: "Friends")
                profileCell.mTitle?.text = "Friends"
                if PFUser.currentUser() != nil && PFUser.currentUser()!.valueForKey("claimed") as! Bool {
                    // Fix this to read from the user
                    profileCell.mBadge?.text = "0"
                } else {
                    profileCell.mBadge?.text = "0"
                }
            } else if indexPath.row == 1 {
                // Posts
                profileCell.mIcon?.image = UIImage(named: "Posts")
                profileCell.mTitle?.text = "Posts"
                if PFUser.currentUser() != nil && PFUser.currentUser()!.valueForKey("claimed") as! Bool {
                    // Fix this to read from the user
                    profileCell.mBadge?.text = "0"
                } else {
                    profileCell.mBadge?.text = "0"
                }
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            AnalyticsController.logButtonPress("Friends")
        } else if indexPath.row == 1 {
            AnalyticsController.logButtonPress("Posts")
        }
    }
    
}
