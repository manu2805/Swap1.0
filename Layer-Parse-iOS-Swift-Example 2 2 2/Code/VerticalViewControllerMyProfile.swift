//
//  VerticalViewControllerMyProfile.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 7/28/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit

class VerticalViewControllerMyProfile: UIViewController, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagesForSection0: [UIImage] = []
    var timelineImages = [PFObject]()
    
    @IBOutlet weak var thrashImage: UIImageView!
    @IBOutlet weak var deleteLabel: UILabel!
    
    //Setup for pull to refresh UIRefreshControl
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh", forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RAReorderableLayout"
        let nib = UINib(nibName: "verticalCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.addSubview(self.refreshControl)
        self.navigationItem.title = "My Items"
        self.navigationController?.hidesBarsOnSwipe = true
        
        configureNavigationBar()
        
        thrashImage.image = UIImage(named: "thrash.jpg")
        deleteLabel.text = "Double tap to delete"
        let tabItems = self.tabBarController?.tabBar.items as! [UITabBarItem]
        let tabItem  = tabItems[2] as UITabBarItem
        tabItem.title = "Me"
        
        self.view.insertSubview(thrashImage, aboveSubview: self.collectionView)
        self.view.insertSubview(deleteLabel, aboveSubview: self.collectionView)
    
    }
    
    override func viewDidAppear(animated: Bool) {
        loadImages()
        if self.timelineImages.count > 4 {
            self.thrashImage.hidden = true
            self.deleteLabel.hidden = true
        } else {
            self.thrashImage.hidden = false
            self.deleteLabel.hidden = false
        }
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 239/255, green: 76/255, blue: 42/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 30)!,NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0)
    }
    
    // RAReorderableLayout delegate datasource
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let threePiecesWidth = floor(screenWidth / 3.0 - 1.0)
        return CGSizeMake(threePiecesWidth, threePiecesWidth)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 2.0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.timelineImages.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        

        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath) as! RACollectionViewCell
        var image: UIImage?
        cell.imageView.image = nil
        let topImage = self.timelineImages[indexPath.item]
        cell.imageView.file = topImage["imageFile"] as? PFFile
        cell.imageView.loadInBackground()
        cell.imageView.userInteractionEnabled = true
        var tap = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        cell.userInteractionEnabled = true
        return cell
    }
    
    func showNoItemLabel() {
        var barHeight = self.navigationController?.navigationBar.frame.height
        var label = UILabel(frame: CGRectMake(0, barHeight! + 20, self.view.frame.width, 40))
        label.textAlignment = NSTextAlignment.Center
        label.text = "You currently have no items"
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.grayColor()
        self.view.addSubview(label)
        label.alpha = 0
        
        UIView.animateWithDuration(2.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: nil, animations: {
            
            label.center = CGPoint(x: self.view.frame.width/2, y: 40 + 40)
            label.alpha = 1.0
            
            }, completion: nil)
        
        delay(8.0, closure: { () -> () in
            label.hidden = true
        })
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func collectionView(collectionView: UICollectionView, allowMoveAtIndexPath indexPath: NSIndexPath) -> Bool {
        if collectionView.numberOfItemsInSection(indexPath.section) <= 1 {
            return false
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath: NSIndexPath) {
        var photo: UIImage
        
        photo = self.imagesForSection0.removeAtIndex(atIndexPath.item)
        
        self.imagesForSection0.insert(photo, atIndex: toIndexPath.item)
        
    }
    
    func scrollTrigerEdgeInsetsInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
    }
    
    func collectionView(collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
        return 0
    }
    
    func scrollTrigerPaddingInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.collectionView.contentInset.top, 0, self.collectionView.contentInset.bottom, 0)
    }
    
    func loadImages() {
        var query = PFQuery(className: "Photos")
        if let user = PFUser.currentUser() {
            query.whereKey("user", equalTo: user)
        }
        //query.fromLocalDatastore()
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error:NSError?) -> Void in
            if error == nil {
                if objects!.count == 0 {
                    self.showNoItemLabel()
                }
                self.timelineImages.removeAll(keepCapacity: false)
                self.timelineImages = objects as! [PFObject]
                if self.timelineImages.count > 4 {
                    self.thrashImage.hidden = true
                    self.deleteLabel.hidden = true
                }
                self.collectionView.reloadData()
            }
        }
        
    }
    
    func handleRefresh() {
        //loadImages()
        refreshControl.endRefreshing()
    }
    
    func imageTapped(sender: UISwipeGestureRecognizer) {
        let optionMenu = UIAlertController(title: nil, message: "Confirm", preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (alert: UIAlertAction!) -> Void in
            let cell = sender.view as! UICollectionViewCell
            let i = self.collectionView.indexPathForCell(cell)!.item
            let deleteImage = self.timelineImages[i].objectId!
            println(deleteImage)
            let chosenImage = PFObject(withoutDataWithClassName: "Photos", objectId: deleteImage)
            chosenImage.deleteInBackgroundWithBlock(nil)
            self.timelineImages.removeAtIndex(i)
            self.collectionView.reloadData()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        }
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
}