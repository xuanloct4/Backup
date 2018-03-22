//
//  ImageViewController.swift
//  ImgurShare
//
//  Created by Joyce Echessa on 3/29/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import ImgurKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    var image: Image!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image.image
        title = image.title
        if let url = image.url {
            urlLabel.text = url.absoluteString
        }
    }
    
    @IBAction func copyURLtoClipboard(sender: UIBarButtonItem) {
        if let url = image.url {
            UIPasteboard.generalPasteboard().URL = url
        }
    }
    
}