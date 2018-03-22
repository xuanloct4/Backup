//
//  MethodFromString.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/11/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

import UIKit

class MethodFromString: NSObject {
    //typealias Function = @convention(c) (AnyObject, Selector, Bool) -> Unmanaged<UIImage>
    
   class func extractMethodFrom(owner: AnyObject, selector: Selector) -> ((Bool) -> UIImage)? {
        let method: Method
        if owner is AnyClass {
            method = class_getClassMethod(owner as! AnyClass, selector)
        } else {
            //            method = class_getInstanceMethod(owner.dynamicType, selector)
            method = class_getInstanceMethod(type(of: owner), selector)
        }
        
        guard method != nil else {
            return nil
        }
        
        let implementation = method_getImplementation(method)
        typealias Function = @convention(c) (AnyObject, Selector, Bool) -> Unmanaged<UIImage>
        let function = unsafeBitCast(implementation, to: Function.self)
        
        return { bool in function(owner, selector, bool).takeUnretainedValue() }
    
    
//    // How to use:  
//    let name = "imageWithBorder:" // e.g. from somewhere else
//    if let method = extractMethodFrom(imageGenerator, name) {
//        let image = method(true)
//        // Use image here
//    }
    }
}
