
//
//  AppDelegate.swift
//  Hourglass
//
//  Created by Seyun Kim on 9/1/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: AnalyticsAppDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        Parse.setApplicationId("0j36fiUUAH1Y0IFjuTA3fljjmUT3Wh3hU3srLX1k",
            clientKey: "kaK4EbHU8hQTEthuY5nXdY6qHMTLudchiApfPHZN")
        
        if (PFUser.currentUser() == nil) {
            var found = false
            let defaults = NSUserDefaults.standardUserDefaults()
            if let username = defaults.stringForKey("HGUsername") {
                if let password = defaults.stringForKey("HGPassword") {
                    PFUser.logInWithUsernameInBackground(username, password: password, block: { (user: PFUser?, error: NSError?) -> Void in
                        if let unwrappedUser = user as PFUser! {
                            if let unwrappedObjectId = unwrappedUser.objectId as String! {
                                AnalyticsController.sharedController.userName = unwrappedObjectId
                                
                                HourglassNavigationController.sharedInstance?.mProfileController?.reloadData()
                            }
                        } else {
                            print(error)
                        }
                    })
                } else {
                    found = true
                }
            } else {
                found = true
            }
            if found {
                PFAnonymousUtils.logInWithBlock { (user : PFUser?, error : NSError?) -> Void in
                    if let unwrappedUser = user as PFUser! {
                        if let unwrappedObjectId = unwrappedUser.objectId as String! {
                            AnalyticsController.sharedController.userName = unwrappedObjectId
                            user!.setValue(false, forKey: "claimed")
                            user!.setValue("Anonymous", forKey: "firstName")
                            user!.setValue("User", forKey: "lastName")
                            user!.saveInBackground()
                            
                            HourglassNavigationController.sharedInstance?.mProfileController?.reloadData()
                        }
                    } else {
                        print(error)
                    }
                }
            }
            
            return true
        } else {
            AnalyticsController.sharedController.userName = PFUser.currentUser()!.objectId!
            return true
        }
    }

    override func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        super.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

