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

        NSStrokeColorAttributeName : UIColor.whiteColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
       // NSStrokeWidthAttributeName : 15.0
    ]
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.textAlignment = .Center
        bottomLabel.textAlignment = .Center
        self.topLabel.delegate = self
        self.bottomLabel.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        pickCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        topLabel.defaultTextAttributes = memeTextAttributes
        bottomLabel.defaultTextAttributes = memeTextAttributes
         self.subscribeToKeyboardNotifications()
    }
    @IBAction func pickFromHere(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickAnImage.image = image
             self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }

    @IBAction func pickAnImageCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
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
        self.view.frame.origin.y -= getKeyboardHeight(notification)

    }
    func keyboardWillBeHidden(notification: NSNotification)
    {
        self.view.frame.origin.y += getKeyboardHeight(notification)
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
    
    
    /*func save() {
        //Create the meme
        let meme = Meme( text: bottomLabel.text!, image:
            pickAnImage.image, memedImage: generateMemedImage())
    }*/
    
}

