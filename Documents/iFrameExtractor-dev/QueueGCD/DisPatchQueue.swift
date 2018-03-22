//
//  DisPatchQueue.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/11/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

import UIKit

class DisPatchQueue: NSObject {
    var count:Int = 0
    var ttt:[String] = []
    var lock:NSLock!
    
    func testThread(){
        let q1 = DispatchQueue.init(label: "testThread1")
        let q2 = DispatchQueue.init(label: "testThread2")
        
        //        q1.async {
        //            self.thread1(label: "Thread1")
        //        }
        //        q1.async {
        //            self.thread1(label: "Thread2")
        //        }
        
        //        q1.async {
        //            self.thread1(label: "Thread1")
        //            self.thread1(label: "Thread2")
        //        }
        
        //        q1.sync {
        //            self.thread1(label: "Thread1")
        //        }
        //        q1.sync {
        //            self.thread1(label: "Thread2")
        //        }
        
        //        q1.sync {
        //            self.thread1(label: "Thread1")
        //            self.thread1(label: "Thread2")
        //        }
        
        //                        q1.sync {
        //                            self.thread1(label: "Thread1")
        //                        }
        //                        q2.sync {
        //                            self.thread1(label: "Thread2")
        //                        }
        
        //        q1.sync {
        //            self.thread1(label: "Thread1")
        //        }
        //        q1.async {
        //            self.thread1(label: "Thread2")
        //        }
        
        //                q1.async {
        //                    self.thread1(label: "Thread1")
        //                }
        //                q1.sync {
        //                    self.thread1(label: "Thread2")
        //                }
        
        //// From Thread 1 to Thread 2
        
        
        //                q1.async {
        //                    self.thread1(label: "Thread1")
        //                }
        //                q2.async {
        //                    self.thread1(label: "Thread2")
        //                }
        
        //        q1.async {
        //            self.thread1(label: "Thread1")
        //        }
        //        q2.sync {
        //            self.thread1(label: "Thread2")
        //        }
        
        //                q1.sync {
        //                    self.thread1(label: "Thread1")
        //                }
        //                q2.async {
        //                    self.thread1(label: "Thread2")
        //                }
        
        //// Async Thread 1 with Thread 2
        
        
        q1.async {
            self.thread2(label: "Thread1")
        }
        q2.async {
            self.thread2(label: "Thread2")
        }
        
        
    }
    
    func thread1(label:String){
        for index in 0..<100000{
            print("\(label) index: \(index)")
        }
    }
    
    func thread2(label:String){
        //        objc_sync_enter(ttt)
        // self.accessQueue.async(flags:.barrier) {
        
        lock.lock()
        for index in 0..<100{
            self.ttt.append("\(label)")
            print("\(label) ttt: \(label)")
        }
        lock.unlock()
        
        //        }
        
        //        objc_sync_exit(ttt)
    }
}
