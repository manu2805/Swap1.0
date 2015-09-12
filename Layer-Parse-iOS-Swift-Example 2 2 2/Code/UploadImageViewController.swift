//
//  UploadImageViewController.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 7/24/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
}

import UIKit

class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate {
    
    //    @IBOutlet weak var showItemImage: UIImageView!
    //    @IBOutlet weak var scrollView: UIScrollView!

    
    @IBOutlet weak var showItemTitle: UITextField!
    @IBOutlet weak var showItemDescription: UITextView!
    @IBOutlet weak var showItemCategory: UITextField!
    @IBOutlet weak var showItemPrice: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var needToRotate = false
    var dropDownIcon = UIImageView()
    
    var imageCount = 0
    
    let imagePicker = UIImagePickerController()
    let tapRec = UITapGestureRecognizer()
    
    let itemCategory = ["Choose One", "Textbooks", "Men's Clothing", "Women's Clothing", "Tickets", "Tech", "Other"]
    var loaded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var placeImage = UIImage(named: "uploadImage.png")
        placeImage = placeImage?.resize(2.5)
        imageView.image = placeImage
        imageView.userInteractionEnabled = true
        imageView.contentMode = UIViewContentMode.Center
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "choosePhoto:")
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let opaqueBlack = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0.45)
        
        let bottomColor = UIColor(red: (255/255.0), green: (81/255.0), blue: (47/255.0), alpha: 0.95)
        let topColor = UIColor(red: (240/255.0), green: (152/255.0), blue: (25/255.0), alpha: 0.5)
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = CGRectMake(0, 0, self.view.frame.height, self.view.frame.height)
        self.view.layer.insertSublayer(gradientLayer, atIndex: 1)
        
        uploadButton.layer.cornerRadius = 30
        uploadButton.layer.borderWidth = 1
        uploadButton.layer.borderColor = UIColor.clearColor().CGColor
        self.view.insertSubview(uploadButton, aboveSubview: UIView())
        
        var pickerView = UIPickerView()
        pickerView.delegate = self

        self.showItemDescription.delegate = self
        self.showItemDescription.text = "Description (optional)"
        self.showItemDescription.textColor = UIColor.whiteColor()
        self.showItemDescription.backgroundColor = opaqueBlack
        self.showItemDescription.layer.borderWidth = 1.0
        self.showItemDescription.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.showItemTitle.delegate = self
        self.showItemTitle.text = " Title"
        self.showItemTitle.borderStyle = .None
        self.showItemTitle.layer.borderColor = UIColor.whiteColor().CGColor
        self.showItemTitle.backgroundColor = opaqueBlack
        self.showItemTitle.textColor = UIColor.whiteColor()

        var titleTopLine = CALayer()
        titleTopLine.frame = CGRectMake(0.0, 0.0, self.showItemTitle.frame.width, 1.0)
        titleTopLine.backgroundColor = UIColor.whiteColor().CGColor
        showItemTitle.layer.addSublayer(titleTopLine)
        
        var titleTopLine2 = CALayer()
        titleTopLine2.frame = CGRectMake(self.showItemTitle.frame.width, 0.0, self.view.frame.width - 27.0, 1.0)
        titleTopLine2.backgroundColor = UIColor.whiteColor().CGColor
        showItemTitle.layer.addSublayer(titleTopLine2)
        
        var titleLeftLine = CALayer()
        titleLeftLine.frame = CGRectMake(0.0, 0.0, 1.0, showItemTitle.frame.height)
        titleLeftLine.backgroundColor = UIColor.whiteColor().CGColor
        showItemTitle.layer.addSublayer(titleLeftLine)
        
        var titleRightLine = CALayer()
        if self.view.frame.width != 414.0 {
            titleRightLine.frame = CGRectMake(self.view.frame.width - 87, 0.0, 1.0, showItemTitle.frame.height)
        } else if self.view.frame.width == 414.0 {
            titleRightLine.frame = CGRectMake(self.view.frame.width - 95, 0.0, 1.0, showItemTitle.frame.height)
        }
        titleRightLine.backgroundColor = UIColor.whiteColor().CGColor
        showItemTitle.layer.addSublayer(titleRightLine)
        
        self.showItemPrice.delegate = self
        self.showItemPrice.borderStyle = .None
        self.showItemPrice.text = " Price"
        self.showItemPrice.keyboardType = UIKeyboardType.NumberPad
        self.showItemPrice.backgroundColor = opaqueBlack
        self.showItemPrice.textColor = UIColor.whiteColor()
        var priceBottomLine = CALayer()
        priceBottomLine.frame = CGRectMake(0.0, showItemPrice.frame.height - 1, showItemPrice.frame.width, 1.0)
        priceBottomLine.backgroundColor = UIColor.whiteColor().CGColor
        showItemPrice.layer.addSublayer(priceBottomLine)
        
        var priceLeftLine = CALayer()
        priceLeftLine.frame = CGRectMake(0.0, 0.0, 1.0, showItemPrice.frame.height)
        priceLeftLine.backgroundColor = UIColor.whiteColor().CGColor
        showItemPrice.layer.addSublayer(priceLeftLine)
        
        var priceRightLine = CALayer()
        priceRightLine.frame = CGRectMake(showItemPrice.frame.width-1, 0.0, 1.0, showItemPrice.frame.height-1)
        priceRightLine.backgroundColor = UIColor.whiteColor().CGColor
        showItemPrice.layer.addSublayer(priceRightLine)
        self.view.insertSubview(showItemPrice, aboveSubview: UIView())
        
        
        self.showItemCategory.delegate = self
        self.showItemCategory.borderStyle = .None
        self.showItemCategory.text = "Choose One"
        self.showItemCategory.inputView = pickerView
        self.showItemCategory.backgroundColor = opaqueBlack
        self.showItemCategory.textColor = UIColor.whiteColor()
        
        var categoryBottomLine = CALayer()
        categoryBottomLine.frame = CGRectMake(0.0, showItemCategory.frame.height - 1, showItemCategory.frame.width + 300, 1.0)
        categoryBottomLine.backgroundColor = UIColor.whiteColor().CGColor
        showItemCategory.layer.addSublayer(categoryBottomLine)
        
        var categoryLeftLine = CALayer()
        categoryLeftLine.frame = CGRectMake(0.0, 0.0, 1.0, showItemCategory.frame.height)
        categoryLeftLine.backgroundColor = UIColor.whiteColor().CGColor
        showItemCategory.layer.addSublayer(categoryLeftLine)
        self.view.insertSubview(showItemCategory, aboveSubview: UIView())
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        var image = UIImage(named: "dropdown.jpg")
        dropDownIcon.image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        dropDownIcon.tintColor = UIColor.whiteColor()
        dropDownIcon.frame = CGRectMake(180, 4, 20, 20)
        showItemCategory.addSubview(dropDownIcon)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if (loaded) {
            let picker = UIImagePickerController()
            self.needToRotate = true
            picker.delegate = self
            picker.sourceType = .Camera
            self.presentViewController(picker, animated: true, completion: nil)
            loaded = false
        } else {
            loaded = true
            return
        }
        
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(CGImage: image.CGImage)!
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)!
        
        return image
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func uploadImage() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .SavedPhotosAlbum
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhoto(recognizer: UITapGestureRecognizer) {
        println("Choose Photo")
        let optionMenu = UIAlertController(title: nil, message: "Choose Photo", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        }
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (alert: UIAlertAction!) -> Void in
            let picker = UIImagePickerController()
            
            self.needToRotate = true
            
            picker.delegate = self
            picker.sourceType = .Camera
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
        let choosePhoto = UIAlertAction(title: "Choose From Existing Photos", style: .Default) { (alert: UIAlertAction!) -> Void in
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(choosePhoto)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = cropToSquare(image: image!)
        imageView.frame = CGRectMake(0, 0, image!.size.width, image!.size.height)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        imageCount = 1
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    @IBAction func uploadImageToServer() {
        
        if (imageCount == 0) {
            var alert = UIAlertController(title: "Missing Image", message: "Please take a picture of your item.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if (showItemTitle.text == " Title" || showItemPrice.text == "Price" || showItemPrice.text == " Price") {
            var alert = UIAlertController(title: "Missing Fields", message: "Please fill in Title, Category, and Price.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if showItemDescription.text == "Description (optional)" {
            showItemDescription.text = "No Description"
        }
        
        if showItemCategory.text == "Choose One" {
            var alert = UIAlertController(title: "Missing Category", message: "Please choose a category for your item", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let resizeImage = imageView.image!.resize(0.5)
        let imageData = UIImageJPEGRepresentation(resizeImage, 0.6)
        let imageFile = PFFile(name: "image.jpg", data: imageData)
        
        var userPhoto = PFObject(className: "Photos")
        userPhoto["imageCaption"] = showItemDescription.text!
        userPhoto["user"] = PFUser.currentUser()
        userPhoto["imageFile"] = imageFile
        userPhoto["Price"] = showItemPrice.text.toInt()
        userPhoto["Category"] = showItemCategory.text!
        userPhoto["Title"] = showItemTitle.text!
        
        let completeDescription = showItemTitle.text!.lowercaseString + showItemDescription.text!.lowercaseString
        var removedSpaces = completeDescription.filter { $0 != Character(" ") }
        userPhoto["Search"] = removedSpaces
        
        
        userPhoto.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if success {
                self.showItemTitle.text = " Title"
                self.showItemPrice.text = " Price"
                self.showItemCategory.text = "Choose One"
                self.showItemDescription.text = "Description (optional)"
            } 
        }
        
        let alertController = UIAlertController(title: "Success", message: "Succesfully uploaded", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dimiss", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        self.showItemDescription.resignFirstResponder()
        
        tabBarController?.selectedIndex = 0
        
        var placeImage = UIImage(named: "uploadImage.png")
        placeImage = placeImage?.resize(2.5)
        imageView.image = placeImage
        imageView.contentMode = UIViewContentMode.Center
        imageCount = 0
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        animateViewMoving(true, moveValue: 170)
        if (textView == showItemDescription && showItemDescription.text == "Description (optional)") {
            showItemDescription.text = ""
            showItemDescription.textColor = UIColor.whiteColor()
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 170)
        if (textField == showItemTitle && textField.text == " Title") {
            showItemTitle.text = ""
            showItemTitle.textColor = UIColor.whiteColor()
        }
        
        if (textField == showItemPrice && textField.text == " Price") {
            showItemPrice.text = ""
            showItemPrice.textColor = UIColor.whiteColor()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 170)
        if (showItemTitle.text.isEmpty && textField == showItemTitle) {
            showItemTitle.text = " Title"
            showItemDescription.textColor = UIColor.whiteColor()
        }
        
        if (showItemPrice.text.isEmpty && textField == showItemPrice) {
            showItemPrice.text = " Price"
            showItemDescription.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        animateViewMoving(false, moveValue: 170)
        if showItemDescription.text.isEmpty {
            showItemDescription.text = "Description (optional)"
            showItemDescription.textColor = UIColor.whiteColor()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return itemCategory.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        
        return itemCategory[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showItemCategory.text = itemCategory[row]
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func cropToSquare(image originalImage: UIImage) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage)!
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)!
        
        return image
    }
}
