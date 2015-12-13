//
//  ProfileViewController.swift
//  Hourglass
//
//  Created by Seyun Kim on 12/12/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import UIKit


class ProfileViewController:UIViewController {
 
    
    @IBOutlet weak var profilePicture: UIImageView!

    @IBOutlet weak var handleTextDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
        self.profilePicture.layer.borderWidth = CGFloat(3.0)
        self.profilePicture.layer.borderColor = UIColor.blackColor().CGColor
        self.profilePicture.layer.masksToBounds = true
    }
    
    
    
    
    func setHandle (name: String) {
        self.handleTextDisplay.text = name
    }
}
