//
//  ViewController.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 8/16/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    var pageCaptions: NSArray!

    
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pageTitles = NSArray(objects: "Snap", "Sell", "Save")
        self.pageImages = NSArray(objects: "template3.png", "template1.png", "template2.png")
        self.pageCaptions = NSArray(objects: "Take a picture of your item", "Post your item to timeline", "Get contacted by buyers")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        var startVC = self.viewControllerAtIndex(0) as PageContentViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.height - 60)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        let image = UIImage(named: "mosaicImage5.png")
        let size = CGSizeApplyAffineTransform(image!.size, CGAffineTransformMakeScale(0.5, 0.5))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image!.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageView = UIImageView(image: scaledImage)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        var controller = UIImageView()
        controller.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        controller.backgroundColor = UIColor(red: (255/255.0), green: (81/255.0), blue: (47/255.0), alpha: 0.95)
        self.view.insertSubview(imageView, belowSubview: signInButton)
        self.view.insertSubview(controller, aboveSubview: imageView)
        
        var bottomLine2 = CALayer()
        bottomLine2.frame = CGRectMake(self.view.frame.width/2, 0, 1.0, signInButton.frame.height)
        bottomLine2.backgroundColor = UIColor.whiteColor().CGColor
        //signInButton.borderStyle = UITextBorderStyle.None
        signInButton.layer.addSublayer(bottomLine2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController {
        
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return PageContentViewController()
        }
        
        var vc: PageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentController") as! PageContentViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.titleText = self.pageTitles[index] as! String
        vc.titleCaption = self.pageCaptions[index] as! String
        vc.pageIndex = index
        
        return vc
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! PageContentViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! PageContentViewController
        var index = vc.pageIndex as Int
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if index == self.pageTitles.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction func signIn(sender: AnyObject) {
    }
    
    @IBAction func signUp(sender: AnyObject) {
    }


}
