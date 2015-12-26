//
//  UIViewExtensions.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/26/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class HAHeatmapView : UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        implementation()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        implementation()
    }
    
    internal func implementation() {
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        opaque = false
    }
    
    func drawHeatMap(screenName: String) {
        if HAConstants.tapEventDictionary[screenName] == nil {
            return
        }
        
        // Build our initial 2D array for every screen position
        let NumColumns = Int(frame.size.width) - 1
        let NumRows = Int(frame.size.height) - 1
        var pixelArray = Array<Array<Int>>()
        for _ in 0...NumColumns {
            pixelArray.append(Array(count:NumRows + 1, repeatedValue:Int(0)))
        }
        
        // Fill out our pixel array
        let radius = Float(15)
        let tapList : [(xPos: Double, yPos: Double)] = HAConstants.tapEventDictionary[screenName]!!
        for tap in tapList {
            for x in 0...NumColumns {
                for y in 0...NumRows {
                    if tap.xPos <= 3 {
                        let xVal = Int(tap.xPos * Double(frame.size.width))
                        let xSquared = Float((xVal - x) * (xVal - x))
                        let yVal = Int(tap.yPos * Double(frame.size.height))
                        let ySquared = Float((yVal - y) * (yVal - y))
                        if sqrt(xSquared + ySquared) <= radius {
                            pixelArray[x][y] += 1
                            if pixelArray[x][y] > HAConstants.maxTapEvents {
                                HAConstants.maxTapEvents = pixelArray[x][y]
                            }
                        }
                    } else {
                        let xVal = Int(tap.xPos)
                        let xSquared = Float((xVal - x) * (xVal - x))
                        let yVal = Int(tap.yPos)
                        let ySquared = Float((yVal - y) * (yVal - y))
                        if sqrt(xSquared + ySquared) <= radius {
                            pixelArray[x][y] += 1
                            if pixelArray[x][y] > HAConstants.maxTapEvents {
                                HAConstants.maxTapEvents = pixelArray[x][y]
                            }
                        }
                    }
                }
            }
        }
        
        // Draw each box using CoreGraphics
        let pageRect = CGRectMake(0, 0, frame.width, frame.height)
        UIGraphicsBeginImageContextWithOptions(pageRect.size, false, 1)
        let context = UIGraphicsGetCurrentContext()
//        CGContextClearRect(context,pageRect)
//        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
//        CGContextFillRect(context, pageRect);
        
        // Draw each tap percentage
        for x in 0...NumColumns {
            for y in 0...NumRows {
                let percentage = NSNumber(integer: pixelArray[x][y]).doubleValue / (NSNumber(integer:HAConstants.maxTapEvents).doubleValue * 1.0)
                let pixelRect = CGRectMake(CGFloat(x), CGFloat(y), 1, 1)
                let color = HAConstants.tapColorForPercentage(percentage)
                if color != UIColor.clearColor() {
                    CGContextSetFillColorWithColor(context, color.CGColor)
                    CGContextFillRect(context, pixelRect)
                    CGContextSaveGState(context)
                }
            }
        }
        
        // End the drawing
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = backgroundImage
    }
}
