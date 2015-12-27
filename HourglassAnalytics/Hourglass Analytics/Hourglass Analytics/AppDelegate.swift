//
//  AppDelegate.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId("4EwiEl7KOjoDVG8YFiLZxiy4EunB5lrsJQc63yz2",
            clientKey: "0Q47KkTeBhemMn291LfilYCnNNfyJnVGtcQmwF7J")
        
        loadButtonPresses()
        loadEnterBackgrounds()
        loadScreenLoads()
        loadSpecialEvents()
        loadTapEvents()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: Analytics Loading
    func loadButtonPresses() {
        let allObjects = NSMutableArray()
        let limit = 1000
        var skip = 0
        let query = PFQuery(className: "ButtonPressEvent")
        query.limit = limit
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                allObjects.addObjectsFromArray(objects!)
                if objects!.count == limit {
                    skip += limit
                    query.skip = skip
                    query.findObjectsInBackgroundWithBlock({ (newObjects: [PFObject]?, newError: NSError?) -> Void in
                        if newError == nil {
                            allObjects.addObjectsFromArray(newObjects!)
                            
                            for object in allObjects {
                                HAConstants.totalButtonTaps += 1
                                let buttonPress = object as! PFObject
                                var number = NSNumber(int: 1)
                                if HAConstants.buttonTapDictionary[buttonPress.valueForKey("buttonIdentifier") as! String] != nil {
                                    number = NSNumber(int:HAConstants.buttonTapDictionary[buttonPress.valueForKey("buttonIdentifier") as! String] as! Int + 1)
                                }
                                HAConstants.buttonTapDictionary[buttonPress.valueForKey("buttonIdentifier") as! String] = number
                                
                                if (number.integerValue > HAConstants.maxButtonTaps) {
                                    HAConstants.maxButtonTaps = number.integerValue
                                }
                            }
                            
                            HANavigationController.sharedInstance!.buttonsLoaded()
                        }
                    })
                } else {
                    for object in allObjects {
                        HAConstants.totalButtonTaps += 1
                        let buttonPress = object as! PFObject
                        var number = NSNumber(int: 1)
                        if HAConstants.buttonTapDictionary[buttonPress.valueForKey("buttonIdentifier") as! String] != nil {
                            number = NSNumber(int:HAConstants.buttonTapDictionary[buttonPress.valueForKey("buttonIdentifier") as! String] as! Int + 1)
                        }
                        HAConstants.buttonTapDictionary[buttonPress.valueForKey("buttonIdentifier") as! String] = number
                        
                        if (number.integerValue > HAConstants.maxButtonTaps) {
                            HAConstants.maxButtonTaps = number.integerValue
                        }
                    }
                    
                    HANavigationController.sharedInstance!.buttonsLoaded()
                }
            }
        }
    }
    
    func loadEnterBackgrounds() {
        let allObjects = NSMutableArray()
        let limit = 1000
        var skip = 0
        let query = PFQuery(className: "EnterBackgroundEvent")
        query.limit = limit
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                allObjects.addObjectsFromArray(objects!)
                if objects!.count == limit {
                    skip += limit
                    query.skip = skip
                    query.findObjectsInBackgroundWithBlock({ (newObjects: [PFObject]?, newError: NSError?) -> Void in
                        if newError == nil {
                            allObjects.addObjectsFromArray(newObjects!)
                            
                            for object in allObjects {
                                HAConstants.totalEnterBackgrounds += 1
                                let enterBackground = object as! PFObject
                                var number = NSNumber(int: 1)
                                if HAConstants.enterBackgroundDictionary[enterBackground.valueForKey("screenName") as! String] != nil {
                                    number = NSNumber(int:HAConstants.enterBackgroundDictionary[enterBackground.valueForKey("screenName") as! String] as! Int + 1)
                                }
                                HAConstants.enterBackgroundDictionary[enterBackground.valueForKey("screenName") as! String] = number
                                
                                if (number.integerValue > HAConstants.maxBackgroundEntries) {
                                    HAConstants.maxBackgroundEntries = number.integerValue
                                }
                            }
                            
                            HANavigationController.sharedInstance!.enterBackgroundsLoaded()
                        }
                    })
                } else {
                    for object in allObjects {
                        HAConstants.totalEnterBackgrounds += 1
                        let enterBackground = object as! PFObject
                        var number = NSNumber(int: 1)
                        if HAConstants.enterBackgroundDictionary[enterBackground.valueForKey("screenName") as! String] != nil {
                            number = NSNumber(int:HAConstants.enterBackgroundDictionary[enterBackground.valueForKey("screenName") as! String] as! Int + 1)
                        }
                        HAConstants.enterBackgroundDictionary[enterBackground.valueForKey("screenName") as! String] = number
                        
                        if (number.integerValue > HAConstants.maxBackgroundEntries) {
                            HAConstants.maxBackgroundEntries = number.integerValue
                        }
                    }
                    
                    HANavigationController.sharedInstance!.enterBackgroundsLoaded()
                }
            }
        }
    }
    
    func loadScreenLoads() {
        let allObjects = NSMutableArray()
        let limit = 1000
        var skip = 0
        let query = PFQuery(className: "ScreenLoadEvent")
        query.limit = limit
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                allObjects.addObjectsFromArray(objects!)
                if objects!.count == limit {
                    skip += limit
                    query.skip = skip
                    query.findObjectsInBackgroundWithBlock({ (newObjects: [PFObject]?, newError: NSError?) -> Void in
                        if newError == nil {
                            allObjects.addObjectsFromArray(newObjects!)
                            
                            for object in allObjects {
                                HAConstants.totalScreenLoads += 1
                                let screenLoad = object as! PFObject
                                var number = NSNumber(int: 1)
                                if HAConstants.screenLoadDictionary[screenLoad.valueForKey("screenName") as! String] != nil {
                                    number = NSNumber(int:HAConstants.screenLoadDictionary[screenLoad.valueForKey("screenName") as! String] as! Int + 1)
                                }
                                HAConstants.screenLoadDictionary[screenLoad.valueForKey("screenName") as! String] = number
                                
                                if (number.integerValue > HAConstants.maxScreenLoads) {
                                    HAConstants.maxScreenLoads = number.integerValue
                                }
                            }
                            
                            HANavigationController.sharedInstance!.screenLoadsLoaded()
                        }
                    })
                } else {
                    for object in allObjects {
                        HAConstants.totalScreenLoads += 1
                        let screenLoad = object as! PFObject
                        var number = NSNumber(int: 1)
                        if HAConstants.screenLoadDictionary[screenLoad.valueForKey("screenName") as! String] != nil {
                            number = NSNumber(int:HAConstants.screenLoadDictionary[screenLoad.valueForKey("screenName") as! String] as! Int + 1)
                        }
                        HAConstants.screenLoadDictionary[screenLoad.valueForKey("screenName") as! String] = number
                        
                        if (number.integerValue > HAConstants.maxScreenLoads) {
                            HAConstants.maxScreenLoads = number.integerValue
                        }
                    }
                    
                    HANavigationController.sharedInstance!.screenLoadsLoaded()
                }
            }
        }
    }
    
    func loadSpecialEvents() {
        let allObjects = NSMutableArray()
        let limit = 1000
        var skip = 0
        let query = PFQuery(className: "SpecialEvent")
        query.limit = limit
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                allObjects.addObjectsFromArray(objects!)
                if objects!.count == limit {
                    skip += limit
                    query.skip = skip
                    query.findObjectsInBackgroundWithBlock({ (newObjects: [PFObject]?, newError: NSError?) -> Void in
                        if newError == nil {
                            allObjects.addObjectsFromArray(newObjects!)
                            
                            for object in allObjects {
                                HAConstants.totalSpecialEvents += 1
                                let specialEvent = object as! PFObject
                                var number = NSNumber(int: 1)
                                if HAConstants.specialEventDictionary[specialEvent.valueForKey("eventName") as! String] != nil {
                                    number = NSNumber(int:HAConstants.specialEventDictionary[specialEvent.valueForKey("eventName") as! String] as! Int + 1)
                                }
                                HAConstants.specialEventDictionary[specialEvent.valueForKey("eventName") as! String] = number
                                
                                if (number.integerValue > HAConstants.maxSpecialEvents) {
                                    HAConstants.maxSpecialEvents = number.integerValue
                                }
                            }
                            
                            HANavigationController.sharedInstance!.specialEventsLoaded()
                        }
                    })
                } else {
                    for object in allObjects {
                        HAConstants.totalSpecialEvents += 1
                        let specialEvent = object as! PFObject
                        var number = NSNumber(int: 1)
                        if HAConstants.specialEventDictionary[specialEvent.valueForKey("eventName") as! String] != nil {
                            number = NSNumber(int:HAConstants.specialEventDictionary[specialEvent.valueForKey("eventName") as! String] as! Int + 1)
                        }
                        HAConstants.specialEventDictionary[specialEvent.valueForKey("eventName") as! String] = number
                        
                        if (number.integerValue > HAConstants.maxSpecialEvents) {
                            HAConstants.maxSpecialEvents = number.integerValue
                        }
                    }
                    
                    HANavigationController.sharedInstance!.specialEventsLoaded()
                }
            }
        }
    }
    
    func loadTapEvents() {
        let allObjects = NSMutableArray()
        let limit = 1000
        var skip = 0
        let query = PFQuery(className: "TapEvent")
        query.limit = limit
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                allObjects.addObjectsFromArray(objects!)
                if objects!.count == limit {
                    skip += limit
                    query.skip = skip
                    query.findObjectsInBackgroundWithBlock({ (newObjects: [PFObject]?, newError: NSError?) -> Void in
                        if newError == nil {
                            allObjects.addObjectsFromArray(newObjects!)
                            
                            for object in allObjects {
                                HAConstants.totalTapEvents += 1
                                let tapEvent = object as! PFObject
                                if tapEvent.valueForKey("screenName") == nil {
                                    continue
                                }
                                //var number = NSNumber(int: 1)
                                if HAConstants.tapEventDictionary[tapEvent.valueForKey("screenName") as! String] == nil {
                                    let array:[(xPos: Double, yPos: Double)]? = []
                                    HAConstants.tapEventDictionary[tapEvent.valueForKey("screenName") as! String] = array
                                }
                                let positionTouple = (xPos: (tapEvent.valueForKey("xPos") as! NSNumber).doubleValue, yPos: (tapEvent.valueForKey("yPos") as! NSNumber).doubleValue)
                                (HAConstants.tapEventDictionary[tapEvent.valueForKey("screenName") as! String])!!.append(positionTouple)
                            }
                            
                            HANavigationController.sharedInstance!.tapsLoaded()
                        }
                    })
                } else {
                    for object in allObjects {
                        HAConstants.totalTapEvents += 1
                        let tapEvent = object as! PFObject
                        if tapEvent.valueForKey("screenName") == nil {
                            continue
                        }
                        //var number = NSNumber(int: 1)
                        if HAConstants.tapEventDictionary[tapEvent.valueForKey("screenName") as! String] == nil {
                            let array:[(xPos: Double, yPos: Double)]? = []
                            HAConstants.tapEventDictionary[tapEvent.valueForKey("screenName") as! String] = array
                        }
                        let positionTouple = (xPos: (tapEvent.valueForKey("xPos") as! NSNumber).doubleValue, yPos: (tapEvent.valueForKey("yPos") as! NSNumber).doubleValue)
                        (HAConstants.tapEventDictionary[tapEvent.valueForKey("screenName") as! String])!!.append(positionTouple)
                    }
                    
                    HANavigationController.sharedInstance!.tapsLoaded()
                }
            }
        }
    }
}

