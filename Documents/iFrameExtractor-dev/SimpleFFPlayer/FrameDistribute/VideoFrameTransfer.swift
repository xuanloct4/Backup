//
//  VideoFrameTransfer.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/5/17.
//  Copyright © 2017 jefby. All rights reserved.
//

import UIKit
import Foundation

@objc
protocol VideoTransferDelegate{
    func transferBuffer(data:Data) -> Bool
}

@objc
class VideoTransfer: NSObject,VideoTransferDelegate {
    var proceedFrames = [[UInt8]]()
    var outputSize:CGSize!
    var fps:Int  = 30
    var frameSize:Int = 10*1024
    var server:TCPServer?
    var video:FFDecoder!
    var timer:Timer!
    var currentTime:Double = 0
    var maxTime:Double = 9999
    weak var transferDelegate: VideoTransferDelegate?
    override init(){
        super.init()
    }
    
    init(videoPath:String,outputSize:CGSize,client:TCPClient?,fps:Int, transferDelegate: VideoTransferDelegate?) {
        super.init()
        self.fps = fps
        self.video = FFDecoder.init(video:videoPath)
        // set output image size
        self.video?.outputWidth = Int32(Int(outputSize.width))
        self.video?.outputHeight = Int32(Int(outputSize.height))
        if let _ = transferDelegate{
            self.transferDelegate = transferDelegate
        }
        //        self.server = TCPServer.init
    }

    
    init(videoPath:String,outputSize:CGSize,address: String, port: Int32,fps:Int, transferDelegate: VideoTransferDelegate?) {
        super.init()
        self.fps = fps
        self.video = FFDecoder.init(video:videoPath)
        // set output image size
        self.video?.outputWidth = Int32(Int(outputSize.width))
        self.video?.outputHeight = Int32(Int(outputSize.height))
        if let _ = transferDelegate{
        self.transferDelegate = transferDelegate
        }
        //        self.server = TCPServer.init
    }
    
    func timerMethod(_ timer:Timer?){
        if(video.stepFrame() == true){
            currentTime = video.currentTime
            let currentImage = video.currentImage.copy() as! UIImage
            self.processCurrentImage(image:currentImage)
            if(currentTime >= maxTime){
                timer?.invalidate()
            }
        }else{
            maxTime = video.currentTime
            timer?.invalidate()
        }
    }
    
    func startTimer(){
        if(timer == nil){
            timer = Timer.scheduledTimer(timeInterval: Double(1/fps), target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
        }
        timer.fire()
    }
    
    func stopTimer(){
        if let _ = timer{
            timer.invalidate()
        }
    }
    
    //    func loadVideo(frameRate:AnyObject) -> Double{
    //        if let _rate = frameRate as? Double{
    //        if(video.stepFrame() == true){
    //            DispatchQueue.init(label: "VideoFrameTransfer.loadVideo.frameRate").async {
    //            self.perform(#selector(self.loadVideo(frameRate:)), with: frameRate, afterDelay: _rate)
    //            }
    //            return video.currentTime
    //        }
    //        }
    //        return -1
    //    }
    
    func loadVideo(fromTime:Double, toTime:Double, frameRate:Int){
        maxTime = toTime
        loadVideo(fromTime: fromTime)
    }
    
    func loadVideo(fromTime:Double){
        stopTimer()
        video.seekTime(fromTime)
        startTimer()
    }
    
    func resumeVideo(toTime:Double){
        maxTime = toTime
        loadVideo(fromTime: currentTime)
    }
    
    func processCurrentImage(image:UIImage){
        let transer = VideoFrameTransfer.init(image: image, sendTime: Date(), seekTime: currentTime, fps: self.fps, transferDelegate: self.transferDelegate)
         transer.processFrameData()
//        self.proceedFrames.append(contentsOf: _proFrames)
    }
    
    //MARK: -VideoTransferDelegate
    func transferBuffer(data:Data) -> Bool{
//        self.proceedFrames.append([UInt8](data))
        if let _ = self.transferDelegate{
        self.transferDelegate!.transferBuffer(data: data)
        }
        return true
    }
}

@objc
class VideoFrameTransfer: NSObject {
     private let procFramesQueue = DispatchQueue(label: "SynchronizedProceedFramesArray", attributes: .concurrent)
    var data:Data!
    var buffer:[UInt8]!
    var frameSize:Int = 10*1024
    var frames: [[UInt8]]!
    var sendTime:Double = 0
    var seekTime:Double = 0
    var fps:Int  = 30
    
    var frameNo:Int = 0
    var buffSize:Int = 0
    
    
    //    var server:TCPServer?
    //    var video:FFDecoder!
    //    var timer:Timer!
    //    var currentTime:Double = 0
    //    var maxTime:Double = 0
    
    var proceedFrameLock = NSLock()
    private weak var transferDelegate: VideoTransferDelegate?
    override init(){
        super.init()
    }
    
    init(image:UIImage!,sendTime:Date,seekTime:Double,fps:Int, transferDelegate: VideoTransferDelegate?) {
        super.init()
        
        self.proceedFrameLock.name = "ProceedFrameLock.seekTime:\(seekTime)"
        
        //        if let dat = UIImagePNGRepresentation(image){
        if let dat = UIImageJPEGRepresentation(image, 0.3){
            buffSize = dat.count
            frameNo = (buffSize - 1)/frameSize + 1
            self.buffer = [UInt8](dat)
            
        }
        //        // or let data: NSData = UIImageJPGRepresentation(image)
        //        let count = dat.length / MemoryLayout<UInt8>.size
        //        // create an array of Uint8
        //        self.buffer = [UInt8](repeating: 0, count: count)
        //        // copy bytes into array
        //        dat.getBytes(&buffer, length:count * MemoryLayout<UInt8>.size)
        
        let sendTimeIntevFrom1970:Double = sendTime.timeIntervalSince1970
        //        self.frameSize = 10*1024
        self.sendTime = sendTimeIntevFrom1970
        self.seekTime = seekTime
        self.fps = fps
        self.transferDelegate = transferDelegate
        
        //        let dat = Data.init(bytes: self.buffer)
        //        self.init(data: dat, sendTime: sendTime, seekTime: seekTime, fps: fps, transferDelegate: transferDelegate)
    }
    
    convenience init(data:Data!,sendTime:Date,seekTime:Double,fps:Int, transferDelegate: VideoTransferDelegate?) {
        let sendTimeIntevFrom1970:Double = sendTime.timeIntervalSince1970
        self.init(data: data, sendTimeInteval: sendTimeIntevFrom1970, seekTime: seekTime, fps: fps, transferDelegate: transferDelegate)
    }
    
    convenience init(data:Data!,sendTimeInteval:Double,seekTime:Double,fps:Int, transferDelegate: VideoTransferDelegate?) {
        let _frSz = 1024*10
        self.init(data: data, frameSize: _frSz, sendTime: sendTimeInteval, seekTime: seekTime, fps: fps, transferDelegate: transferDelegate)
    }
    
    init(data:Data!,frameSize:Int,sendTime:Double,seekTime:Double,fps:Int,transferDelegate: VideoTransferDelegate?) {
        super.init()
        self.data = data
        self.frameSize = frameSize
        //        self.frames = frames
        self.sendTime = sendTime
        self.seekTime = seekTime
        self.fps = fps
        
        self.transferDelegate = transferDelegate
        //        var b = Data.toByteArray(self.data!)
        //        var b:[UInt8] //= [UInt8](dat)
        //                 b = data!.withUnsafeBytes {
        ////                    [UInt8](UnsafeBufferPointer(start: $0, count: dat.count))
        //        Array(UnsafeBufferPointer<UInt8>(start: $0, count: dat.count/MemoryLayout<UInt8>.size))
        //        }
    }
    
    
    func processFrameData() -> [[UInt8]] {
        var proceedFrames = [[UInt8]]()
        //// Divide data into pieces
        frames = self.divideIntoFrames()
//        proceedFrameLock.lock()
//        procFramesQueue.sync(flags:.barrier) {
        if (self.frames.count == 0) {
//            return proceedFrames
        }else if (self.frames.count == 1) {
            // processCompleteData
            let completedData = self.processCompleteData(data: self.frames[0])
            //            let aa = checkFirstAndLast(bytes: 30, in: completedData)
            //            print("processCompleteData: \(aa)")
            
            
            proceedFrames.append(completedData)
            self.transfer(bytes: completedData)
        } else  if (self.frames.count == 2) {
            // Dispatch
            DispatchQueue.init(label: "VideoFrameTransfer.processFrameData.header").async {
                // processHeaderFrameData for element[0]
                let headerData = self.processHeaderFrameData(data: self.frames[0])
                //            let aa = self.checkFirstAndLast(bytes: 30, in: headerData)
                //            print("processHeaderFrameData: \(aa)")
                
                proceedFrames.append(headerData)
                self.transfer(bytes: headerData)
            }
            
            // Dispatch
            DispatchQueue.init(label: "VideoFrameTransfer.processFrameData.footer").async {
                // processFooterFrameData for element[1]
                let footerData = self.processFooterFrameData(data: self.frames[1], order: 1)
                //            let bb = self.checkFirstAndLast(bytes: 30, in: footerData)
                //            print("processFooterFrameData: \(bb)")
                
                proceedFrames.append(footerData)
                self.transfer(bytes: footerData)
            }
        } else {
            //            // Dispatch
            DispatchQueue.init(label: "VideoFrameTransfer.processFrameData.header").async {
                // processHeaderFrameData for element[0]
                let headerData = self.processHeaderFrameData(data: self.frames[0])
                //            let aa = self.checkFirstAndLast(bytes: 30, in: headerData)
                //            print("processHeaderFrameData: \(aa)")
                
                proceedFrames.append(headerData)
                self.transfer(bytes: headerData)
            }
            
            // processFooterFrameData for element[1..count-2]
            for index in 1..<(self.frames.count - 1) {
                // Dispatch
                DispatchQueue.init(label: "VideoFrameTransfer.processFrameData.body.\(index)").async {
                    let bodyData = self.processBodyFrameData(data: self.frames[index], order: index)
                    //                let bb = self.checkFirstAndLast(bytes: 30, in: bodyData)
                    //                print("processBodyFrameData: \(bb)")
                    
                    proceedFrames.append(bodyData)
                    self.transfer(bytes: bodyData)
                }
            }
            
                    // Dispatch
            DispatchQueue.init(label: "VideoFrameTransfer.processFrameData.footer").async {
                let footerData = self.processFooterFrameData(data: self.frames[self.frames.count - 1], order: self.frames.count - 1)
                //            let cc = self.checkFirstAndLast(bytes: 30, in: footerData)
                //            print("processFooterFrameData: \(cc)")
                
                proceedFrames.append(footerData)
                self.transfer(bytes: footerData)
            }
        }
//        }
//        proceedFrameLock.unlock()
        return proceedFrames
    }
    
    func transfer(bytes:[UInt8]!) {
        let data = Data.init(bytes: bytes)
        if let transer = self.transferDelegate {
            let success = transer.transferBuffer(data: data)
            print("Transfered data: \(data)\nSuccess:\(success)")
        }
    }
    
    func divideIntoFrames()-> [[UInt8]] {
        var frames:[[UInt8]] = []
        if buffSize == 0 { return frames }
        ////        let buffSize = self.buffer.count
        //        var subtractedBuffSize:Int = buffSize - 1
        //        var prevFrameNo:Int = subtractedBuffSize/frameSize
        //        var frameNo:Int = prevFrameNo + 1
        for indexx in 0..<frameNo {
            var endIndex:Int = Int(indexx + 1) * Int(frameSize)
            if(endIndex > buffSize){
                endIndex = buffSize
            }
            let startIndex:Int = Int(indexx) * Int(frameSize)
            
            if let frameData = self.buffer.arrayElements(fromIndex: startIndex, toIndex: endIndex) as? [UInt8] {
                if(frameData.count > 0){
                    frames.append(frameData)
                }
            }
        }
        return frames
    }
    
    func processCompleteData(data:[UInt8]!) -> [UInt8] {
        if let processingData = data.arrayElements(fromIndex: 0, toIndex: data.count) as? [UInt8] {
            var _completedFrameData:[UInt8] = processHeaderFrameData(data: processingData)
            _completedFrameData.append(contentsOf:VideoTransUtils.footerSample)
            return _completedFrameData
        }
        return [UInt8]()
    }
    
    func processHeaderFrameData(data:[UInt8]!)  -> [UInt8] {
        if let processingData = data.arrayElements(fromIndex: 0, toIndex: data.count) as? [UInt8] {
            var headerFrameData = [UInt8]()
            let _header = VideoTransUtils.headerSample
            headerFrameData.append(contentsOf: _header)
            let _headHeader = self.appendMetaInfo(frameIndex: 0)
            headerFrameData.append(contentsOf: _headHeader)
            headerFrameData.append(contentsOf: processingData)
            let _footHeader = self.appendMetaInfo(frameIndex: 1)
            headerFrameData.append(contentsOf: _footHeader)
            return headerFrameData
        }
        return [UInt8]()
    }
    
    func processBodyFrameData(data:[UInt8]!, order:Int) -> [UInt8] {
        if let processingData = data.arrayElements(fromIndex: 0, toIndex: data.count) as? [UInt8] {
            var bodyFrameData = [UInt8]()
            let _headBody = self.appendMetaInfo(frameIndex: order)
            bodyFrameData.append(contentsOf: _headBody)
            bodyFrameData.append(contentsOf: processingData)
            let _footBody = self.appendMetaInfo(frameIndex: order + 1)
            bodyFrameData.append(contentsOf: _footBody)
            return bodyFrameData
        }
        return [UInt8]()
    }
    
    func processFooterFrameData(data:[UInt8]!, order:Int) -> [UInt8] {
        if let processingData = data.arrayElements(fromIndex: 0, toIndex: data.count) as? [UInt8] {
            var footerFrameData = [UInt8]()
            let _headFooter = self.appendMetaInfo(frameIndex: order)
            footerFrameData.append(contentsOf: _headFooter)
            footerFrameData.append(contentsOf: processingData)
            var _footHeader = self.appendMetaInfo(frameIndex: order + 1)
            _footHeader.append(contentsOf: VideoTransUtils.footerSample)
            footerFrameData.append(contentsOf: _footHeader)
            return footerFrameData
        }
        return [UInt8]()
    }
    
    
    func appendMetaInfo(frameIndex:Int) -> [UInt8] {
        let _fps = self.fps
        let _seekTime = self.seekTime
        let _sendTime = self.sendTime
        let _order = frameIndex
        
        let metaData = VideoTransUtils.appendMetaInfo(fps: _fps, seekTime: _seekTime, sendTime: _sendTime, frameIndex: _order)
        return metaData
    }
    
    func check(firstBytes: Int, in data:[UInt8]) -> [UInt8]{
        if let firstBytes = data.arrayElements(fromIndex: 0, toIndex: firstBytes) as? [UInt8] {
            return firstBytes
        }
        return [UInt8]()
    }
    
    func check(lastBytes: Int, in data:[UInt8]) -> [UInt8]{
        if let lastBytes = data.arrayElements(fromIndex: data.count - lastBytes - 1, toIndex: data.count) as? [UInt8] {
            return lastBytes
        }
        return [UInt8]()
    }
    
    func checkFirstAndLast(bytes:Int, in data:[UInt8])-> [[UInt8]]{
        var firstAndLast = [[UInt8]]()
        let firstBytes = check(firstBytes: bytes, in: data)
        let lastBytes = check(lastBytes: bytes, in: data)
        firstAndLast.append(firstBytes)
        firstAndLast.append(lastBytes)
        return firstAndLast
    }
}
