//
//  Image.swift
//  ImgurShare
//
//  Created by Joyce Echessa on 3/29/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import Foundation
import UIKit

public class Image: NSObject, NSCoding {
    
    public let title: String
    public let image: UIImage
    public var url: NSURL?
    
    public init(imgTitle: String, imgImage: UIImage) {
        title = imgTitle
        image = imgImage
        super.init()
    }
    
    public required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("title") as! String
        image = aDecoder.decodeObjectForKey("image") as! UIImage
        url = aDecoder.decodeObjectForKey("url") as? NSURL
    }
    
    public func encodeWithCoder(aCoder: NSCoder)  {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(url, forKey: "url")
    }
    
}
