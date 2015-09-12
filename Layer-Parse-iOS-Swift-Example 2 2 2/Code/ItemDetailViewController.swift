//
//  ItemDetailViewController.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 8/1/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit
import MessageUI

class ItemDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    //@IBOutlet weak var itemDetailView: PFImageView!
    var item: PFObject?
    var imageFileLoad: PFFile?
    var itemToDisplay: UIImage?
    var tmp: String?
    var allBuyers: NSMutableArray = []
    
    @IBOutlet weak var itemDetailView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    
    @IBOutlet weak var contactSellerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser()?.objectId == (item!.objectForKey("user")?.objectId) {
            contactSellerButton.enabled = false
            contactSellerButton.backgroundColor = UIColor.grayColor()
        }
        var image = UIImage(named: "backButton.png")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        var imageRight = UIImage(named: "alert.png")
        
        imageRight = imageRight?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageRight, style: UIBarButtonItemStyle.Plain, target: self, action: "showEmail")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        let reachability = Reachability.reachabilityForInternetConnection()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        
        reachability.startNotifier()
    }

    override func viewDidAppear(animated: Bool) {
        itemDetailView.image = nil
        itemDetailView.image = itemToDisplay
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

        }
    }

    
    func goBack() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        var findUser = PFUser.query()
        let val = item!.objectForKey("user")?.objectId
        findUser?.whereKey("objectId", equalTo: val!!)
        
        let title: String = item!.objectForKey("Title") as! String
        let price: Int = item!.objectForKey("Price") as! Int
        let description: String = item!.objectForKey("imageCaption") as! String
        //self.allBuyers = item?.objectForKey("Buyers") as! NSMutableArray
        
        
        //findUser?.fromLocalDatastore()
        findUser?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let users: [PFUser] = objects as? [PFUser] where users.count > 0 {
                    let userToMessage: PFUser = users.last!
                    userToStartConversation.user = userToMessage
                    
                }
                self.itemTitle.text = title
                self.itemPrice.text = "$\(price)"
                self.itemDescription.text = description
                
            }
        })
        
        contactSellerButton.layer.cornerRadius = 23
        contactSellerButton.layer.borderWidth = 1
        contactSellerButton.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func contactSeller(sender: AnyObject) {
        /*let val = (item!.objectForKey("user")?.username!)!
        //PFUser.currentUser()?.setObject(["Doug", "Manu", "Tom", "Tim"], forKey: "Contacts")
        var contacts: AnyObject? = PFUser.currentUser()?.objectForKey("Contacts")
        let finalContacts = JSON(contacts!)
        for index in 0...finalContacts.count {
            let tmp = finalContacts[index]
            if tmp == val {
        } */
    
        self.contactSellerButton.backgroundColor = UIColor.grayColor()
        self.contactSellerButton.setTitle("Contacted!", forState: .Normal)
        var hold = self.tabBarController?.viewControllers?.last as! UINavigationController
        if hold.topViewController is ConversationListViewController {
            var svc = hold.topViewController as! ConversationListViewController
            svc.tmp = "nice"
            svc.testing()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func showEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["goswapcontactuiuc@gmail.com"])
        mailComposerVC.setSubject("Inappropriate image")
        mailComposerVC.setMessageBody("The item with title '\(itemTitle.text!)' is offensive. Please look into it", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could not send Email", message: "Error man", delegate: self, cancelButtonTitle: nil)
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
