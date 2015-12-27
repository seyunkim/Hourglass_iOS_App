//
//  HAConstants.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HAConstants {
    static let logoColor = UIColor(red: 208.0 / 255.0, green: 76.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
    static let navBarHeight = CGFloat(44.0)
    
    static var maxButtonTaps = 0
    static var maxBackgroundEntries = 0
    static var maxScreenLoads = 0
    static var maxSpecialEvents = 0
    static var maxTapEvents = 0
    
    static var totalButtonTaps = 0
    static var totalEnterBackgrounds = 0
    static var totalScreenLoads = 0
    static var totalSpecialEvents = 0
    static var totalTapEvents = 0
    
    static var buttonTapDictionary = NSMutableDictionary()
    static var enterBackgroundDictionary = NSMutableDictionary()
    static var screenLoadDictionary = NSMutableDictionary()
    static var specialEventDictionary = NSMutableDictionary()
    static var tapEventDictionary : [String: [(xPos: Double, yPos: Double)]?] = [String: [(xPos: Double, yPos: Double)]?]()
    
    static func colorForPercentage(percentage: Double) -> UIColor {
        if percentage < 0.1 {
            // Lightest Blue
            return UIColor(red: 175.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        } else if percentage < 0.25 {
            // Light Blue
            return UIColor(red: 72.0/255.0, green: 209.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        } else if percentage < 0.5 {
            // Blue
            return UIColor(red: 65.0/255.0, green: 105.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        } else if percentage < 0.75 {
            // Dark Blue
            return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        } else if percentage <= 1.0 {
            // Darkest Blue
            return UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 112.0/255.0, alpha: 1.0)
        }
        return UIColor.whiteColor()
    }
    
    static func tapColorForPercentage(percentage: Double) -> UIColor {
        if percentage < 0.05 {
            // Clear
            return UIColor.clearColor()
        } else if percentage < 0.2 {
            // Dark Green
            return UIColor(red: 0.0, green: 100.0/255.0, blue: 0.0, alpha: 1.0)
        } else if percentage < 0.4 {
            // Light Green
            return UIColor.greenColor()
        } else if percentage < 0.5 {
            // Yellow
            return UIColor.yellowColor()
        } else if percentage < 0.75 {
            // Orange
            return UIColor.orangeColor()
        } else if percentage <= 1.0 {
            // Red
            return UIColor.redColor()
        }
        return UIColor.clearColor()
    }
}