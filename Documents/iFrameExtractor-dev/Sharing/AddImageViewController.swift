//
//  AddImageViewController.swift
//  ImgurShare
//
//  Created by Joyce Echessa on 3/29/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import ImgurKit

class AddImageViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    
    @IBAction func selectImage(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadImage(sender: UIBarButtonItem) {
        if let selectedImage = imageView.image {
            if (titleTextField.text.isEmpty) {
                let alert = UIAlertController(title: "Error", message: "You must enter a Title", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            } else {
                shareImage(titleTextField.text, imageToUpload: selectedImage)
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: "You must select an image", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareImage(imageTitle: String, imageToUpload: UIImage) {
        let defaultSession = UploadImageService.sharedService.session
        let defaultSessionConfig = defaultSession.configuration
        let defaultHeaders = defaultSessionConfig.HTTPAdditionalHeaders
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.dev.ImgurShare.backgroundsession")
        config.sharedContainerIdentifier = "group.com.dev.ImgurShare"
        config.HTTPAdditionalHeaders = defaultHeaders
        
        let session = NSURLSession(configuration: config, delegate: UploadImageService.sharedService, delegateQueue: NSOperationQueue.mainQueue())
        
        let completion: (TempImage?, NSError?, NSURL?) -> () = { image, error, tempURL in
            if error == nil {
                if let imageURL = image?.link {
                    let image = Image(imgTitle: imageTitle, imgImage: imageToUpload)
                    image.url = imageURL
                    let imageService = ImageService.sharedService
                    imageService.addImage(image)
                    imageService.saveImages()
                    let alert = UIAlertController(title: "Saved", message: "Saved", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                if let container = tempURL {
                    var delError: NSError?
                    if NSFileManager.defaultManager().isDeletableFileAtPath(container.path!) {
                        let success = NSFileManager.defaultManager().removeItemAtPath(container.path!, error: &delError)
                        if(!success) {
                            println("Error removing file at path: \(error?.description)")
                        }
                    }
                }
            } else {
                println("Error uploading image: \(error!)")
                if let container = tempURL {
                    var delError: NSError?
                    if NSFileManager.defaultManager().isDeletableFileAtPath(container.path!) {
                        let success = NSFileManager.defaultManager().removeItemAtPath(container.path!, error: &delError)
                        if(!success) {
                            println("Error removing file at path: \(error?.description)")
                        }
                    }
                }
            }
        }
        
        let title = titleTextField.text
        UploadImageService.sharedService.uploadImage(imageView.image!, title: title, session: session, completion:completion)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as UIImage
        imageView.image = chosenImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
