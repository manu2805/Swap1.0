//
//  SignUpViewController.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 8/13/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //@IBOutlet weak var usernameLabel: UITextField!
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    var layerClient: LYRClient!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layerClient = mainLayerClient.layerClient

        usernameLabel.delegate = self
        passwordLabel.delegate = self
        emailLabel.delegate = self
        
        var username = UIImageView()
        var usernameImage = UIImage(named: "usernameImage.png")
        username.image = usernameImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        username.tintColor = UIColor.whiteColor()
        username.frame = CGRectMake(8, 8, 25, 25)
        usernameLabel.addSubview(username)
        
        var bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, usernameLabel.frame.height - 1, usernameLabel.frame.width, 1.0)
        bottomLine.backgroundColor = UIColor.whiteColor().CGColor
        usernameLabel.borderStyle = UITextBorderStyle.None
        usernameLabel.attributedPlaceholder = NSAttributedString(string:"Username",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        usernameLabel.layer.addSublayer(bottomLine)
        
        var password = UIImageView()
        var passwordImage = UIImage(named: "passwordImage.png")
        password.image = passwordImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        password.tintColor = UIColor.whiteColor()
        password.frame = CGRectMake(8, 8, 25, 25)
        passwordLabel.addSubview(password)
        
        var bottomLine1 = CALayer()
        bottomLine1.frame = CGRectMake(0.0, passwordLabel.frame.height - 1, passwordLabel.frame.width, 1.0)
        bottomLine1.backgroundColor = UIColor.whiteColor().CGColor
        passwordLabel.borderStyle = UITextBorderStyle.None
        passwordLabel.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordLabel.layer.addSublayer(bottomLine1)
        
        var email = UIImageView()
        var emailImage = UIImage(named: "emailImage.png")
        email.image = emailImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        email.tintColor = UIColor.whiteColor()
        email.frame = CGRectMake(8, 8, 25, 25)
        emailLabel.addSubview(email)
        
        var bottomLine2 = CALayer()
        bottomLine2.frame = CGRectMake(0.0, emailLabel.frame.height - 1, emailLabel.frame.width, 1.0)
        bottomLine2.backgroundColor = UIColor.whiteColor().CGColor
        emailLabel.borderStyle = UITextBorderStyle.None
        emailLabel.attributedPlaceholder = NSAttributedString(string:"Email(@illinois.edu)",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailLabel.layer.addSublayer(bottomLine2)
        
        var password2 = UIImageView()
        var passwordImage2 = UIImage(named: "passwordImage.png")
        password2.image = passwordImage2?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        password2.tintColor = UIColor.whiteColor()
        password2.frame = CGRectMake(8, 8, 25, 25)
        confirmPassword.addSubview(password2)
        
        var bottomLine3 = CALayer()
        bottomLine3.frame = CGRectMake(0.0, confirmPassword.frame.height - 1, confirmPassword.frame.width, 1.0)
        bottomLine3.backgroundColor = UIColor.whiteColor().CGColor
        confirmPassword.borderStyle = UITextBorderStyle.None
        confirmPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        confirmPassword.layer.addSublayer(bottomLine3)
        
        signupButton.layer.cornerRadius = 10
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.clearColor().CGColor
        
        let image = UIImage(named: "mosaicImage5.png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        var controller = UIImageView()
        controller.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        controller.backgroundColor = UIColor(red: (255/255.0), green: (81/255.0), blue: (47/255.0), alpha: 0.95)
        self.view.insertSubview(imageView, belowSubview: usernameLabel)
        self.view.insertSubview(controller, aboveSubview: imageView)
        self.view.insertSubview(dismissButton, aboveSubview: controller)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp() {
        var username = self.usernameLabel.text
        var password = self.passwordLabel.text
        var passwordcheck = self.confirmPassword.text
        var email = self.emailLabel.text
        
        var validEmail: Bool = true
        if email.rangeOfString("@illinois.edu") != nil {
            validEmail = true
        } else {
            validEmail = false
        }
        if (count(username.utf16) < 4) {
            var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 4 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else if (count(password.utf16) < 5) {
            var alert = UIAlertView(title: "Invalid", message: "Password must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else if (count(email.utf16) < 8) {
            var alert = UIAlertView(title: "Invalid", message: "Email must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else if validEmail == false {
            var alert = UIAlertView(title: "Invalid", message: "Please use your @illinois.edu email", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else if passwordcheck != password {
            var alert = UIAlertView(title: "Invalid", message: "Passwords do not match", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            var newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            //SVProgressHUD.show()
            newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if ((error) != nil) {
                    if error?.code == 100 {
                        var alert = UIAlertView(title: "Error",message: "Sorry, we couldn't connect to our login server. Please confirm you have an internet connection and try again in a mmoment", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    } else if error?.code == 202 {
                        var alert = UIAlertView(title: "Error",message: "This username has already been taken. Choose another one", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    } else if error?.code == 203 {
                        var alert = UIAlertView(title: "Error",message: "This email has already been registered.", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    }
                } else {
                    self.loginLayer()
                    self.emailLabel.resignFirstResponder()
                    self.usernameLabel.resignFirstResponder()
                    self.passwordLabel.resignFirstResponder()
                    self.confirmPassword.resignFirstResponder()
                }
            })
        }
    }
    
    @IBAction func dismissSignUp() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.transitionWithView(UIApplication.sharedApplication().keyWindow!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled()
                UIView.setAnimationsEnabled(false)
                UIApplication.sharedApplication().keyWindow!.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
                }, completion: { (finished: Bool) -> () in
                    if (completion != nil) {
                        completion!()
                    }
            })
        } else {
            UIApplication.sharedApplication().keyWindow!.rootViewController = rootViewController
        }
    }
    
    func loginLayer() {
        SVProgressHUD.show()
        
        // Connect to Layer
        // See "Quick Start - Connect" for more details
        // https://developer.layer.com/docs/quick-start/ios#connect
        self.layerClient.connectWithCompletion { success, error in
            if (!success) {
                println("Failed to connect to Layer: \(error)")
            } else {
                let userID: String = PFUser.currentUser()!.objectId!
                // Once connected, authenticate user.
                // Check Authenticate step for authenticateLayerWithUserID source
                // Once done identifiying present the conversationlistviewcontroller
                self.authenticateLayerWithUserID(userID, completion: { success, error in
                    if (!success) {
                        println("Failed Authenticating Layer Client with error:\(error)")
                    } else {
                        println("Authenticated")
                        SVProgressHUD.dismiss()
                        var newVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as? UIViewController
                        self.switchRootViewController(newVC!, animated: true, completion: nil)

                    }
                })
            }
        }
    }
    
    func authenticateLayerWithUserID(userID: NSString, completion: ((success: Bool , error: NSError!) -> Void)!) {
        // Check to see if the layerClient is already authenticated.
        if self.layerClient.authenticatedUserID != nil {
            // If the layerClient is authenticated with the requested userID, complete the authentication process.
            if self.layerClient.authenticatedUserID == userID {
                println("Layer Authenticated as User \(self.layerClient.authenticatedUserID)")
                if completion != nil {
                    completion(success: true, error: nil)
                }
                return
            } else {
                //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
                self.layerClient.deauthenticateWithCompletion { (success: Bool, error: NSError!) in
                    if error != nil {
                        self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError?) in
                            if (completion != nil) {
                                completion(success: success, error: error)
                            }
                        })
                    } else {
                        if completion != nil {
                            completion(success: true, error: error)
                        }
                    }
                }
            }
        } else {
            // If the layerClient isn't already authenticated, then authenticate.
            self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError!) in
                if completion != nil {
                    completion(success: success, error: error)
                }
            })
        }
    }
    
    func authenticationTokenWithUserId(userID: NSString, completion:((success: Bool, error: NSError!) -> Void)!) {
        /*
        * 1. Request an authentication Nonce from Layer
        */
        self.layerClient.requestAuthenticationNonceWithCompletion { (nonce: String!, error: NSError!) in
            if (nonce.isEmpty) {
                if (completion != nil) {
                    completion(success: false, error: error)
                }
                return
            }
            
            /*
            * 2. Acquire identity Token from Layer Identity Service
            */
            PFCloud.callFunctionInBackground("generateToken", withParameters: ["nonce": nonce, "userID": userID]) { (object:AnyObject?, error: NSError?) -> Void in
                if error == nil {
                    let identityToken = object as! String
                    self.layerClient.authenticateWithIdentityToken(identityToken) { authenticatedUserID, error in
                        if (!authenticatedUserID.isEmpty) {
                            if (completion != nil) {
                                completion(success: true, error: nil)
                            }
                            println("Layer Authenticated as User: \(authenticatedUserID)")
                        } else {
                            completion(success: false, error: error)
                        }
                    }
                } else {
                    println("Parse Cloud function failed to be called to generate token with error: \(error)")
                }
            }
        }
    }
}
