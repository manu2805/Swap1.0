//
//  ForgotPasswordViewController.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 8/15/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var submitEmail: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, emailLabel.frame.height - 1, emailLabel.frame.width, 1.0)
        bottomLine.backgroundColor = UIColor.whiteColor().CGColor
        emailLabel.borderStyle = UITextBorderStyle.None
        emailLabel.attributedPlaceholder = NSAttributedString(string:"Email",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailLabel.layer.addSublayer(bottomLine)
        
        var email = UIImageView()
        var emailImage = UIImage(named: "forgotPasswordEmail.png")
        email.image = emailImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        email.tintColor = UIColor.whiteColor()
        email.frame = CGRectMake(8, 8, 25, 25)
        emailLabel.addSubview(email)
        
        let image = UIImage(named: "mosaicImage5.png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        var controller = UIImageView()
        controller.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        controller.backgroundColor = UIColor(red: (255/255.0), green: (81/255.0), blue: (47/255.0), alpha: 0.95)
        
        submitEmail.layer.cornerRadius = 10
        submitEmail.layer.borderWidth = 1
        submitEmail.layer.borderColor = UIColor.clearColor().CGColor
        
        self.view.insertSubview(imageView, belowSubview: emailLabel)
        self.view.insertSubview(controller, aboveSubview: imageView)
        self.view.insertSubview(submitEmail, belowSubview: emailLabel)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func emailSent(sender: AnyObject) {
        var alertController = UIAlertController(title: "Email Sent", message: "Check your email for a password reset link", preferredStyle: .Alert)
        
        // Create the actions
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
