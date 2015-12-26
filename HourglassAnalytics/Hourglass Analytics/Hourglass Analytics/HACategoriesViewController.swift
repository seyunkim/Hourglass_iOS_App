//
//  HACategoriesViewController.swift
//  Hourglass Analytics
//
//  Created by Patrick Bradshaw on 12/23/15.
//  Copyright © 2015 Patrick Bradshaw. All rights reserved.
//

import UIKit

class HACategoriesViewController : UICollectionViewController , UICollectionViewDelegateFlowLayout {
    let categoryArray = ["Ambiance", "Breakfast", "Trending", "Food Truck", "Critic", "Romantic"]
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        
        self.collectionView?.delegate = self
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView?.setCollectionViewLayout(flowLayout, animated: true)
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        
        var set = false
        var index = indexPath.row
        while index > categoryArray.count - 1 {
            index -= categoryArray.count
        }
        for view in cell.subviews {
            if let label = view as? UILabel {
                label.text = categoryArray[index]
                label.tag = index
                set = true
                break
            }
        }
        if !set {
            cell.backgroundColor = UIColor.whiteColor()
            
            let label = UILabel()
            label.text = categoryArray[index]
            label.tag = index
            var newFrame = cell.frame
            newFrame.origin.x = 0
            newFrame.origin.y = 0
            label.frame = newFrame
            label.userInteractionEnabled = true
            cell.addSubview(label)
            
            let imageTap = UITapGestureRecognizer()
            imageTap.addTarget(self, action: "imageTapped:")
            label.addGestureRecognizer(imageTap)
        }
        
        if HAConstants.buttonTapDictionary.objectForKey("Category: " + categoryArray[indexPath.row]) != nil {
            let percentage = (HAConstants.buttonTapDictionary.objectForKey("Category: " + categoryArray[indexPath.row]) as! NSNumber).doubleValue / (NSNumber(integer:HAConstants.maxButtonTaps).doubleValue * 1.0)
            cell.backgroundColor = HAConstants.colorForPercentage(percentage)
        }
        
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(0)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(0)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width/2), height: (self.view.frame.width/2))
    }
    
    func imageTapped(sender: UITapGestureRecognizer) {
        // respond to tap for the index (sender.view.tag)
        
    }
    
    // MARK: Analytics Functions
    func reloadButtons() {
        collectionView?.reloadData()
    }
    
    func reloadScreenBackgrounds() {
    }
    
    func reloadTaps() {
    }
}