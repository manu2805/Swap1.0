//
//  TimelineSwiftViewController.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 7/24/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit

class FirstExampleVC: UIViewController, UISearchBarDelegate {
    
    var searchBar = UISearchBar()
    var searchBarButtonItem: UIBarButtonItem?
    var searchString: String?
    var swiftPagesView = SwiftPages(frame: CGRectMake(0, 0, 0, 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.setHidesBackButton(true, animated: true)
        //self.navigationController?.navigationBarHidden = true
        //Instantiation and the setting of the size and position
        //let swiftPagesView : SwiftPages!
        swiftPagesView = SwiftPages(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        //Initiation
        var VCIDs : [String] = ["FirstVC", "SecondVC", "ThirdVC", "FourthVC", "FifthVC"]
        var buttonImages : [UIImage] = [UIImage(named:"HomeIcon.png")!,
            UIImage(named:"LocationIcon.png")!,
            UIImage(named:"CollectionIcon.png")!,
            UIImage(named:"ListIcon.png")!,
            UIImage(named:"StarIcon.png")!]
        
        //Sample customization
        swiftPagesView.initializeWithVCIDsArrayAndButtonImagesArray(VCIDs, buttonImagesArray: buttonImages)
        swiftPagesView.setTopBarBackground(UIColor(red: 244/255, green: 164/255, blue: 96/255, alpha: 1.0))
        //swiftPagesView.setAnimatedBarColor(UIColor(red: 255/255, green: 250/255, blue: 205/255, alpha: 1.0))
                
        self.view.addSubview(swiftPagesView)
        
       /* searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchTapped")
        self.navigationItem.setRightBarButtonItem(searchBarButtonItem, animated: true) */
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logoutButtonTapped() {
        println("logOutButtonTapAction")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    /*func searchTapped() {
        var cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelTapped")
        searchBar.alpha = 0
        self.navigationItem.titleView = searchBar
        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        self.navigationItem.setRightBarButtonItem(cancelButton, animated: true)
        UIView.animateWithDuration(0.5, animations: {
            self.searchBar.alpha = 1
            }, completion: { finished in
                self.searchBar.becomeFirstResponder()
        })
    }
    
    func cancelTapped() {
        searchBar.resignFirstResponder()
        hideSearchBar()
    }
    
    func hideSearchBar() {
        self.navigationItem.setRightBarButtonItem(searchBarButtonItem, animated: true)
        UIView.animateWithDuration(0.3, animations: {
            self.navigationItem.titleView = nil
            }, completion: { finished in
        })
    }
    
   func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchString = searchBar.text!
        let searchArray = searchString?.componentsSeparatedByString(" ")
        for element in searchArray! {
                println(element)
            }
        mainLayerClient.searchString = searchString
        viewDidAppear(true)
        cancelTapped()
    } */
    
}
