//
//  InitialViewController.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 8/16/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

   
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var bkImageView: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var titleCaption: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.bkImageView.image = UIImage(named: imageFile!)
        self.heading.text = self.titleText
        self.caption.text = self.titleCaption
        self.heading.alpha = 0.1
        self.heading.alpha = 0.1
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.heading.alpha = 1.0
            self.caption.alpha = 1.0
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.bkImageView.image = nil
        self.bkImageView.image = UIImage(named: imageFile!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
