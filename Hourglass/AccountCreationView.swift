//
//  AccountCreationView.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/21/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import Foundation
import UIKit

protocol AccountCreationDelegate {
    func accountCreated()
}

class AccountCreationView : UIView, UITextFieldDelegate {
    var mDelegate : AccountCreationDelegate?
    
    var mUserNameField : UITextField?
    var mPasswordField : UITextField?
    var mPasswordValidationField : UITextField?
    
    var mFirstNameField : UITextField?
    var mLastNameField : UITextField?
    var mEmailField : UITextField?
    var mPhoneField : UITextField?
    
    var mCancelButton : AnalyticsUIButton?
    var mNextButton : AnalyticsUIButton?
    
    //var mForCreation = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        internalImplementation()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        internalImplementation()
    }
    
    internal func internalImplementation() {
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
        backgroundColor = UIColor(red: r, green: g, blue: b, alpha: a)
        
        setupFirstStage()
    }
    
    func setupFirstStage() {
        mUserNameField = UITextField(frame: CGRectMake(10.0, 34.0, frame.width - 20.0, 44.0))
        mUserNameField!.backgroundColor = UIColor.whiteColor()
        mUserNameField!.borderStyle = .Bezel
        mUserNameField!.placeholder = "Username - Letters and Digits Only"
        mUserNameField!.delegate = self
        mUserNameField!.returnKeyType = .Next
        mUserNameField!.keyboardType = .Default
        mUserNameField!.autocapitalizationType = .None
        mUserNameField!.autocorrectionType = .No
        addSubview(mUserNameField!)
        
        mPasswordField = UITextField(frame: CGRectMake(10.0, mUserNameField!.frame.origin.y + mUserNameField!.frame.height + 10.0, mUserNameField!.frame.width, mUserNameField!.frame.height))
        mPasswordField!.backgroundColor = UIColor.whiteColor()
        mPasswordField!.borderStyle = .Bezel
        mPasswordField!.placeholder = "Password - Minimum 6 Characters"
        mPasswordField!.delegate = self
        mPasswordField!.returnKeyType = .Next
        mPasswordField!.keyboardType = .Default
        mPasswordField!.autocapitalizationType = .None
        mPasswordField!.autocorrectionType = .No
        mPasswordField!.secureTextEntry = true
        addSubview(mPasswordField!)
        
        mPasswordValidationField = UITextField(frame: CGRectMake(10.0, mPasswordField!.frame.origin.y + mPasswordField!.frame.height + 10.0, mPasswordField!.frame.width, mPasswordField!.frame.height))
        mPasswordValidationField!.backgroundColor = UIColor.whiteColor()
        mPasswordValidationField!.borderStyle = .Bezel
        mPasswordValidationField!.placeholder = "Verify Password"
        mPasswordValidationField!.delegate = self
        mPasswordValidationField!.returnKeyType = .Done
        mPasswordValidationField!.keyboardType = .Default
        mPasswordValidationField!.autocapitalizationType = .None
        mPasswordValidationField!.autocorrectionType = .No
        mPasswordValidationField!.secureTextEntry = true
        addSubview(mPasswordValidationField!)
        
        mCancelButton = AnalyticsUIButton(type: .Custom)
        mCancelButton!.mAnalyticsButtonIdentifier = "CancelAccountCreation"
        mCancelButton!.frame = CGRectMake(15.0, mPasswordValidationField!.frame.origin.y + mPasswordValidationField!.frame.height + 15.0, frame.width / 2.0 - 22.5, mPasswordValidationField!.frame.height * 2.0)
        mCancelButton!.layer.cornerRadius = mCancelButton!.frame.height / 4.0
        mCancelButton!.layer.masksToBounds = true
        mCancelButton!.backgroundColor = UIColor.redColor()
        mCancelButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mCancelButton!.setTitle("Cancel", forState: .Normal)
        mCancelButton!.addTarget(self, action: "cancelAccountCreation", forControlEvents: .TouchUpInside)
        addSubview(mCancelButton!)
        
        mNextButton = AnalyticsUIButton(type: .Custom)
        mNextButton!.mAnalyticsButtonIdentifier = "NextAccountCreation"
        mNextButton!.frame = CGRectMake(frame.width / 2.0 + 7.5, mCancelButton!.frame.origin.y, mCancelButton!.frame.width, mCancelButton!.frame.height)
        mNextButton!.layer.cornerRadius = mNextButton!.frame.height / 4.0
        mNextButton!.layer.masksToBounds = true
        mNextButton!.backgroundColor = HourglassConstants.logoColor
        mNextButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mNextButton!.setTitle("Sign Up", forState: .Normal)
        mNextButton!.addTarget(self, action: "continueAccountCreation", forControlEvents: .TouchUpInside)
        addSubview(mNextButton!)
        
        mUserNameField!.becomeFirstResponder()
    }
    
    func validateFirstStage() {
        if mUserNameField!.text == nil || mUserNameField!.text!.rangeOfCharacterFromSet(NSCharacterSet.punctuationCharacterSet()) != nil {
            // UserName is faulty
            mUserNameField!.text = ""
            mPasswordValidationField!.text = ""
            UIAlertView(title: "Username Invalid", message: "Please enter a username with alphanumeric characters only.", delegate: nil, cancelButtonTitle: "Ok").show()
        } else if mPasswordField!.text == nil || mPasswordField!.text!.characters.count < 6 {
            // Password is faulty
            mPasswordField!.text = ""
            mPasswordValidationField!.text = ""
            UIAlertView(title: "Password Invalid", message: "Please enter a password with at least 6 characters.", delegate: nil, cancelButtonTitle: "Ok").show()
        } else if mPasswordValidationField!.text == nil || mPasswordValidationField!.text! != mPasswordField!.text! {
            // Password Validation is faulty
            mPasswordValidationField!.text = ""
            UIAlertView(title: "Password Validation Failed", message: "It looks like your two passwords did not match, please try again.", delegate: nil, cancelButtonTitle: "Ok").show()
        } else {
            // Everything checks out
            PFUser.currentUser()?.setValue(mUserNameField!.text!, forKey: "username")
            PFUser.currentUser()?.setValue(mPasswordField!.text!, forKey: "password")
            PFUser.currentUser()?.setValue(true, forKey: "claimed")
            PFUser.currentUser()?.signUpInBackgroundWithBlock({ (finished : Bool, error : NSError?) -> Void in
                if error == nil {
                    PFUser.logInWithUsernameInBackground(self.mUserNameField!.text!, password: self.mPasswordField!.text!, block: { (newUser : PFUser?, logInError : NSError?) -> Void in
                        self.cleanupFirstStage()
                        self.setupSecondStage()
                    })
                }
            })
        }
    }
    
    func cleanupFirstStage() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mUserNameField!.alpha = 0.0
            self.mPasswordField!.alpha = 0.0
            self.mPasswordValidationField!.alpha = 0.0
            self.mNextButton!.titleLabel!.alpha = 0.0
            self.mCancelButton!.titleLabel!.alpha = 0.0
            }) { (completed) -> Void in
                self.mUserNameField!.enabled = false
                self.mPasswordField!.enabled = false
                self.mPasswordValidationField!.enabled = false
                
                self.mNextButton!.setTitle("Complete", forState: .Normal)
                self.mCancelButton!.setTitle("Skip", forState: .Normal)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.mNextButton!.titleLabel!.alpha = 1.0
                    self.mCancelButton!.titleLabel!.alpha = 1.0
                    })
        }
    }
    
    func setupSecondStage() {
        mFirstNameField = UITextField(frame: CGRectMake(10.0, 34.0, frame.width / 2.0 - 15.0, 44.0))
        mFirstNameField!.backgroundColor = UIColor.whiteColor()
        mFirstNameField!.borderStyle = .Bezel
        mFirstNameField!.placeholder = "First Name (Optional)"
        mFirstNameField!.delegate = self
        mFirstNameField!.returnKeyType = .Next
        mFirstNameField!.keyboardType = .NamePhonePad
        mFirstNameField!.autocapitalizationType = .Words
        mFirstNameField!.autocorrectionType = .No
        mFirstNameField!.alpha = 0.0
        addSubview(mFirstNameField!)
        
        mLastNameField = UITextField(frame: CGRectMake(frame.width / 2.0 + 5.0, 34.0, frame.width / 2.0 - 15.0, 44.0))
        mLastNameField!.backgroundColor = UIColor.whiteColor()
        mLastNameField!.borderStyle = .Bezel
        mLastNameField!.placeholder = "Last Name (Optional)"
        mLastNameField!.delegate = self
        mLastNameField!.returnKeyType = .Next
        mLastNameField!.keyboardType = .NamePhonePad
        mLastNameField!.autocapitalizationType = .Words
        mLastNameField!.autocorrectionType = .No
        mLastNameField!.alpha = 0.0
        addSubview(mLastNameField!)
        
        mEmailField = UITextField(frame: CGRectMake(10.0, mUserNameField!.frame.origin.y + mUserNameField!.frame.height + 10.0, mUserNameField!.frame.width, mUserNameField!.frame.height))
        mEmailField!.backgroundColor = UIColor.whiteColor()
        mEmailField!.borderStyle = .Bezel
        mEmailField!.placeholder = "Email Address (Optional)"
        mEmailField!.delegate = self
        mEmailField!.returnKeyType = .Next
        mEmailField!.keyboardType = .EmailAddress
        mEmailField!.autocapitalizationType = .None
        mEmailField!.autocorrectionType = .No
        mEmailField!.alpha = 0.0
        addSubview(mEmailField!)
        
        mPhoneField = UITextField(frame: CGRectMake(10.0, mPasswordField!.frame.origin.y + mPasswordField!.frame.height + 10.0, mPasswordField!.frame.width, mPasswordField!.frame.height))
        mPhoneField!.backgroundColor = UIColor.whiteColor()
        mPhoneField!.borderStyle = .Bezel
        mPhoneField!.placeholder = "Phone Number (Optional)"
        mPhoneField!.delegate = self
        mPhoneField!.returnKeyType = .Done
        mPhoneField!.keyboardType = .NamePhonePad
        mPhoneField!.autocapitalizationType = .None
        mPhoneField!.autocorrectionType = .No
        mPhoneField!.alpha = 0.0
        addSubview(mPhoneField!)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mFirstNameField!.alpha = 1.0
            self.mLastNameField!.alpha = 1.0
            self.mEmailField!.alpha = 1.0
            self.mPhoneField!.alpha = 1.0
            }) { (finished) -> Void in
                // Finished
                self.mFirstNameField!.becomeFirstResponder()
        }
    }
    
    func validateSecondStage() {
        let nameCharacterSet = NSMutableCharacterSet(charactersInString: "'`-")
        nameCharacterSet.formUnionWithCharacterSet(NSCharacterSet.letterCharacterSet())
        nameCharacterSet.invert()
        if (mFirstNameField!.text != nil && mFirstNameField!.text! != "") && mFirstNameField!.text!.rangeOfCharacterFromSet(nameCharacterSet) != nil {
            // First Name is invalid
            mFirstNameField!.text = ""
            UIAlertView(title: "First Name Invalid", message: "Please enter your first name with letter characters or ', `, or - only, or leave the field blank to opt out.", delegate: nil, cancelButtonTitle: "Ok").show()
        } else if (mLastNameField!.text != nil && mLastNameField!.text! != "") && mLastNameField!.text!.rangeOfCharacterFromSet(nameCharacterSet) != nil {
            // Last Name is invalid
            mLastNameField!.text = ""
            UIAlertView(title: "Last Name Invalid", message: "Please enter your last name with letter characters or ', `, or - only, or leave the field blank to opt out.", delegate: nil, cancelButtonTitle: "Ok").show()
        } else if (mEmailField!.text != nil && mEmailField!.text! != "") && !isValidEmail(mEmailField!.text!) {
            // Email is invalid
            mEmailField!.text = ""
            UIAlertView(title: "Email Address Invalid", message: "Please enter a valid email address, or leave the field blank to opt out.", delegate: nil, cancelButtonTitle: "Ok").show()
        } else if (mPhoneField!.text != nil && mPhoneField!.text! != "") && !isValidPhone(mPhoneField!.text!) {
            // Phone is invalid
            mPhoneField!.text = ""
            UIAlertView(title: "Phone Number Invalid", message: "Please enter a valid phone number, or leave the field blank to opt out.", delegate: nil, cancelButtonTitle: "Ok").show()
        } else {
            // Everything checks out
            var changedData = false
            if mFirstNameField!.text != nil && mFirstNameField!.text! != "" {
                PFUser.currentUser()?.setValue(mFirstNameField!.text!, forKey: "firstName")
                changedData = true
            }
            if mLastNameField!.text != nil && mLastNameField!.text! != "" {
                PFUser.currentUser()?.setValue(mLastNameField!.text!, forKey: "lastName")
                changedData = true
            }
            if mEmailField!.text != nil && mEmailField!.text! != "" {
                PFUser.currentUser()?.setValue(mEmailField!.text!, forKey: "email")
                changedData = true
            }
            if mPhoneField!.text != nil && mPhoneField!.text! != "" {
                PFUser.currentUser()?.setValue(mPhoneField!.text!, forKey: "phoneNumber")
                changedData = true
            }
            if changedData {
                PFUser.currentUser()!.saveInBackgroundWithBlock({ (didFinish : Bool, error : NSError?) -> Void in
                    if error != nil {
                        print(error)
                        UIAlertView(title: "Failed To Save User", message: "The data you provided failed to save, please try again.", delegate: nil, cancelButtonTitle: "Ok").show()
                    } else {
                        self.mDelegate?.accountCreated()
                        self.removeFromSuperview()
                    }
                })
            } else {
                mDelegate?.accountCreated()
                removeFromSuperview()
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func isValidPhone(testStr: String) -> Bool {
        let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluateWithObject(testStr)
        
    }
    
    func cancelAccountCreation() {
        if mUserNameField!.alpha == 1.0 {
            removeFromSuperview()
        } else {
            mDelegate?.accountCreated()
            removeFromSuperview()
        }
    }
    
    func continueAccountCreation() {
        if mUserNameField!.alpha == 1.0 {
            validateFirstStage()
        } else {
            validateSecondStage()
        }
    }
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == mUserNameField {
            mPasswordField?.becomeFirstResponder()
            return false
        } else if textField == mPasswordField {
            mPasswordValidationField?.becomeFirstResponder()
            return false
        } else if textField == mPasswordValidationField {
            mPasswordValidationField?.resignFirstResponder()
            validateFirstStage()
            return false
        } else if textField == mFirstNameField {
            mLastNameField?.becomeFirstResponder()
            return false
        } else if textField == mLastNameField {
            mEmailField?.becomeFirstResponder()
            return false
        } else if textField == mEmailField {
            mPhoneField?.becomeFirstResponder()
            return false
        } else if textField == mPhoneField {
            mPhoneField?.resignFirstResponder()
            validateSecondStage()
            return false
        }
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == mPhoneField {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        } else {
            return true
        }
    }
}
