//
//  TimelineImageViewController.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 7/21/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit

class TimelineImageViewController: UIViewController {
    var layerClient: LYRClient!
    var tmp: String?
    
    @IBOutlet weak var displayLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var title = NSLocalizedString("Logout", comment: "")
        var logoutItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logoutButtonTapped"))
        self.navigationItem.setLeftBarButtonItem(logoutItem, animated: false)
        
        title = NSLocalizedString("Messages", comment: "")
        logoutItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showConversationList"))
        self.navigationItem.setRightBarButtonItem(logoutItem, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func showConversationList() {
        let controller: ConversationListViewController = ConversationListViewController(layerClient: self.layerClient)
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func logoutButtonTapped() {
        println("logOutButtonTapAction")
        
        self.layerClient.deauthenticateWithCompletion { (success: Bool, error: NSError?) in
            if error == nil {
                PFUser.logOut()
                self.navigationController!.popToRootViewControllerAnimated(true)
            } else {
                println("Failed to deauthenticate: \(error)")
            }
        }
    }
}
