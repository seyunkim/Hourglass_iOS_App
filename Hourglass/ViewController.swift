//
//  ViewController.swift
//  Hourglass
//
//  Created by Seyun Kim on 9/1/15.
//  Copyright (c) 2015 Seyun Kim. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    let tapRec = UITapGestureRecognizer();
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRec.addTarget(self, action: "tappedView:")
        self.view.addGestureRecognizer(tapRec)
        self.view.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tappedView(tgr : UITapGestureRecognizer){
        var touchPoint : CGPoint = tgr.locationInView(self.view)
        AnalyticsController.logTapEvent("TestScreen", xPos: Int(touchPoint.x), yPos: Int(touchPoint.y))
    }

}

