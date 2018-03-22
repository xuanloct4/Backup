//
//  FrameworkImport.swift
//  SimpleFFPlayer
//
//  Created by loctv on 7/26/17.
//  Copyright © 2017 xuanloctn. All rights reserved.
//

import UIKit
import Darwin

class FrameworkImport: NSObject {
    class func importFW()  {
        let handle = dlopen("/usr/lib/libc.dylib", RTLD_NOW)
        let sym = dlsym(handle, "random")
        
        typealias randomFunc = @convention(c) () -> CInt
        let f = unsafeBitCast(sym, to: randomFunc.self)
        let result = f()
        dlclose(handle)
        print(result)
    }
}
