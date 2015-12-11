//
//  AnalyticsController.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/10/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation

class AnalyticsController {
    // Singleton implementation
    //// Access via AnalyticsControler.sharedController
    static let sharedController = AnalyticsController()
    
    // Any private variables we need to track things for analytics
    var userName : String
    var topViewController : AnalyticsViewController?
    
    // Initialization function
    init() {
        userName = "Unknown"
    }
    
    static func registerTopViewController(vc : AnalyticsViewController) {
        AnalyticsController.sharedController.topViewController = vc
    }
    
    static func hasTopViewController() -> Bool {
        return (AnalyticsController.sharedController.topViewController != nil)
    }
    
    static func getTopViewController() -> AnalyticsViewController? {
        return AnalyticsController.sharedController.topViewController
    }
    
    // Serialize any screen tap that does not have outside implications
    static func logTapEvent(screen : String, xPos : Int, yPos : Int) {
        // First lets get the time that we can use to calculate time spent on each page
        let time = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        // Serialize our above data into a string so that we can interpret it within Cloud Code on Parse
        //// Format: var;var;var
        ////// Time
        ////// Username
        ////// Tap Location (X,Y)
        //var serializedString = timeFormatter.stringFromDate(time) + ";"
        //serializedString += userName + ";"
        //serializedString += screen + ";"
        //serializedString += String(xPos) + "," + String(yPos)
        
        // Send the string to Parse to be recompiled into a logged event
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/functions/logTapEvent")!)
        request.setValue("4EwiEl7KOjoDVG8YFiLZxiy4EunB5lrsJQc63yz2", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("xZPc6ujTypgTXV0lnd72EW7MLEU9V0f0D6SVNrQG", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let params = ["time":timeFormatter.stringFromDate(time), "userName":AnalyticsController.sharedController.userName, "screenName":screen, "xPos":xPos, "yPos":yPos]
        var error: NSError?
        request.HTTPMethod = "POST"
        var dataSTR = NSString(data: NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &error)!, encoding: NSUTF8StringEncoding)
        request.HTTPBody = dataSTR?.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            // Done
            print(error)
        })
    }
    
    static func logScreenLoad(screen : String) {
        
    }
    
}