//
//  ViewControllerSwizzle.swift
//  CloudStorage
//
//  Created by tranvanloc on 2/22/17.
//  Copyright © 2017 toshiba. All rights reserved.
//

import UIKit

extension UIViewController {
    private struct AssociatedKeys {
        static var Tap:UITapGestureRecognizer!
    }
    
    var tap: UITapGestureRecognizer! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.Tap) as! UITapGestureRecognizer
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.Tap,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}

extension UIViewController {
    class var sharedInstance: UIViewController {
        struct Static {
            static let instance = UIViewController()
        }
        return Static.instance
    }
    
    open override class func initialize() {
        
        //        struct Static {
        //            static var token: dispatch_once_t = 0
        //        }
        
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        
        //        dispatch_once(&Static.token) {
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzledSelector = #selector(UIViewController.nsh_viewDidLoad)
        
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        //        }
    }
    
    // MARK: - Method Swizzling
    
    func nsh_viewDidLoad() {
        self.nsh_viewDidLoad()
        self.tap = UITapGestureRecognizer.init(target: self, action: #selector(UIViewController.hideKeyboard))
        self.tap.isEnabled = false;
        //        if let name = self.descriptiveName {
        //            print("viewWillAppear: \(name)")
        //        } else {
        //            print("viewWillAppear: \(self)")
        //        }
    }
    
  
}

extension UIViewController {
func hideKeyboard(){
    self.resignSubViewResponder(parentView: self.view)
    self.tap.isEnabled = false;
}

func resignSubViewResponder(parentView:UIView){
    if (parentView.isKind(of: UITextView.self) || parentView.isKind(of: UITextField.self)){
        parentView.resignFirstResponder()
    }
    for v in parentView.subviews{
        self.resignSubViewResponder(parentView:v)
    }
}
}

class ViewControllerSwizzle: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
