//
//  LoginSignupViewController.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 7/24/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit
import Foundation
import Parse

class LoginSignupViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource, UITextFieldDelegate {
    var layerClient: LYRClient!
    var logInViewController: PFLogInViewController!
    let LayerAppIDString: NSURL! = NSURL(string: "layer:///apps/production/7efd3444-2e82-11e5-a212-42906a01766d")
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var privacyPolicy: UITextView!
    
    var imagesForSection0: [UIImage] = []
    var insertGradient = true
    @IBOutlet weak var swapLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        let bottomColor = UIColor(red: (255/255.0), green: (81/255.0), blue: (47/255.0), alpha: 0.95)
        let topColor = UIColor(red: (240/255.0), green: (152/255.0), blue: (25/255.0), alpha: 0.5)
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = CGRectMake(0, 0, self.view.frame.height, self.view.frame.height)
        self.view.layer.insertSublayer(gradientLayer, atIndex: 1)
        self.layerClient = mainLayerClient.layerClient
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        swapLogo.image = UIImage(named: "swapLogo.jpg")
        swapLogo.backgroundColor = UIColor.clearColor()
        
        var hyperlink = NSMutableAttributedString(string: "Privacy Policy")
        hyperlink.addAttribute(NSLinkAttributeName, value: "https://swapsellsave.wordpress.com/2015/08/25/swap-app-privacy-policy/", range: NSMakeRange(0, hyperlink.length))
        privacyPolicy.attributedText = hyperlink
        privacyPolicy.dataDetectorTypes = UIDataDetectorTypes.All
        privacyPolicy.center = CGPoint(x: self.view.frame.width/2, y: 400)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() != nil) {
            self.loginLayer()
            return
        }
        
        var imageView = UIImageView();
        var image = UIImage(named: "userTextField.jpg");
        imageView.image = image
        imageView.frame = CGRectMake(8, 12, 25, 25)
        usernameTextField.addSubview(imageView)
        
        var imageViewPass = UIImageView()
        var imagePass = UIImage(named:"passwordTextField.jpg")
        imageViewPass.image = imagePass
        imageViewPass.frame = CGRectMake(8, 12, 25, 25)
        passwordTextField.addSubview(imageViewPass)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        authenticateButton.layer.cornerRadius = 10
        authenticateButton.layer.borderWidth = 1
        authenticateButton.layer.borderColor = UIColor.clearColor().CGColor
        
        registerButton.layer.cornerRadius = 10
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.clearColor().CGColor
    }
    // MARK - PFLogInViewControllerDelegate
    
    // Sent to the delegate to determine whether the log in request should be submitted to the server.
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username:String, password: String) -> Bool {
        if (!username.isEmpty && !password.isEmpty) {
            return true // Begin login process
        }
        
        let title = NSLocalizedString("Missing Information", comment: "")
        let message = NSLocalizedString("Make sure you fill out all of the information!", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
        
        return false // Interrupt login process
    }
    
    // Sent to the delegate when a PFUser is logged in.
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        var newVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as? UIViewController
        self.switchRootViewController(newVC!, animated: true, completion: nil)
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        self.loginLayer()
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        if let description = error?.localizedDescription {
            let cancelButtonTitle = NSLocalizedString("OK", comment: "")
            UIAlertView(title: description, message: nil, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
        }
        println("Failed to log in...")
    }
    
    // MARK: - PFSignUpViewControllerDelegate
    
    // Sent to the delegate to determine whether the sign up request should be submitted to the server.
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        var informationComplete: Bool = true
        
        // loop through all of the submitted data
        for (key, val) in info {
            if let field = info[key] as? String {
                if field.isEmpty {
                    informationComplete = false
                    break
                }
            }
        }
        
        let emailEntered = info["email"]! as! String
        var validEmail: Bool = true
        if emailEntered.rangeOfString("@illinois.edu") != nil {
            validEmail = true
        } else {
            validEmail = false
        }
        // Display an alert if a field wasn't completed
        if (!informationComplete) {
            let title = NSLocalizedString("Signup Failed", comment: "")
            let message = NSLocalizedString("All fields are required", comment: "")
            let cancelButtonTitle = NSLocalizedString("OK", comment: "")
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
        }
        
        if (!validEmail) {
            let title = NSLocalizedString("Signup Failed", comment: "")
            let message = NSLocalizedString("Signup with @illinois.edu email", comment: "")
            let cancelButtonTitle = NSLocalizedString("OK", comment: "")
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
        }
        
        return (informationComplete && validEmail)
    }
    
    // Sent to the delegate when a PFUser is signed up.
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.loginLayer()
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("Failed to sign up...")
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
                        self.passwordTextField.resignFirstResponder()
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
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        var rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
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
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mosaicImages.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath) as! RACollectionViewCell
        
        cell.imageView.image = nil
        let topImage = mosaicImages[indexPath.item]
        
        let size = CGSizeApplyAffineTransform(topImage.size, CGAffineTransformMakeScale(0.5, 0.5))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        topImage.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.imageView.image = scaledImage
        
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
    
    func scrollTrigerPaddingInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.collectionView.contentInset.top, 0, self.collectionView.contentInset.bottom, 0)
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        var username = self.usernameTextField.text
        var password = self.passwordTextField.text
        
        if (count(username.utf16) < 4) {
            var alert = UIAlertView(title: "Invalid Username", message: "Check again", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
        } else if (count(password.utf16) < 5 ) {
            var alert = UIAlertView(title: "Invalid Password", message: "Check again", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
        } else {
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user: PFUser?, error: NSError?) -> Void in
                
                if ((user) != nil) {
                    //self.dismissViewControllerAnimated(true, completion: nil)
                    self.loginLayer()
                } else {
                    if error?.code == 100 {
                        var alert = UIAlertView(title: "Error",message: "Sorry, we couldn't connect to our login server. Please confirm you have an internet connection and try again in a moment", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    } else if error?.code == 101 {
                        var alert = UIAlertView(title: "Error",message: "Invalid login parameters. Please check your username and password", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
            })
        }
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
    
}
