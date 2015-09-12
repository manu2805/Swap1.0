//
//  VerticalViewController.swift
//  RAReorderableLayout-Demo
//
//  Created by Ryo Aoyama on 11/17/14.
//  Copyright (c) 2014 Ryo Aoyama. All rights reserved.
//

import UIKit

extension String {
    func filter(pred: Character -> Bool) -> String {
        var res = String()
        for c in self {
            if (pred(c)) {
                res.append(c)
            }
        }
        return res
    }
}

class VerticalViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, RAReorderableLayoutDataSource, RAReorderableLayoutDelegate, LYRQueryControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    
    var imagesForSection0: [UIImage] = []
    var timelineImages = [PFObject]()
    var categoryImages = [PFObject]()
    var currentSwapUser: AnyObject?
    
    
    var rightButton: UIBarButtonItem?
    var searchBar = UISearchBar()
    var searchString: String?
    var chosenCell: Int?
    var lastContentOffset: CGFloat?
    var lastPage:CGFloat = 0.0
    var queryController: LYRQueryController!
    var categoryFlag = false
    
    
    @IBOutlet weak var activityControl: UIActivityIndicatorView!
    //Page Control
    var pageControl : UIPageControl?
    var heightCollection: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityControl.startAnimating()
        self.title = "RAReorderableLayout"
        let nib = UINib(nibName: "verticalCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.navigationItem.title = "Swap"
        
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        loadImages()
        
        let tabItems = self.tabBarController?.tabBar.items as! [UITabBarItem]
        let tabItem0 = tabItems[0] as UITabBarItem
        let tabItem2 = tabItems[2] as UITabBarItem
        tabItem0.title = "Buy"
        tabItem2.title = "Me"
        
        //Setting up page control
        configurePageControl()
        
        //Configure the navigation bar
        configureNavigationBar()
        
        initializeScrollView()
        self.collectionView.addSubview(self.categoryScrollView)
        
        let reachability = Reachability.reachabilityForInternetConnection()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        
        reachability.startNotifier()
        
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                println("Reachable via WiFi")
            } else {
                println("Reachable via Cellular")
            }
        } else {
            //var alert = UIAlertView(title: "Error",message: "No internet connection detected", delegate: self, cancelButtonTitle: "OK")
            //alert.show()
            super.viewDidLoad()
            var barHeight = self.navigationController?.navigationBar.frame.height
            var label = UILabel(frame: CGRectMake(0, barHeight! + 20, self.view.frame.width, 40))
            label.textAlignment = NSTextAlignment.Center
            label.text = "No Network Connection"
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
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func configurePageControl() {
        //pageControl = UIPageControl(frame: CGRectMake(86, 255, 200, 20)
        pageControl = UIPageControl(frame: CGRectMake(86, 255, self.view.frame.width/2, self.view.frame.height / 30))
        self.pageControl!.numberOfPages = 7
        self.pageControl!.currentPage = 0
        self.pageControl!.tintColor = UIColor.redColor()
        self.pageControl!.pageIndicatorTintColor = UIColor.grayColor()
        self.pageControl!.currentPageIndicatorTintColor = UIColor.whiteColor()
        self.pageControl!.backgroundColor = UIColor.clearColor()
        self.view.addSubview(pageControl!)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 239/255, green: 76/255, blue: 42/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ArialMT", size: 34)!,NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func initializeScrollView() {
        var barHeight = self.navigationController?.navigationBar.frame.height
        var scrollHeight: CGFloat?
        var firstImageHeight: CGFloat?
        self.categoryScrollView.delegate = self
        println(self.view.frame.width)
        if self.view.frame.width == 320 {
            scrollHeight = 212
            firstImageHeight = scrollHeight! - 12
        } else if self.view.frame.width == 414 {
            scrollHeight = 154
            firstImageHeight = scrollHeight! - 18
        }
        else {
            scrollHeight = 180
            firstImageHeight = scrollHeight! - 16
        }
        if barHeight != nil {
            self.categoryScrollView.frame = CGRectMake(0, barHeight!, self.view.frame.width, scrollHeight!)
        }
        let scrollViewHeight = self.categoryScrollView.frame.height
        let scrollViewWidth = self.categoryScrollView.frame.width
        self.heightCollection = scrollViewHeight + barHeight!
        var imageZero = UIImageView(frame: CGRectMake(0, barHeight!, scrollViewWidth, firstImageHeight!))
        var imageOne = UIImageView(frame: CGRectMake(scrollViewWidth, barHeight!, scrollViewWidth, scrollViewHeight))
        var imageTwo = UIImageView(frame: CGRectMake(scrollViewWidth*2, barHeight!, scrollViewWidth, scrollViewHeight))
        var imageThree = UIImageView(frame: CGRectMake(scrollViewWidth*3, barHeight!, scrollViewWidth, scrollViewHeight))
        var imageFour = UIImageView(frame: CGRectMake(scrollViewWidth*4, barHeight!, scrollViewWidth, scrollViewHeight))
        var imageFive = UIImageView(frame: CGRectMake(scrollViewWidth*5, barHeight!, scrollViewWidth, scrollViewHeight))
        var imageSix = UIImageView(frame: CGRectMake(scrollViewWidth*6, barHeight!, scrollViewWidth, scrollViewHeight))
        
        imageZero.image = UIImage(named: "collage.jpg")
        imageZero.contentMode = .ScaleAspectFill
        imageOne.image = UIImage(named: "books.jpg")
        imageOne.contentMode = .ScaleAspectFill
        imageTwo.image = UIImage(named: "tickets.jpg")
        imageTwo.contentMode = .ScaleAspectFill
        imageThree.image = UIImage(named: "electronics.jpg")
        imageThree.contentMode = .ScaleAspectFill
        imageFour.image = UIImage(named: "mensClothes.jpg")
        imageFour.contentMode = .ScaleAspectFill
        imageFive.image = UIImage(named: "girlsClothes.jpg")
        imageFive.contentMode = .ScaleAspectFill
        imageSix.image = UIImage(named: "randomItems.jpg")
        imageSix.contentMode = .ScaleAspectFill
        
        var label0 = UILabel(frame: CGRectMake(0, 0, 200, 40))
        label0.center = CGPointMake(20, 198)
        label0.textColor = UIColor.whiteColor()
        label0.textAlignment = NSTextAlignment.Center
        label0.text = "All"
        label0.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        imageZero.addSubview(label0)
        
        
        
        var label1 = UILabel(frame: CGRectMake(0, 0, 200, 40))
        label1.center = CGPointMake(42, 195)
        label1.textColor = UIColor.whiteColor()
        label1.textAlignment = NSTextAlignment.Center
        label1.text = "Books"
        label1.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        imageOne.addSubview(label1)
        
        var label2 = UILabel(frame: CGRectMake(scrollViewWidth, 0, 200, 40))
        label2.center = CGPointMake(44, 195)
        label2.textColor = UIColor.whiteColor()
        label2.textAlignment = NSTextAlignment.Center
        label2.text = "Events"
        label2.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        imageTwo.addSubview(label2)
        
        var label3 = UILabel(frame: CGRectMake(scrollViewWidth*2, 0, 200, 40))
        label3.center = CGPointMake(34, 195)
        label3.textColor = UIColor.whiteColor()
        label3.textAlignment = NSTextAlignment.Center
        label3.text = "Tech"
        label3.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        imageThree.addSubview(label3)
        
        var label4 = UILabel(frame: CGRectMake(scrollViewWidth*3, 0, 200, 40))
        label4.center = CGPointMake(32, 195)
        label4.textColor = UIColor.whiteColor()
        label4.textAlignment = NSTextAlignment.Center
        label4.text = "Men"
        label4.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        imageFour.addSubview(label4)
        
        var label5 = UILabel(frame: CGRectMake(scrollViewWidth*4, 0, 200, 40))
        label5.center = CGPointMake(52, 195)
        label5.textColor = UIColor.whiteColor()
        label5.textAlignment = NSTextAlignment.Center
        label5.text = "Women"
        label5.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        imageFive.addSubview(label5)
        
        var label6 = UILabel(frame: CGRectMake(scrollViewWidth*4, 0, 200, 40))
        label6.center = CGPointMake(44, 195)
        label6.textColor = UIColor.whiteColor()
        label6.textAlignment = NSTextAlignment.Center
        label6.text = "Others"
        label6.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        imageSix.addSubview(label6)
        
        self.categoryScrollView.addSubview(imageZero)
        self.categoryScrollView.addSubview(imageOne)
        self.categoryScrollView.addSubview(imageTwo)
        self.categoryScrollView.addSubview(imageThree)
        self.categoryScrollView.addSubview(imageFour)
        self.categoryScrollView.addSubview(imageFive)
        self.categoryScrollView.addSubview(imageSix)
        
        self.categoryScrollView.contentSize = CGSizeMake(self.categoryScrollView.frame.width*7, self.categoryScrollView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var barHeight = self.navigationController?.navigationBar.frame.height
        if scrollView == self.categoryScrollView {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl!.currentPage = Int(pageNumber)
            if pageNumber == 0.0 && lastPage != pageNumber {
                categoryFlag = false
                timelineImages.removeAll(keepCapacity: false)
                loadImages()
            } else if pageNumber == 1.0 && lastPage != pageNumber {
                //timelineImages.removeAll(keepCapacity: false)
                categoryImages.removeAll(keepCapacity: false)
                categoryFlag = true
                queryForSection("Textbooks")
            } else if pageNumber == 2.0 && lastPage != pageNumber {
                categoryImages.removeAll(keepCapacity: false)
                categoryFlag = true
                queryForSection("Tickets")
            } else if pageNumber == 3.0 && lastPage != pageNumber {
                categoryImages.removeAll(keepCapacity: false)
                categoryFlag = true
                queryForSection("Tech")
            } else if pageNumber == 4.0 && lastPage != pageNumber {
                categoryImages.removeAll(keepCapacity: false)
                categoryFlag = true
                queryForSection("Men's Clothing")
            } else if pageNumber == 5.0 && lastPage != pageNumber {
                categoryImages.removeAll(keepCapacity: false)
                categoryFlag = true
                queryForSection("Women's Clothing")
            } else if pageNumber == 6.0 && lastPage != pageNumber {
                categoryImages.removeAll(keepCapacity: false)
                categoryFlag = true
                queryForSection("Other")
            }
            
            lastPage = pageNumber
        }
        var origin = CGPoint(x: 0.0, y: 0.0)
        if scrollView == (self.collectionView as UIScrollView) && scrollView.contentOffset == origin {
            for subview in categoryScrollView.subviews {
                if subview.isMemberOfClass(UIVisualEffectView) {
                    subview.removeFromSuperview()
                }
            }
            pageControl!.hidden = false
            self.categoryScrollView.scrollEnabled = true
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        var scrollVelocity = self.collectionView.panGestureRecognizer.velocityInView(self.collectionView)
        var origin = CGPoint(x: 0.0, y: 0.0)
        var removeViewOrigin = CGPoint(x: 0.0, y: 20.0)
        var tmp = self.categoryScrollView.subviews
        var hold = tmp.last as! UIView
        
        if scrollView == (self.collectionView as UIScrollView) && scrollVelocity.y < 0.0 && scrollView.contentOffset.y <= origin.y {
            var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light)) as UIVisualEffectView
            visualEffectView.frame = self.categoryScrollView.bounds
            categoryScrollView.addSubview(visualEffectView)
            pageControl!.hidden = true
            self.categoryScrollView.scrollEnabled = false
        }
        if scrollView == (self.collectionView as UIScrollView) && scrollVelocity.y < 0.0 && (scrollView.contentOffset.y > origin.y || scrollView.contentOffset.y < origin.y) && !hold.isMemberOfClass(UIVisualEffectView) {
            var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light)) as UIVisualEffectView
            visualEffectView.frame = self.categoryScrollView.bounds
            categoryScrollView.addSubview(visualEffectView)
            pageControl!.hidden = true
            self.categoryScrollView.scrollEnabled = false
        }
        if scrollView == (self.collectionView as UIScrollView) && scrollVelocity.y > 0.0 && scrollView.contentOffset.y == origin.y {
            var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light)) as UIVisualEffectView
            visualEffectView.frame = self.categoryScrollView.bounds
            categoryScrollView.addSubview(visualEffectView)
            pageControl!.hidden = true
            self.categoryScrollView.scrollEnabled = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollVelocity = self.collectionView.panGestureRecognizer.velocityInView(self.collectionView)
        var origin = CGPoint(x: 0.0, y: 0.0)
        var removeViewOrigin = CGPoint(x: 0.0, y: 20.0)
        if scrollView == (self.collectionView as UIScrollView) && scrollVelocity.y > 0.0 && scrollView.contentOffset.y < removeViewOrigin.y && scrollView.contentOffset.y > origin.y {
            for subview in categoryScrollView.subviews {
                if subview.isMemberOfClass(UIVisualEffectView) {
                    subview.removeFromSuperview()
                }
            }
            pageControl!.hidden = false
            self.categoryScrollView.scrollEnabled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        scrollViewDidEndDecelerating(categoryScrollView)
        var query = LYRQuery(queryableClass: LYRConversation.self)
        query.predicate = LYRPredicate(property: "hasUnreadMessages", predicateOperator: LYRPredicateOperator.IsEqualTo, value: true)
        queryController = mainLayerClient.layerClient.queryControllerWithQuery(query)
        self.queryController.delegate = self
        
        var error: NSError?
        var success = queryController.execute(&error)
        if success && queryController.numberOfObjectsInSection(0) != 0 {
            var barHeight = self.navigationController?.navigationBar.frame.height
            var label = UILabel(frame: CGRectMake(0, barHeight! + 20, self.view.frame.width, 40))
            label.textAlignment = NSTextAlignment.Center
            label.text = "\(queryController.numberOfObjectsInSection(0)) unread conversation"
            label.font = UIFont(name: "HelveticaNeue", size: 15)
            label.textColor = UIColor.whiteColor()
            label.backgroundColor = UIColor.blueColor()
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
    }
    
    func queryControllerDidChangeContent(queryController: LYRQueryController!) {
        var barHeight = self.navigationController?.navigationBar.frame.height
        var label = UILabel(frame: CGRectMake(0, barHeight! + 20, self.view.frame.width, 40))
        label.textAlignment = NSTextAlignment.Center
        label.text = "\(queryController.numberOfObjectsInSection(0)) unread conversation"
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.blueColor()
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
    func queryForSection(category: String) {
        for currentItem in timelineImages {
            if currentItem["Category"] as! String == category {
                self.categoryImages.append(currentItem)
            }
        }
        self.collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
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
        return 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(260, 0, 100, 0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryFlag == false {
            return self.timelineImages.count
        } else {
            return self.categoryImages.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath) as! RACollectionViewCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        var image: UIImage?
        cell.imageView.image = nil
        cell.userInteractionEnabled = false
        var topImage: PFObject
        if categoryFlag == false {
            topImage = self.timelineImages[indexPath.item]
        } else {
            topImage = self.categoryImages[indexPath.item]
        }
        cell.imageView.file = topImage["imageFile"] as? PFFile
        cell.imageView.loadInBackground { (image: UIImage?, error: NSError?) -> Void in
            cell.userInteractionEnabled = true
        }
        
        return cell
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        chosenCell = indexPath.item
        performSegueWithIdentifier("showItemDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItemDetail" {
            let itemDetailViewController = segue.destinationViewController as! ItemDetailViewController
            var item: PFObject
            if categoryFlag == false {
                item = timelineImages[chosenCell!]
            } else {
                item = categoryImages[chosenCell!]
            }
            
            itemDetailViewController.item = item
            
            let imageFile = item["imageFile"] as! PFFile
            
            imageFile.getDataInBackgroundWithBlock { (imageData:NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        itemDetailViewController.itemToDisplay = image
                    }
                }
            }
        }
    }
    
    func scrollTrigerPaddingInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.collectionView.contentInset.top, 0, self.collectionView.contentInset.bottom, 0)
    }
    
    func loadImages() {
        var query = PFQuery(className: "Photos")
        query.orderByDescending("createdAt")
        query.cachePolicy = .CacheThenNetwork
        if searchBar.text != "" {
            var temp = searchBar.text.lowercaseString.filter { $0 != Character(" ") }
            query.whereKey("Search", containsString: temp)
        }
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil && objects?.count == 0 {
                var alert = UIAlertView(title: "No Result",message: "No items matching your description were found", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                self.searchBar.text = ""
                println("print")
                return
            }
            if error == nil {
                self.timelineImages.removeAll(keepCapacity: false)
                self.timelineImages = objects as! [PFObject]
                self.collectionView.reloadData()
                self.collectionView.scrollEnabled = true
                self.searchBar.text = ""
            } else {
                if error?.code == 100 {
                    var alert = UIAlertView(title: "No Internet Connection",message: "Make sure your device is connected to the internet", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    query.cancel()
                self.searchBar.text = ""
                }
            }
        }
        
    }
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        showSearchBar()
        self.collectionView.scrollEnabled = false
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = self.view.bounds
        view.addSubview(visualEffectView)
    }
    
    func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButtonItem(nil, animated: true)
        UIView.animateWithDuration(0.5, animations: {
            self.searchBar.alpha = 1
            }, completion: { finished in
                self.searchBar.becomeFirstResponder()
        })
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        rightButton = self.navigationItem.rightBarButtonItem
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
        self.collectionView.scrollEnabled = true
        searchBar.text = ""
        removeEffects()
    }
    
    func hideSearchBar() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem =  rightButton
        UIView.animateWithDuration(0.3, animations: {
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Swap"
            }, completion: { finished in
        })
    }
    
    func removeEffects() {
        for subview in view.subviews {
            if subview.isMemberOfClass(UIVisualEffectView) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.loadImages()
        removeEffects()
        hideSearchBar()
    }
    
}
class RACollectionViewCell: UICollectionViewCell {
    var imageView: PFImageView!
    var color = UIColor.lightGrayColor()
    var gradientLayer: CAGradientLayer?
    var hilightedCover: UIView!
    override var highlighted: Bool {
        didSet {
            self.hilightedCover.hidden = !self.highlighted
        }
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        self.hilightedCover.frame = self.bounds
        self.applyGradation(self.imageView)
    }
    
    private func configure() {
        self.imageView = PFImageView()
        self.imageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.imageView)
        
        self.hilightedCover = UIView()
        self.hilightedCover.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.hilightedCover.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.hilightedCover.hidden = true
        self.addSubview(self.hilightedCover)
    }
    
    private func applyGradation(gradientView: UIView!) {
        self.gradientLayer?.removeFromSuperlayer()
        self.gradientLayer = nil
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer!.frame = gradientView.bounds
        
        let mainColor = UIColor(white: 0, alpha: 0.3).CGColor
        let subColor = UIColor.clearColor().CGColor
        self.gradientLayer!.colors = [subColor, mainColor]
        self.gradientLayer!.locations = [0, 1]
        
        gradientView.layer.addSublayer(self.gradientLayer)
    }
}