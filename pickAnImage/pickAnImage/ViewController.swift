//
//  ViewController.swift
//  pickAnImage
//
//  Created by Sahil Garg on 14/02/16.
//  Copyright © 2016 sahilgarg.in. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var bottomLabel: UITextField!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var pickAnImage: UIImageView!
    @IBOutlet weak var pickCamera: UIBarButtonItem!
    @IBOutlet weak var came: UIBarButtonItem!
    @IBOutlet weak var toolHere: UIToolbar!
    @IBOutlet weak var upperNav: UINavigationBar!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName :UIColor.whiteColor(),
        NSFontAttributeName : UIFont( name:"HelveticaNeue-Bold", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textDesign(topLabel)
        textDesign(bottomLabel)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textDesign(txtfld:UITextField)
    {
        txtfld.textAlignment = .Center
        txtfld.delegate = self
        
    }
    

    override func viewWillAppear(animated: Bool) {
        pickCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        topLabel.defaultTextAttributes = memeTextAttributes
        bottomLabel.defaultTextAttributes = memeTextAttributes
         self.subscribeToKeyboardNotifications()
    }
    @IBAction func pickFromHere(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        pickImageControl(imagePicker, src:"album")
       
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickAnImage.image = image
             self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }

    @IBAction func pickAnImageCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        pickImageControl(imagePicker, src:"camera")
    }
    
    func pickImageControl(iPick: UIImagePickerController, src:String!)
    {
        if(src == "album")
        {
            iPick.delegate = self
            iPick.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        else
        {
            iPick.delegate = self
            iPick.sourceType = UIImagePickerControllerSourceType.Camera
        }

         presentViewController(iPick, animated: true, completion: nil)

    }
   
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    
    @IBAction func shareit(sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(
            activityItems: [generateMemedImage()],
            applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
           let meme = Meme(text1: self.topLabel.text!,text2: self.bottomLabel.text!, image: self.pickAnImage.image, memedImage: self.generateMemedImage())
        }
    }
    
   
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height

        
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if bottomLabel.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
        

    }
    
   


    func keyboardWillBeHidden(notification: NSNotification)
    {
          if bottomLabel.isFirstResponder()
          {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,object: nil)
    }
    func unsubscribeFromKeyboardNotifications()
    {
         NSNotificationCenter.defaultCenter().removeObserver(self)
    }
   
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        toolHere.hidden = true
        upperNav.hidden = true
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
            toolHere.hidden = false
            upperNav.hidden = false
        //self.dismissViewControllerAnimated(false, completion: nil)
        return memedImage
    }
    struct Meme {
        var text1 : String!
        var text2 : String!
        var image : UIImage!
        var memedImage : UIImage!
    }
    
    /*func save()
    {
        //Create the meme
        let meme = Meme(text1: topLabel.text!,text2: bottomLabel.text!, image: pickAnImage.image, memedImage: generateMemedImage())

    }*/
   
    
}

