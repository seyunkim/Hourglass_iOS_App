//
//  HAAccountCreationView.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HAAccountCreationView : UIView, UITextFieldDelegate {
    var mUserNameField : UITextField?
    var mPasswordField : UITextField?
    var mPasswordValidationField : UITextField?
    
    var mFirstNameField : UITextField?
    var mLastNameField : UITextField?
    var mEmailField : UITextField?
    var mPhoneField : UITextField?
    
    var mCancelButton : UIButton?
    var mNextButton : UIButton?
    
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
        backgroundColor = UIColor.blackColor()
        
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
        
        mCancelButton = UIButton(type: .Custom)
        mCancelButton!.frame = CGRectMake(15.0, mPasswordValidationField!.frame.origin.y + mPasswordValidationField!.frame.height + 15.0, frame.width / 2.0 - 22.5, mPasswordValidationField!.frame.height * 2.0)
        mCancelButton!.layer.cornerRadius = mCancelButton!.frame.height / 4.0
        mCancelButton!.layer.masksToBounds = true
        mCancelButton!.backgroundColor = UIColor.whiteColor()
        mCancelButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mCancelButton!.setTitle("Cancel", forState: .Normal)
        mCancelButton!.addTarget(self, action: "cancelAccountCreation", forControlEvents: .TouchUpInside)
        addSubview(mCancelButton!)
        
        mNextButton = UIButton(type: .Custom)
        mNextButton!.frame = CGRectMake(frame.width / 2.0 + 7.5, mCancelButton!.frame.origin.y, mCancelButton!.frame.width, mCancelButton!.frame.height)
        mNextButton!.layer.cornerRadius = mNextButton!.frame.height / 4.0
        mNextButton!.layer.masksToBounds = true
        mNextButton!.backgroundColor = UIColor.whiteColor()
        mNextButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mNextButton!.setTitle("Sign Up", forState: .Normal)
        mNextButton!.addTarget(self, action: "continueAccountCreation", forControlEvents: .TouchUpInside)
        addSubview(mNextButton!)
        
        mUserNameField!.becomeFirstResponder()
    }
    
    func validateFirstStage() {
        self.cleanupFirstStage()
        self.setupSecondStage()
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
        removeFromSuperview()
    }
    
    func cancelAccountCreation() {
        removeFromSuperview()
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
    
    // Analytics Functions
    func reloadButtons() {
        // CANCEL
        if HAConstants.buttonTapDictionary.objectForKey("CancelAccountCreation") != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("CancelAccountCreation") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mCancelButton?.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
        
        // NEXT
        if HAConstants.buttonTapDictionary.objectForKey("NextAccountCreation") != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("NextAccountCreation") as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            mNextButton?.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
    }
}
