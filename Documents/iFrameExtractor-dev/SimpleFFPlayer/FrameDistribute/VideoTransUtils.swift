//
//  VideoTransUtils.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/10/17.
//  Copyright © 2017 jefby. All rights reserved.
//

import UIKit

@objc
enum VFPosition:Int {
    case head = 0
    case body = 1
    case foot = 2
}

struct VideoFrameInfo {
    var data :[UInt8]
    var fps : Int
    var seekTime: Double
    var sendTime: Double
    var order: Int = 0
    var position: VFPosition = .foot
    
    init(){
        data = []
        fps = 30
        sendTime = 0
        seekTime = 0
    }
    
    init(data: [UInt8], fps: Int, seekTime: Double,sendTime: Double) {
        self.data = data
        self.fps = fps
        self.seekTime = seekTime
        self.sendTime = sendTime
    }
    
    init(data: [UInt8], fps: Int, seekTime: Double,sendTime: Double, order: Int, position: VFPosition) {
        self.data = data
        self.fps = fps
        self.seekTime = seekTime
        self.sendTime = sendTime
        self.order = order
        self.position = position
    }
    
}


//infix operator == : AdditionPrecedence
//extension Array where Element:UInt8
//{
//    static func == (left: [UInt8], right: [UInt8]) -> Bool {
//        if(left.count != right.count){
//            return false;
//        }
//            for index in 0..<left.count{
//            let leftElement = left[index]
//                let rightElement = right[index]
//                if(leftElement != rightElement){
//                return false
//                }
//            }
//
//        return true
//    }
//}

//extension Array
//{
//    mutating func insertObject(_ object:AnyObject, at indexx:Int){
//        if indexx < self.count{
//
//        }else{
//            // Fill from count to index with empty object
//            let emptObj = ""
//            for ind in self.count..<indexx - 1 {
////                self[ind] = emptObj
//            }
//         self.append(object)
//        }
//    }
//}


extension Array where Element:Any
{
    //    mutating func insertObject(_ object:Any, at index:Int){
    //        if index < self.count{
    // self[index] = object
    //        }else{
    //        // Fill from count to index with empty object
    //            let emptObj = AnyObject()
    //
    //        }
    //    }
    
    func arrayElements(fromIndex:Int, toIndex:Int)->[Any]
    {
        //         objc_sync_enter(self)
        var array:[Any] = [Any]()
        if ((fromIndex >= toIndex) || (fromIndex < 0) || (toIndex > self.count)){
            
        }else{
            
            let thr:Int = toIndex
            for index in fromIndex..<thr{
                let element = self[index]
                array.append(element)
            }
            
        }
        //         objc_sync_exit(self)
        return array
    }
    
    //    mutating func appendElementsFromArray(array:[Any]?)->[Any]{
    //        if let _ = array{
    //            return self
    //        }else{
    //            for index in 0..<array!.count{
    //                let element = array![index]
    //            self.append(element)
    //            }
    //      return self
    //        }
    //    }
    
    
}


extension Data {
    //    func toByteArray<T>(_ value: T) -> [UInt8] {
    //        var value = value
    //        return withUnsafeBytes(of: &value) { Array($0) }
    //    }
    //
    //    func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
    //        return value.withUnsafeBytes {
    //            $0.baseAddress!.load(as: T.self)
    //        }
    //    }
    
    static func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafePointer(to: &value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size))
            }
        }
    }
    
    static func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
        return value.withUnsafeBufferPointer {
            $0.baseAddress!.withMemoryRebound(to: T.self, capacity: 1) {
                $0.pointee
            }
        }
    }
    
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

@objc
enum LockState:Int{
    case locked = 0
    case unlocked = 1
}

@objc
class VALock:NSObject{
    var name:String!
    weak var object:AnyObject!
        {
        willSet{
            
        }
        
        didSet{
            
        }
    }
    var condition_:((Int)->Bool)?
    var condition:((Int)->Bool)?
    {
        get{
            return condition_
        }
        
        set{
            condition_ = newValue
        }
    }
    
    var count:Int = 0
    {
        willSet{
            
        }
        
        didSet{
            
        }
    }
    var lockState:LockState = .locked
    {
        willSet{
            
        }
        
        didSet{
            
        }
    }
    
    var unlockClosure:((AnyObject)->Void)?
    var lockClosure:((AnyObject)->Void)?
    //    override init() {
    //    super.init()
    //    condition_ = {
    //            return (self.count == 0)
    //        }
    //    }
    
    init(label:String) {
        super.init()
        self.name = label
    }
    
    init(label:String, condition:@escaping (Int)->Bool) {
        super.init()
        DispatchQueue.init(label: label).sync {
            self.condition = condition
        }
        self.name = label
    }
    
    func lock(object:AnyObject, condition:@escaping (Int)->Bool){
        
        self.condition = condition
        lock(object: object)
    }
    
    func lock(object:AnyObject){
        //        objc_sync_enter(object)
        //        OSAtomicIncrement64(UnsafeMutablePointer.)
        self.count += 1
        var result = (count == 0)
        if let _ = self.condition {
            result = self.condition!(count)
        }
        
        if(result == true){
            self.lockState = .unlocked
            //            objc_sync_exit(object)
            if let _=self.unlockClosure {
                unlockClosure!(object)
            }
        }else{
            self.lockState = .locked
            if let _=self.lockClosure {
                lockClosure!(object)
            }
        }
        
        //        let lockQueue = DispatchQueue.init(label: self.name)
        //        lockQueue.sync() {
        //
        //        }
    }
    
    func unlock(object:AnyObject, condition:@escaping (Int)->Bool){
        self.condition = condition
        unlock(object: object)
    }
    
    func unlock(object:AnyObject){
        self.count -= 1
        var result = (count == 0)
        if let _ = self.condition {
            result = self.condition!(count)
        }
        
        if(result == true){
            self.lockState = .unlocked
        }else{
            self.lockState = .locked
        }
        
        //        let lockQueue = DispatchQueue.init(label: self.name)
        //        lockQueue.sync() {
        //
        //        }
    }
    
    
}


@objc
class VideoTransUtils: NSObject {
    static let fpsSample:[UInt8] = [0,0,0,0,0,0,0,0]
    static let seektimeSample:[UInt8] = [0,0,0,0,0,0,0,0]
    static let sendtimeSample:[UInt8] = [0,0,0,0,0,0,0,0]
    static let orderSample:[UInt8] = [0,0,0,0,0,0,0,0]
    static var headerSample:[UInt8]  // [72, 101, 97, 100, 101, 114] //Header
    {
        get{
            let _header = "Header"
            let _sample: [UInt8] = Array(_header.utf8)
            return _sample
        }
        
        set{
            
        }
    }
    
    static let footerSample:[UInt8] = [70, 111, 111, 116, 101, 114] //Footer
    
    static var headBodySample:[UInt8] {
        get{
            var _sample:[UInt8] = []
            _sample.append(contentsOf: VideoTransUtils.fpsSample)
            _sample.append(contentsOf: VideoTransUtils.seektimeSample)
            _sample.append(contentsOf: VideoTransUtils.sendtimeSample)
            _sample.append(contentsOf: VideoTransUtils.orderSample)
            return _sample
        }
        
        set{
            
        }
    }
    
    static var footBodySample:[UInt8]
    {
        get{
            var _sample:[UInt8] = []
            _sample.append(contentsOf: VideoTransUtils.fpsSample)
            _sample.append(contentsOf: VideoTransUtils.seektimeSample)
            _sample.append(contentsOf: VideoTransUtils.sendtimeSample)
            _sample.append(contentsOf: VideoTransUtils.orderSample)
            return _sample
        }
        
        set{
            
        }
    }
    
    static var headHeaderSample:[UInt8] {
        get{
            var _sample:[UInt8] = []
            _sample.append(contentsOf: VideoTransUtils.headerSample)
            _sample.append(contentsOf: VideoTransUtils.fpsSample)
            _sample.append(contentsOf: VideoTransUtils.seektimeSample)
            _sample.append(contentsOf: VideoTransUtils.sendtimeSample)
            _sample.append(contentsOf: VideoTransUtils.orderSample)
            return _sample
        }
        
        set{
            
        }
    }
    
    static var footHeaderSample:[UInt8]
    {
        get{
            var _sample:[UInt8] = []
            _sample.append(contentsOf: VideoTransUtils.fpsSample)
            _sample.append(contentsOf: VideoTransUtils.seektimeSample)
            _sample.append(contentsOf: VideoTransUtils.sendtimeSample)
            _sample.append(contentsOf: VideoTransUtils.orderSample)
            return _sample
        }
        
        set{
            
        }
    }
    
    
    static var headFooterSample:[UInt8] {
        get{
            var _sample:[UInt8] = []
            _sample.append(contentsOf: VideoTransUtils.fpsSample)
            _sample.append(contentsOf: VideoTransUtils.seektimeSample)
            _sample.append(contentsOf: VideoTransUtils.sendtimeSample)
            _sample.append(contentsOf: VideoTransUtils.orderSample)
            return _sample
        }
        
        set{
            
        }
    }
    
    static var footFooterSample:[UInt8]
    {
        get{
            var _sample:[UInt8] = []
            _sample.append(contentsOf: VideoTransUtils.fpsSample)
            _sample.append(contentsOf: VideoTransUtils.seektimeSample)
            _sample.append(contentsOf: VideoTransUtils.sendtimeSample)
            _sample.append(contentsOf: VideoTransUtils.orderSample)
            _sample.append(contentsOf: VideoTransUtils.footerSample)
            return _sample
        }
        
        set{
            
        }
    }
    
    class func removeHeaderInfo(data: [UInt8]!) -> [UInt8]{
        var removedData:[UInt8] = []
        // If it is header frame or completed data
        if(VideoTransUtils.isHeaderFrame(data: data) || VideoTransUtils.isCompletedFrame(data: data)) {
            if let _dat = data.arrayElements(fromIndex: VideoTransUtils.headHeaderSample.count, toIndex: data.count) as? [UInt8]{
                removedData = _dat
            }
        }else{
            // else if it is footer or body
            removedData = data.arrayElements(fromIndex:VideoTransUtils.headFooterSample.count, toIndex: data.count) as! [UInt8]
        }
        return removedData
    }
    
    class func removeFooterInfo(data: [UInt8]!) -> [UInt8]{
        var removedData:[UInt8] = []
        // If it is footer frame or complete data
        if(VideoTransUtils.isFooterFrame(data: data) || VideoTransUtils.isCompletedFrame(data: data)) {
            if let _dat = data.arrayElements(fromIndex: 0, toIndex: data.count - VideoTransUtils.footFooterSample.count) as? [UInt8]{
                removedData = _dat
            }
        }else{
            // else if it is header or body
            removedData = data.arrayElements(fromIndex: 0, toIndex: data.count - VideoTransUtils.footHeaderSample.count) as! [UInt8]
        }
        return removedData
    }
    
    class func findFrameRateInfo(data:[UInt8]!)->Int{
        var fromIndex:Int!
        
        // If it is header frame or complete data
        if(VideoTransUtils.isHeaderFrame(data: data) || VideoTransUtils.isCompletedFrame(data: data)) {
            fromIndex = VideoTransUtils.headerSample.count
        }else if (VideoTransUtils.isFooterFrame(data: data)){
            // else if it is footer
            fromIndex = data.count - VideoTransUtils.footFooterSample.count
        }else{
            // else it is body
            fromIndex = 0
        }
        
        let toIndex = fromIndex + VideoTransUtils.fpsSample.count
        if let frRateBytes = data.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            return Int(Data.fromByteArray(frRateBytes, Double.self))
        }else{
            return -1
        }
    }
    
    class func findData(data:[UInt8]!)->[UInt8]{
        var fromIndex:Int!
        var toIndex:Int!
        if(VideoTransUtils.isCompletedFrame(data: data)) {
            // If it is completed frame
            fromIndex = VideoTransUtils.headHeaderSample.count
            toIndex =  data.count - VideoTransUtils.footFooterSample.count
        } else if(VideoTransUtils.isHeaderFrame(data: data)) {
            // else if it is header
            fromIndex = VideoTransUtils.headHeaderSample.count
            toIndex =  data.count - VideoTransUtils.footBodySample.count
        } else if(VideoTransUtils.isFooterFrame(data: data)) {
            // else if it is footer
            fromIndex = VideoTransUtils.headBodySample.count
            toIndex =  data.count - VideoTransUtils.footFooterSample.count
        } else if(VideoTransUtils.isBodyFrame(data: data)) {
            // else it is body
            fromIndex = VideoTransUtils.headBodySample.count
            toIndex =  data.count - VideoTransUtils.footBodySample.count
        }
        if let dataBytes = data.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            return dataBytes
        }else{
            return [UInt8]()
        }
        
    }
    
    class func findSeekTimeInfo(data:[UInt8]!)->Double{
        var fromIndex:Int!
        
        if (VideoTransUtils.isHeaderFrame(data: data)){
            // If it is header frame
            fromIndex = VideoTransUtils.headerSample.count + VideoTransUtils.fpsSample.count
        }
            //        else if (VideoTransUtils.isFooterFrame(data: data)){
            //            // else if it is footer
            //            fromIndex = data.count - VideoTransUtils.footFooterSample.count + VideoTransUtils.footerSample.count + VideoTransUtils.fpsSample.count
            //        }
        else{
            // else it is body
            fromIndex = VideoTransUtils.fpsSample.count
        }
        
        let toIndex = fromIndex + VideoTransUtils.seektimeSample.count
        if let seekTimeBytes = data.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            return Data.fromByteArray(seekTimeBytes, Double.self)
        }else{
            return -1
        }
    }
    
    class func findSendTimeInfo(data:[UInt8]!)->Double{
        var fromIndex:Int!
        
        if (VideoTransUtils.isHeaderFrame(data: data)){
            // If it is header frame
            fromIndex = VideoTransUtils.headerSample.count + VideoTransUtils.fpsSample.count + VideoTransUtils.seektimeSample.count
        }
            //        else if (VideoTransUtils.isFooterFrame(data: data)){
            //            // else if it is footer
            //            fromIndex = data.count - VideoTransUtils.footFooterSample.count + VideoTransUtils.footerSample.count + VideoTransUtils.fpsSample.count + VideoTransUtils.seektimeSample.count
            //        }
        else{
            // else it is body
            fromIndex = VideoTransUtils.fpsSample.count + VideoTransUtils.seektimeSample.count
        }
        
        let toIndex = fromIndex + VideoTransUtils.sendtimeSample.count
        if let sendTimeBytes = data.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            let _sendTime = Data.fromByteArray(sendTimeBytes, Double.self)
            return _sendTime
        }else{
            return -1
        }
    }
    
    class func findOrderInfo(data:[UInt8]!)->Int{
        var fromIndex:Int!
        
        if (VideoTransUtils.isHeaderFrame(data: data)){
            // If it is header frame
            fromIndex = VideoTransUtils.headerSample.count + VideoTransUtils.fpsSample.count + VideoTransUtils.seektimeSample.count + VideoTransUtils.sendtimeSample.count
        }
            //        else if (VideoTransUtils.isFooterFrame(data: data)){
            //            // else if it is footer
            //            fromIndex = data.count - VideoTransUtils.footFooterSample.count + VideoTransUtils.footerSample.count + VideoTransUtils.fpsSample.count + VideoTransUtils.seektimeSample.count + VideoTransUtils.sendtimeSample.count
            //            let toIndex = fromIndex + VideoTransUtils.orderSample.count
            //            if let orderBytes = data.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            //                return Int(Data.fromByteArray(orderBytes, Double.self)) - 1
            //            }else{
            //                return -1
            //            }
            //
            //        }
        else{
            // else it is body or footer
            fromIndex = VideoTransUtils.fpsSample.count + VideoTransUtils.seektimeSample.count + VideoTransUtils.sendtimeSample.count
        }
        
        let toIndex = fromIndex + VideoTransUtils.orderSample.count
        if let orderBytes = data.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            return Int(Data.fromByteArray(orderBytes, Double.self))
        }else{
            return -1
        }
    }
    
    class func findNextOrderInfo(data:[UInt8]!)->Int{
        var fromIndex:Int!
        if (VideoTransUtils.isFooterFrame(data: data)){
            // if it is footer
            fromIndex = data.count - VideoTransUtils.orderSample.count - VideoTransUtils.footerSample.count
        }else{
            // else it is header or body
            fromIndex = data.count - VideoTransUtils.orderSample.count
        }
        
        let toIndex = fromIndex + VideoTransUtils.orderSample.count
        if let orderBytes = data.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            return Int(Data.fromByteArray(orderBytes, Double.self))
        }else{
            return -1
        }
    }
    
    class func isCompletedFrame(data:[UInt8]!)->Bool{
        let hasHeader = isHeaderFrame(data: data)
        let hasFooter = isFooterFrame(data: data)
        if(hasFooter && hasHeader){
            return true
        }else{
            return false
        }
    }
    
    class func isHeaderFrame(data:[UInt8]!)->Bool{
        if let header:[UInt8] = data.arrayElements(fromIndex: 0, toIndex: VideoTransUtils.headerSample.count) as?[UInt8]{
            if(VideoTransUtils.isEqualByteArrays(array1: header, array2: VideoTransUtils.headerSample)){
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    class func isBodyFrame(data:[UInt8]!)->Bool{
        let hasHeader = isHeaderFrame(data: data)
        let hasFooter = isFooterFrame(data: data)
        if(!hasFooter && !hasHeader){
            return true
        }else{
            return false
        }
    }
    
    class func isFooterFrame(data:[UInt8]!)->Bool{
        if let footer:[UInt8] = data.arrayElements(fromIndex: data.count - VideoTransUtils.footerSample.count, toIndex: data.count) as? [UInt8]{
            if(VideoTransUtils.isEqualByteArrays(array1: footer, array2: VideoTransUtils.footerSample)){
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    class func isEqualByteArrays(array1:[UInt8]!, array2:[UInt8]!)->Bool{
        if(array1.count != array2.count){
            return false;
        }
        for index in 0..<array1.count{
            let leftElement = array1[index]
            let rightElement = array2[index]
            if(leftElement != rightElement){
                return false
            }
        }
        return true
    }
    
    
    class func appendMetaInfo(fps: Int,seekTime: Double, sendTime:Double, frameIndex:Int) -> [UInt8] {
        let _fps = fps
        let _seekTime = seekTime
        let _sendTime = sendTime
        let _order = frameIndex
        
        var metaData = [UInt8]()
        let fpsBytes = Data.toByteArray(Double(_fps))
        //        _fps = Int(Data.fromByteArray(fpsBytes, Int.self))
        
        let seekTimeBytes = Data.toByteArray(_seekTime)
        //          _seekTime = Data.fromByteArray(seekTimeBytes, Double.self)
        
        let sendTimeBytes = Data.toByteArray(_sendTime)
        //          _sendTime = Data.fromByteArray(sendTimeBytes, Double.self)
        
        let orderBytes = Data.toByteArray(Double(_order))
        //          _order = Int(Data.fromByteArray(orderBytes, Int.self))
        
        metaData.append(contentsOf: fpsBytes)
        metaData.append(contentsOf: seekTimeBytes)
        metaData.append(contentsOf: sendTimeBytes)
        metaData.append(contentsOf: orderBytes)
        return metaData
    }
    
    class func appendHeader(metaData:[UInt8]!) -> [UInt8] {
        if let processingData = metaData.arrayElements(fromIndex: 0, toIndex: metaData.count) as? [UInt8] {
            var header = [UInt8]()
            header.append(contentsOf: VideoTransUtils.headerSample)
            header.append(contentsOf: processingData)
            return header
        }
        return [UInt8]()
    }
    
    class func appendFooter(metaData:[UInt8]!) -> [UInt8] {
        if let processingData = metaData.arrayElements(fromIndex: 0, toIndex: metaData.count) as? [UInt8] {
            var header = [UInt8]()
            header.append(contentsOf: processingData)
            header.append(contentsOf: VideoTransUtils.footerSample)
            return header
        }
        return [UInt8]()
    }
    
    class func dataContain(dataBytes:[UInt8], subDataBytes:[UInt8]) -> Int{
        if(subDataBytes.count < dataBytes.count){
            return -1
        }
        
        let _max = dataBytes.count - subDataBytes.count + 1
        for ind in 0..<_max {
            let fromIndex = ind
            let toIndex = fromIndex + subDataBytes.count
            if let processingData = dataBytes.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8] {
                let _isEqual = VideoTransUtils.equalBytesArrays(dataBytes1: processingData, dataBytes2: subDataBytes)
                if(_isEqual == true){
                    return ind
                }
            }
        }
        return -1
    }
    
    class func dataContain(data:Data, subData:Data) -> Int{
        let dataBytes:[UInt8] = [UInt8](data)
        let subDataBytes:[UInt8] = [UInt8](subData)
        let subDataIndex = dataContain(dataBytes: dataBytes, subDataBytes: subDataBytes)
        return subDataIndex
    }
    
    
    class func equalBytesArrays(dataBytes1:[UInt8], dataBytes2:[UInt8] ) -> Bool{
        if(dataBytes1.count != dataBytes2.count){
            return false
        }else{
            for ind in 0..<dataBytes1.count {
                let _b1 = dataBytes1[ind]
                let _b2 = dataBytes2[ind]
                if(_b1 != _b2){
                    return false
                }
            }
        }
        return true
    }
    
    class func equalData(data1:Data, data2:Data) -> Bool{
        let dataBytes1:[UInt8] = [UInt8](data1)
        let dataBytes2:[UInt8] = [UInt8](data2)
        return VideoTransUtils.equalBytesArrays(dataBytes1: dataBytes1, dataBytes2: dataBytes2)
    }
    
}
