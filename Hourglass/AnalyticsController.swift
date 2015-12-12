//
//  AnalyticsController.swift
//  Hourglass
//
//  Created by Patrick Bradshaw on 12/10/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import Foundation

/**
 * Class: Analytics Controller
 *
 * Purpose:
 ** Handle all communication between the local application and the Analytics database on Parse
 *
 * Logged Events:
 ** 1. Screen Load Event
 ** 2. Tap Event
 ** 3. Button Press Event
 ** 4. Enter Background Event
 *
 * Additional Notes
 ** Crash reporting is handled via the primary Parse database, so these events are not logged
 **/
class AnalyticsController {
    // MARK: Singleton Implementation
    //// Access via AnalyticsControler.sharedController
    static let sharedController = AnalyticsController()
    
    // MARK: Private Variables
    // Any private variables we need to track things for analytics
    var userName : String
    var topViewController : AnalyticsViewController?
    
    // MARK: Initialization function
    init() {
        userName = "Unknown"
    }
    
    // MARK: Helper Functions
    static func registerTopViewController(vc : AnalyticsViewController) {
        AnalyticsController.sharedController.topViewController = vc
    }
    
    static func hasTopViewController() -> Bool {
        return (AnalyticsController.sharedController.topViewController != nil)
    }
    
    static func getTopViewController() -> AnalyticsViewController? {
        return AnalyticsController.sharedController.topViewController
    }
    
    // MARK: Log Functions
    // Log any time a screen is loaded
    static func logScreenLoad(screen : String) {
        // First lets get the time that we can use to calculate time spent on each page
        let time = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        // Send the data to Parse to be recompiled into a logged event
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/functions/logScreenLoadEvent")!)
        request.setValue("4EwiEl7KOjoDVG8YFiLZxiy4EunB5lrsJQc63yz2", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("xZPc6ujTypgTXV0lnd72EW7MLEU9V0f0D6SVNrQG", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let params = ["time":timeFormatter.stringFromDate(time), "userName":AnalyticsController.sharedController.userName, "screenName":screen]
        var error: NSError?
        request.HTTPMethod = "POST"
        var dataSTR = NSString(data: NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &error)!, encoding: NSUTF8StringEncoding)
        request.HTTPBody = dataSTR?.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            // Done
            println(error)
        })
    }
    
    // Log any screen tap that does not have outside implications
    static func logTapEvent(screen : String, xPos : Int, yPos : Int) {
        // First lets get the time that we can use to calculate time spent on each page
        let time = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        // Send the data to Parse to be recompiled into a logged event
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
            println(error)
        })
    }
    
    // Log any button that is pressed
    static func logButtonPress(buttonIdentifier : String) {
        // First lets get the time that we can use to calculate time spent on each page
        let time = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        // Send the data to Parse to be recompiled into a logged event
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/functions/logButtonPressEvent")!)
        request.setValue("4EwiEl7KOjoDVG8YFiLZxiy4EunB5lrsJQc63yz2", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("xZPc6ujTypgTXV0lnd72EW7MLEU9V0f0D6SVNrQG", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let params = ["time":timeFormatter.stringFromDate(time), "userName":AnalyticsController.sharedController.userName, "screenName":AnalyticsController.sharedController.topViewController!.screenName, "buttonIdentifier":buttonIdentifier]
        var error: NSError?
        request.HTTPMethod = "POST"
        var dataSTR = NSString(data: NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &error)!, encoding: NSUTF8StringEncoding)
        request.HTTPBody = dataSTR?.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            // Done
            println(error)
        })
    }
    
    // Log any time the app enters the background
    static func logEnterBackground() {
        // First lets get the time that we can use to calculate time spent on each page
        let time = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        // Send the data to Parse to be recompiled into a logged event
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/functions/logEnterBackgroundEvent")!)
        request.setValue("4EwiEl7KOjoDVG8YFiLZxiy4EunB5lrsJQc63yz2", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("xZPc6ujTypgTXV0lnd72EW7MLEU9V0f0D6SVNrQG", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let params = ["time":timeFormatter.stringFromDate(time), "userName":AnalyticsController.sharedController.userName, "screenName":AnalyticsController.sharedController.topViewController!.screenName]
        var error: NSError?
        request.HTTPMethod = "POST"
        var dataSTR = NSString(data: NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &error)!, encoding: NSUTF8StringEncoding)
        request.HTTPBody = dataSTR?.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            // Done
            println(error)
        })
    }
    
}