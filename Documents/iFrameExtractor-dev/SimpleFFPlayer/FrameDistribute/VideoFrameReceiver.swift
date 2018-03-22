//
//  VideoFrameReceiver.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/5/17.
//  Copyright © 2017 jefby. All rights reserved.
//

import UIKit

@objc
protocol VideoReceiverDelegate{
    func receiverBuffer(data:Data) -> Bool
}

@objc
protocol VideoFrameReceiverDelegate{
    func receiverNewFrame(frameHandler:VideoFrameHandler)
}

@objc
class VideoFrameReceiver : NSObject,VideoFrameReceiverDelegate {
    //    private let handlerQueue = DispatchQueue(label: "SynchronizedHandlerArray", attributes: .concurrent)
    //  private let finishQueue = DispatchQueue(label: "SynchronizedFinishArray", attributes: .concurrent)
    
    
    var handleLock:NSLock! = NSLock.init()
    var finishLock:NSLock! = NSLock.init()
    
    var finishFrHandler:[VideoFrameHandler] = []
    var videoFrHandler:[VideoFrameHandler] = []
    private weak var receiverDelegate: VideoReceiverDelegate?
    
    
    var currentTime:Double = 0
    var currentFrameData: Data = Data.init(bytes: [UInt8]())
    
    init(receiverDelegate:VideoReceiverDelegate?){
        super.init()
        if let _ = receiverDelegate{
            self.receiverDelegate = receiverDelegate!
        }
        
        handleLock.name = "HandleLock"
        finishLock.name = "FinishLock"
    }
    
    func playFrame(from time:Double){
        //        objc_sync_enter(finishFrHandler)
        if(finishFrHandler.count >= 2){
            let lowerTimeLim = finishFrHandler[0].getSeekTime()
            let upperTimeLim = finishFrHandler[finishFrHandler.count - 1].getSeekTime()
            if((time <= upperTimeLim) && (time >= lowerTimeLim)){
                let seekTimeFrIndex = findFrameIndex(at: time)
                for ind in 0..<seekTimeFrIndex{
                    let index = seekTimeFrIndex - ind + 1
                    finishFrHandler.remove(at: index)
                }
                let _hdl = finishFrHandler[seekTimeFrIndex]
                currentTime = _hdl.getSeekTime()
                currentFrameData = Data.init(bytes: _hdl.getImageData())
                objc_sync_exit(finishFrHandler)
                return
            }
        }
        
        // TO DO
        // Load new data from time
        
        
        //        objc_sync_exit(finishFrHandler)
    }
    
    func nextFrame() -> VideoFrameHandler?{
        var hdl:VideoFrameHandler? = nil
        //        objc_sync_enter(finishFrHandler)
        //        self.finishQueue.sync(flags:.barrier) {
        //        finishLock.lock()
        let _hdlIndex = self.findFrameIndex(at: self.currentTime)
        if (_hdlIndex >= 0){
            if(_hdlIndex < self.finishFrHandler.count - 1){
                hdl = self.finishFrHandler[_hdlIndex + 1]
                self.currentTime = hdl!.getSeekTime()
                self.currentFrameData = Data.init(bytes: hdl!.getImageData())
            }
        }
        //        finishLock.unlock()
        //        }
        return hdl
    }
    
    func findFrameIndex(at seektime:Double) -> Int{
        var position = -1
        if(finishFrHandler.count == 0){
            return position
        }else if(finishFrHandler.count == 1){
            //            if(_newHdlSeekTime < _hdlSeekTime){
            //                finishFrHandler.insert(newHandler, at: 0)
            //            }else{
            //                finishFrHandler.insert(newHandler, at: 1)
            //            }
            return 0
        }else{
            //              self.finishQueue.sync(flags:.barrier) {
            //            finishLock.lock()
            let limit = self.finishFrHandler.count-1
            for ind in 0..<limit {
                let index = self.finishFrHandler.count - ind - 1
                let _hdlAfter = self.finishFrHandler[index]
                let _hdlBefore = self.finishFrHandler[index-1]
                let _hdlAfterSeekTime = _hdlAfter.getSeekTime()
                let _hdlBeforeSeekTime = _hdlBefore.getSeekTime()
                if(seektime < _hdlBeforeSeekTime){
                    position = index - 1
                }else if(seektime == _hdlBeforeSeekTime){
                    position = index - 1
                    break
                }else if(seektime == _hdlAfterSeekTime){
                    position = index
                    break
                }else {
                    if(seektime < _hdlAfterSeekTime){
                        position = index
                        break
                    }else{
                        position = index + 1
                        break
                    }
                }
            }
            //            finishLock.unlock()
            //            }
        }
        return position
    }
    
    func findFrame(at seektime:Double) -> VideoFrameHandler?{
        var hdl:VideoFrameHandler? = nil
        //        self.finishQueue.sync(flags:.barrier) {
        //        finishLock.lock()
        let _hdlIndex = self.findFrameIndex(at: seektime)
        if (_hdlIndex >= 0){
            if(_hdlIndex < self.finishFrHandler.count){
                hdl = self.finishFrHandler[_hdlIndex]
            }
        }
        //        finishLock.unlock()
        //        }
        return hdl
    }
    
    func removeHandler(handler:VideoFrameHandler){
        print("VideoFrameReceiver.removeHandler.handler.label = \(handler.label)")
        //        DispatchQueue(label: handler.label, attributes: .concurrent).sync(flags:.barrier) {
        handleLock.lock()
        let _hdlIndex = self.getFrameHandlerIndex(handler: handler)
        if (_hdlIndex >= 0){
            self.videoFrHandler.remove(at: _hdlIndex)
            print("VideoFrameReceiver.removeHandler.videoFrHandler.removeat : \(_hdlIndex)")
        }
        handleLock.unlock()
        //        }
    }
    
    func arangeVideoHandlers(newHandler:VideoFrameHandler){
        //        self.finishQueue.sync(flags:.barrier) {
        finishLock.lock()
        if(self.finishFrHandler.count == 0){
            self.finishFrHandler.insert(newHandler, at: 0)
        }
        else if(self.finishFrHandler.count == 1){
            let _hdl = self.finishFrHandler[0]
            let _hdlSeekTime = _hdl.getSeekTime()
            let _newHdlSeekTime = newHandler.getSeekTime()
            if(_newHdlSeekTime < _hdlSeekTime){
                self.finishFrHandler.insert(newHandler, at: 0)
            }else{
                self.finishFrHandler.insert(newHandler, at: 1)
            }
        }
        else{
            let limit = self.finishFrHandler.count-1
            var position = -1
            for ind in 0..<limit {
                let index = self.finishFrHandler.count - ind - 1
                let _hdlAfter = self.finishFrHandler[index]
                let _hdlBefore = self.finishFrHandler[index-1]
                //            let _hdlBeforeLock = _hdlAfter.lock
                //            let _hdlAfterLock = _hdlAfter.lock
                //            let newhandlerLock = newHandler.lock
                let _hdlAfterSeekTime = _hdlAfter.getSeekTime()
                let _hdlBeforeSeekTime = _hdlBefore.getSeekTime()
                let _newHdlSeekTime = newHandler.getSeekTime()
                if(_newHdlSeekTime < _hdlBeforeSeekTime){
                    position = index - 1
                }else {
                    if(_newHdlSeekTime < _hdlAfterSeekTime){
                        position = index
                        break
                    }else{
                        position = index + 1
                        break
                    }
                }
            }
            if(position >= 0) {
                self.finishFrHandler.insert(newHandler, at: position)
            }
        }
        finishLock.unlock()
        //        }
    }
    
    func dataHandle(dataSet:Set<Data>){
        for dat in dataSet{
            let bytes:[UInt8] = [UInt8](dat)
            dataHandle(bytes: bytes)
        }
    }
    
    func dataHandle(frames:[[UInt8]]){
        print("VideoFrameReceiver.dataHandler.frames.size = \(frames.count)")
        //        if(frames.count == 0){ return }
        //        let label = "\(VideoTransUtils.findSeekTimeInfo(data: frames[0]))"
        //        let handler = self.getFrameHandler(by: label)
        //        handler.dataHandle(frames: frames)
        for frame in frames{
            //                            DispatchQueue.init(label: "dataHandler").async {
            //                                [unowned self] in
            DispatchQueue.init(label: "VideoFrameReceiver.dataHandle").async {
                [unowned self] in
                self.dataHandle(bytes: frame)
            }
            //                            }
        }
    }
    
    func dataHandle(data:Data){
        let bytes:[UInt8] = [UInt8](data)
        DispatchQueue.init(label: "VideoFrameReceiver.dataHandle").async {
            [unowned self] in
            print("VideoFrameReceiver.dataHandler.bytes.size = \(bytes.count)")
            let label = "\(VideoTransUtils.findSeekTimeInfo(data: bytes))"
            let handler = self.getFrameHandler(by: label)
            handler.dataHandle(frames: [bytes])
        }
    }
    
    func dataHandle(bytes:[UInt8]){
        print("VideoFrameReceiver.dataHandler.bytes.size = \(bytes.count)")
        let label = "\(VideoTransUtils.findSeekTimeInfo(data: bytes))"
        let handler = self.getFrameHandler(by: label)
        handler.dataHandle(frames: [bytes])
    }
    
    func getFrameHandler(by label:String) -> VideoFrameHandler{
        print("VideoFrameReceiver.getFrameHandler.label = \(label)")
        var hdl:VideoFrameHandler!
        //DispatchQueue(label: label, attributes: .concurrent).sync(flags:.barrier) {
        handleLock.lock()
        for index in 0..<self.videoFrHandler.count {
            if(self.videoFrHandler[index].label == label){
                //                 objc_sync_exit(videoFrHandler)
                hdl = self.videoFrHandler[index]
                handleLock.unlock()
                return hdl
            }
        }
        
        //         objc_sync_exit(videoFrHandler)
        let newHandler = VideoFrameHandler.init(frameReceiver: self, label: label)
        self.videoFrHandler.append(newHandler)
        hdl = self.videoFrHandler[self.videoFrHandler.count - 1]
        handleLock.unlock()
        //        }
        
        print("VideoFrameReceiver.getFrameHandler.hdl.label = \(hdl.label!)")
        return hdl
    }
    
    func getFrameHandlerIndex(handler:VideoFrameHandler) -> Int{
        print("VideoFrameReceiver.getFrameHandlerIndex.handler.label = \(handler.label)")
        var frHdlIndex = -1
        //     DispatchQueue(label: handler.label, attributes: .concurrent).sync(flags:.barrier) {
        //        handleLock.lock()
        for index in 0..<self.videoFrHandler.count {
            let _handler = self.videoFrHandler[index]
            if(_handler.label == handler.label){
                frHdlIndex = index
            }
        }
        //        handleLock.unlock()
        //        }
        print("VideoFrameReceiver.getFrameHandlerIndex.handler.index = \(frHdlIndex) .videoFrHandler.size = \(self.videoFrHandler.count)")
        return frHdlIndex
    }
    
    //    func finishFrameHandler(handler:VideoFrameHandler){
    //        objc_sync_enter(videoFrHandler)
    //        let imgData = handler.getImageData()
    //        receive(bytes: imgData)
    //        let index = getFrameHandlerIndex(handler: handler)
    //        videoFrHandler.remove(at: index)
    //        objc_sync_exit(videoFrHandler)
    //    }
    
    // MARK: VideoFrameReceiverDelegate
    func receiverNewFrame(frameHandler:VideoFrameHandler){
        DispatchQueue.init(label: "arangeVideoHandlers").async {
            self.arangeVideoHandlers(newHandler: frameHandler)
        }
        DispatchQueue.init(label: "removeHandler").async {
            self.removeHandler(handler: frameHandler)
        }
    }
    
    // MARK: VideoReceiverDelegate
    func receive(bytes:[UInt8]!) {
        let data = Data.init(bytes: bytes)
        if let receiver = self.receiverDelegate {
            let success = receiver.receiverBuffer(data: data)
            print("Transfered data: \(data)\nSuccess:\(success)")
        }
    }
}

@objc
class VideoFrameHandler : NSObject {
    weak var frameReceiver:VideoFrameReceiverDelegate!
    var dataLock = NSLock()
    var data:[VideoFrameInfo] = []
    var lock:VALock!
    var label:String!
    
    var frames:[VideoFrameInfo] = []
    var processingFrames:[VideoFrameInfo] = []
    var waitingFrames:[VideoFrameInfo] = []
    
    init(frameReceiver:VideoFrameReceiverDelegate, label: String){
        super.init()
        self.label = label
        self.frameReceiver = frameReceiver
        if(lock == nil){
            lock = VALock.init(label: self.label)
        }
        dataLock.name = "DataLock"
    }
    
    func getSeekTime()->Double{
        var seekTime:Double = -1
        if(data.count > 0) {
            seekTime = data[0].seekTime
        }
        return seekTime
    }
    
    func getSendTime()->Double{
        var sendTime:Double = -1
        if(data.count > 0) {
            sendTime = data[0].sendTime
        }
        return sendTime
    }
    
    func getFrameRate()->Int{
        var fps:Int = -1
        if(data.count > 0) {
            fps = data[0].fps
        }
        return fps
    }
    
    func getImageData()->[UInt8]{
        var imagData:[UInt8] = []
        for ind in 0..<data.count {
            let _dat = data[ind].data
            imagData.append(contentsOf: _dat)
        }
        return imagData
    }
    
    func replace(frame:VideoFrameInfo, to index:Int){
        dataLock.lock()
        if (index < data.count){
            data[index] = frame
        }else{
            for _ in data.count..<index {
                data.append(VideoFrameInfo.init())
            }
            data.append(frame)
        }
        dataLock.unlock()
    }
    
    
    func getFrameBy(seekTime:Double, collection:[VideoFrameInfo]) -> VideoFrameInfo? {
        for index in 0..<collection.count {
            let item = collection[index]
            let _itSeekTime = item.seekTime
            if (_itSeekTime == seekTime) {
                return collection[index]
            }
        }
        return nil
    }
    
    func dataHandle(frames:[[UInt8]]){
        let startTime1 = Date.timeIntervalSinceReferenceDate
        lock.unlockClosure = {
            obj in
            //            if let data = obj as? [VideoFrameInfo]{
            //                let handler = VideoFrameHandler.init(frameReceiver: self.frameReceiver, label: self.label)
            //                handler.data = data
            //                handler.lock = self.lock
            //          self.frameReceiver.receiverNewFrame(frameHandler: handler)
            self.frameReceiver.receiverNewFrame(frameHandler: self)
            let endTime1 = Date.timeIntervalSinceReferenceDate
            let processTime1 = endTime1 - startTime1
            print("Process time for receive is: \(processTime1)")
            //            }
        }
        for bytes in frames{
            DispatchQueue.init(label: self.label).async {
                [unowned self] in
                if (VideoTransUtils.isHeaderFrame(data: bytes)) {
                    let _info = self.createFrameInfo(bytes: bytes)
                    self.replace(frame: _info, to: 0)
                    self.lock.lock(object: self.data as AnyObject)
                }
                    
                    // else if it contain only footer
                    // processFooterFrameData
                else if (VideoTransUtils.isFooterFrame(data: bytes)) {
                    let _order = VideoTransUtils.findOrderInfo(data: bytes)
                    let _info = self.createFrameInfo(bytes: bytes)
                    self.replace(frame: _info, to: _order)
                    self.lock.lock(object: self.data as AnyObject){
                        count in
                        if count == _order + 1{
                            return true
                        }else{
                            return false
                        }
                    }
                }
                    
                    //else it contain none of header and footer
                    // processBodyFrameData
                else if (VideoTransUtils.isBodyFrame(data: bytes)) {
                    let _order = VideoTransUtils.findOrderInfo(data: bytes)
                    let _info = self.createFrameInfo(bytes: bytes)
                    self.replace(frame: _info, to: _order)
                    self.lock.lock(object: self.data as AnyObject)
                }else{
                    print("Strange bytes")
                }
            }
        }
    }
    
    func createFrameInfo(bytes: [UInt8]) -> VideoFrameInfo{
        let _data = VideoTransUtils.findData(data: bytes)
        let _fps = VideoTransUtils.findFrameRateInfo(data: bytes)
        let _seekTime = VideoTransUtils.findSeekTimeInfo(data: bytes)
        let _sendTime = VideoTransUtils.findSendTimeInfo(data: bytes)
        let _info = VideoFrameInfo.init(data: _data, fps: _fps, seekTime: _seekTime, sendTime: _sendTime)
        return _info
    }
    
    //    func dataHandle(bytes:[UInt8]){
    //        // If data contain both header and footer mark
    //        // processCompleteData
    //        if (VideoTransUtils.isCompletedFrame(data: bytes)) {
    //            self.processCompleteData(data: bytes)
    //        }
    //
    //            // else if it contain only header
    //            // processHeaderFrameData
    //        else if (VideoTransUtils.isHeaderFrame(data: bytes)) {
    //            self.processHeaderFrameData(data: bytes)
    //        }
    //
    //            // else if it contain only footer
    //            // processFooterFrameData
    //        else if (VideoTransUtils.isFooterFrame(data: bytes)) {
    //            self.processFooterFrameData(data: bytes)
    //        }
    //
    //            //else it contain none of header and footer
    //            // processBodyFrameData
    //        else if (VideoTransUtils.isBodyFrame(data: bytes)) {
    //            self.processBodyFrameData(data: bytes)
    //        }
    //
    //    }
    //
    //    func dataHandle(data:Data?){
    //        guard let _ = data else { return }
    //        let byteArray = [UInt8](data!)
    //       dataHandle(bytes:byteArray)
    //    }
    
    
    
    func processCompleteData(data:[UInt8]!)-> VideoFrameInfo{
        // Get Info
        let _data = VideoTransUtils.findData(data: data)
        let _fps = VideoTransUtils.findFrameRateInfo(data: data)
        let _seekTime = VideoTransUtils.findSeekTimeInfo(data: data)
        let _sendTime = VideoTransUtils.findSendTimeInfo(data: data)
        
        // Append new frame to frames
        let appFrame = VideoFrameInfo.init(data: _data, fps: _fps, seekTime: _seekTime,sendTime: _sendTime)
        //        self.frames.append(appFrame)
        return appFrame
    }
    
    //    func processHeaderWaitingFrame(frame:VideoFrameInfo){
    //        var headerFrameData = [UInt8]()
    //        let _header = VideoTransUtils.headerSample
    //        headerFrameData.append(contentsOf: _header)
    //        let _headHeader = VideoTransUtils.appendMetaInfo(fps: frame.fps, seekTime: frame.seekTime, sendTime: frame.sendTime, frameIndex: 0)
    //        headerFrameData.append(contentsOf: _headHeader)
    //        headerFrameData.append(contentsOf: frame.data)
    //        let _footHeader = VideoTransUtils.appendMetaInfo(fps: frame.fps, seekTime: frame.seekTime, sendTime: frame.sendTime, frameIndex: 1)
    //        headerFrameData.append(contentsOf: _footHeader)
    //        let headFrameInfo = VideoFrameInfo.init(data: headerFrameData, fps: fps, seekTime: seekTime,sendTime: sendTime)
    //        processingFrames.append()
    //    }
    
    //    func processBodyWaitingFrame(order:Int, seekTime:Double){
    func processBodyWaitingFrame(){
        for _frame in self.waitingFrames{
            for index in 0..<self.processingFrames.count{
                let _procFrame = self.processingFrames[index]
                let _frSeekTimeInfo = _frame.seekTime
                let _frOrder = _frame.order
                
                let _procFrSeekTimeInfo = _procFrame.seekTime
                let _procFrfrOrderInfo = _procFrame.order
                // If it is the same frame and sequential data
                let isSameFrame = (_procFrSeekTimeInfo == _frSeekTimeInfo)
                let isSequential = (_frOrder == _procFrfrOrderInfo)
                if(isSameFrame && isSequential){
                    let _wFrameData = VideoTransUtils.removeHeaderInfo(data: _frame.data)
                    let _nextOrder = VideoTransUtils.findNextOrderInfo(data: _wFrameData)
                    self.processingFrames[index].order = _nextOrder
                    self.processingFrames[index].data.append(contentsOf: _wFrameData)
                    // Dispatch
                    let processWaitFrameQueue = DispatchQueue.init(label: "processWaitFrameQueue.processBodyFrameData.VideoFrameReceiver")
                    processWaitFrameQueue.async {
                        self.processBodyWaitingFrame()
                    }
                }
            }
        }
    }
    
    func processHeaderFrameData(data:[UInt8]!)-> VideoFrameInfo{
        let _fps = VideoTransUtils.findFrameRateInfo(data: data)
        let _seekTime = VideoTransUtils.findSeekTimeInfo(data: data)
        let _sendTime = VideoTransUtils.findSendTimeInfo(data: data)
        let headerFrameInfo = VideoFrameInfo.init(data: data, fps: _fps, seekTime: _seekTime, sendTime: _sendTime, order: 1, position: VFPosition.head)
        //        processingFrames.append(headerFrameInfo)
        return headerFrameInfo
    }
    
    func processBodyFrameData(data:[UInt8]!) -> VideoFrameInfo{
        //        // Find sibling frame data
        //        for index in 0..<processingFrames.count{
        //            let fr = processingFrames[index]
        //            let seekTimeInfo = VideoTransUtils.findSeekTimeInfo(data: data)
        //            let orderInfo = VideoTransUtils.findOrderInfo(data: data)
        //
        //            let frSeekTimeInfo = fr.seekTime
        //            let frNextOrderInfo = fr.order
        //
        //            // If it is the same frame and sequential data
        //            let isSameFrame = (seekTimeInfo == frSeekTimeInfo)
        //            let isSequential = (orderInfo == frNextOrderInfo)
        //
        //            if(isSameFrame && isSequential){
        //                // Remove footer info from previous data
        //                var _removedData = VideoTransUtils.removeFooterInfo(data:  processingFrames[index].data)
        //
        //                // Remove header info from data
        //                let appendedData = VideoTransUtils.removeHeaderInfo(data: data)
        //
        //                // Append data
        //                _removedData.append(contentsOf: appendedData)
        //
        //                let _order = VideoTransUtils.findNextOrderInfo(data: _removedData)
        //                processingFrames[index].order = _order
        //                processingFrames[index].data = _removedData
        //
        //                // Dispatch
        //                let processWaitFrameQueue = DispatchQueue.init(label: "processWaitFrameQueue.processBodyFrameData.VideoFrameReceiver")
        //                processWaitFrameQueue.async {
        //                    self.processBodyWaitingFrame()
        //                }
        //
        //                return index
        //            }else{
        // Add those to waiting list
        let _fps = VideoTransUtils.findFrameRateInfo(data: data)
        let _seekTime = VideoTransUtils.findSeekTimeInfo(data: data)
        let _sendTime = VideoTransUtils.findSendTimeInfo(data: data)
        let _order = VideoTransUtils.findOrderInfo(data: data)
        let _waitFrameInfo = VideoFrameInfo.init(data: data, fps: _fps, seekTime: _seekTime, sendTime: _sendTime, order: _order, position: VFPosition.body)
        //                self.waitingFrames.append(_waitFrameInfo)
        //            }
        //        }
        //        return -1
        return _waitFrameInfo
    }
    
    func processFooterFrameData(data:[UInt8]!) -> VideoFrameInfo{
        //        // Dispatch
        //        let index = processBodyFrameData(data: data)
        //        if index >= 0{
        //            //            // Get Info
        //            //            let seekTime = VideoTransUtils.findSeekTimeInfo(data: processingFrames[index])
        //            //            let fps = VideoTransUtils.findFrameRateInfo(data: processingFrames[index])
        //            //            let sendTime = VideoTransUtils.findSendTimeInfo(data: processingFrames[index])
        //
        //            // Remove header info
        //            var _removedData = VideoTransUtils.removeHeaderInfo(data:  processingFrames[index].data)
        //
        //            // Remove footer info
        //            _removedData = VideoTransUtils.removeFooterInfo(data: _removedData)
        //
        //            processingFrames[index].data = _removedData
        //
        //            // Finish and append new frame to frames
        //            let appFrame = processingFrames[index]
        //            self.receive(bytes: appFrame.data)
        //            self.frames.append(appFrame)
        //            // Remove data from processingFrames
        //            processingFrames.remove(at: index)
        //        }
        
        let fr = processBodyFrameData(data: data)
        return fr
    }
    
}
