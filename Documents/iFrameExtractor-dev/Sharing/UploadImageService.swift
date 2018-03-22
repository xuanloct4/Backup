//
//  UploadImageService.swift
//  ImgurShare
//
//  Created by Joyce Echessa on 3/29/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import Foundation
import UIKit

public class UploadImageService: NSObject, NSURLSessionDataDelegate, NSURLSessionTaskDelegate {
    
    private let imgurClientId = "IMGUR_CLIENT_ID"
    private let imgurUploadUrlString = "https://api.imgur.com/3/image"
    public let session: NSURLSession!
    private var completionCallbacks: Dictionary<NSURLSessionTask, (TempImage?, NSError?, NSURL?) -> ()> = Dictionary()
    private var containerURL: NSURL?
    
    public class var sharedService: UploadImageService {
        struct Singleton {
            static let instance = UploadImageService()
        }
        return Singleton.instance
    }
    
    private override init() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPAdditionalHeaders = ["Authorization": "Client-ID \(imgurClientId)", "Content-Type": "application/json"]
        
        super.init()
        
        session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }
    
    public func uploadImage(image: UIImage, title: NSString, completion: (TempImage?, NSError?, NSURL?) -> ()) {
        uploadImage(image, title: title, session: session, completion: completion)
    }
    
    public func uploadImage(image: UIImage, title: NSString, session: NSURLSession?, completion: (TempImage?, NSError?, NSURL?) -> ()) {
        
        let baseUrl = NSURL(string: imgurUploadUrlString)
        
        if let url = NSURL(string: "?title=\(title)", relativeToURL: baseUrl) {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            let imageService = ImageService()
            var urlSession: NSURLSession
            let uuid = NSUUID().UUIDString
            let tempContainerURL = imageService.tempContainerURL(image, name: uuid)
            
            if let session = session {
                urlSession = session
            } else {
                urlSession = self.session
            }
            if let uploadUrl = tempContainerURL {
                containerURL = uploadUrl
                let task = urlSession.uploadTaskWithRequest(request, fromFile: uploadUrl)
                completionCallbacks[task] = completion
                
                task.resume()
            } else {
                let error = NSError(domain: "com.appcoda.ImgurShare.imgurservice", code: 1, userInfo: nil)
                completion(nil, error, tempContainerURL)
            }
        }
    }
    
    // MARK - NSURLSessionTaskDelegate
    
    public func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didCompleteWithError error: NSError!) {
        
        if let completionCallback = completionCallbacks[task] {
            completionCallbacks.removeValueForKey(task)
            
            if error != nil {
                completionCallback(nil, error, self.containerURL)
            }
        }
    }
    
    public func URLSession(session: NSURLSession!, dataTask: NSURLSessionDataTask!, didReceiveData data: NSData!) {
        if let completionBlock = completionCallbacks[dataTask] {
            var error: NSError?
            
            if error == nil {
                let response = JSON(data: data)
                println("Imgur json data: \(response)")
                let image = TempImage(fromJson: response["data"])
                dispatch_async(dispatch_get_main_queue()) {
                    completionBlock(image, nil, self.containerURL)
                }
            } else {
                completionBlock(nil, error, self.containerURL)
            }
        }
    }
}
