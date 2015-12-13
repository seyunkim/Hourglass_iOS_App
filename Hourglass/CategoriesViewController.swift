//
//  CategoriesView.swift
//  Hourglass
//
//  Created by Seyun Kim on 12/12/15.
//  Copyright © 2015 Seyun Kim. All rights reserved.
//

import UIKit

class CategoriesViewController : UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var categoriesView: UICollectionView!
    let imageArray = [UIImage(named:"Ambiance"), UIImage(named: "Breakfast"), UIImage(named: "Trending"),UIImage(named: "FoodTruck"),UIImage(named: "Critic")]
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView?.setCollectionViewLayout(flowLayout, animated: true)
    
    }
   
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        
        var set = false
        var index = indexPath.row
        while index > imageArray.count - 1 {
            index -= imageArray.count
        }
        for view in cell.subviews {
            if let imageView = view as? UIImageView {
                imageView.image = imageArray[index]
                set = true
                break
            }
        }
        if !set {
            let imageView = UIImageView(image: imageArray[index])
            var newFrame = cell.frame
            newFrame.origin.x = 0
            newFrame.origin.y = 0
            imageView.frame = newFrame
            cell.addSubview(imageView)
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

} 