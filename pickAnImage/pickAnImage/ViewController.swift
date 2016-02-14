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
        print ("here")
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

