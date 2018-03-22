//
//  VFTransferContinuous.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/8/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

import UIKit

@objc
class VTransferContinuous:VideoTransfer{
    override func processCurrentImage(image:UIImage){
        let transer = VFTransferContinuous.init(image: image, sendTime: Date(), seekTime: currentTime, fps: self.fps, transferDelegate: self.transferDelegate)
        transer.processFrameData()
        //        self.proceedFrames.append(contentsOf: _proFrames)
    }
}

@objc
class VFTransferContinuous: VideoFrameTransfer {
    override func processFrameData() -> [[UInt8]] {
        var proceedFrames = [[UInt8]]()
        //// Divide data into pieces
        frames = self.divideIntoFrames()
        if (self.frames.count == 0) {
            //            return proceedFrames
        }else if (self.frames.count == 1) {
            // processCompleteData
            let completedData = self.processCompleteData(data: self.frames[0])
            proceedFrames.append(completedData)
            self.transfer(bytes: completedData)
        } else  if (self.frames.count == 2) {
            // processHeaderFrameData for element[0]
            let headerData = self.processHeaderFrameData(data: self.frames[0])
            proceedFrames.append(headerData)
            self.transfer(bytes: headerData)

                // processFooterFrameData for element[1]
                let footerData = self.processFooterFrameData(data: self.frames[1], order: 1)
                proceedFrames.append(footerData)
                self.transfer(bytes: footerData)
                
            } else {
                // processHeaderFrameData for element[0]
                let headerData = self.processHeaderFrameData(data: self.frames[0])
                proceedFrames.append(headerData)
                self.transfer(bytes: headerData)
            
                // processFooterFrameData for element[1..count-2]
                for index in 1..<(self.frames.count - 1) {
                    let bodyData = self.processBodyFrameData(data: self.frames[index], order: index)
                    proceedFrames.append(bodyData)
                    self.transfer(bytes: bodyData)
                    
                }
                let footerData = self.processFooterFrameData(data: self.frames[self.frames.count - 1], order: self.frames.count - 1)

                proceedFrames.append(footerData)
                self.transfer(bytes: footerData)
            }
            return proceedFrames
        }
        
        
        
        override func processBodyFrameData(data:[UInt8]!, order:Int) -> [UInt8] {
            if let processingData = data.arrayElements(fromIndex: 0, toIndex: data.count) as? [UInt8] {
                return processingData
            }
            return [UInt8]()
        }
        
        override func processCompleteData(data:[UInt8]!) -> [UInt8] {
            if let processingData = data.arrayElements(fromIndex: 0, toIndex: data.count) as? [UInt8] {
                var _completedFrameData:[UInt8] = processHeaderFrameData(data: processingData)
                _completedFrameData = processFooterFrameData(data: _completedFrameData, order: 0)
                return _completedFrameData
            }
            return [UInt8]()
        }
        
        override func processHeaderFrameData(data:[UInt8]!)  -> [UInt8] {
            if let processingData = data.arrayElements(fromIndex: 0, toIndex: data.count) as? [UInt8] {
                var headerFrameData = [UInt8]()
                let _header = VideoTransUtils.headerSample
                headerFrameData.append(contentsOf: _header)
                let _headHeader = self.appendMetaInfo(frameIndex: 0)
                headerFrameData.append(contentsOf: _headHeader)
                headerFrameData.append(contentsOf: processingData)
                return headerFrameData
            }
            return [UInt8]()
        }
        
        override func processFooterFrameData(data:[UInt8]!, order:Int) -> [UInt8] {
            if let processingData = data.arrayElements(fromIndex: 0, toIndex: data.count) as? [UInt8] {
                var footerFrameData = [UInt8]()
                footerFrameData.append(contentsOf: processingData)
                var _footHeader = self.appendMetaInfo(frameIndex: order + 1)
                _footHeader.append(contentsOf: VideoTransUtils.footerSample)
                footerFrameData.append(contentsOf: _footHeader)
                return footerFrameData
            }
            return [UInt8]()
        }
        
        
        //  override func processFrameData() -> [[UInt8]] {
        //        var proceedFrames = [[UInt8]]()
        //        //// Divide data into pieces
        //        frames = self.divideIntoFrames()
        //        if (self.frames.count == 0) {
        //            //            return proceedFrames
        //        }else if (self.frames.count == 1) {
        //            // processCompleteData
        //            let completedData = self.processCompleteData(data: self.frames[0])
        //            //            let aa = checkFirstAndLast(bytes: 30, in: completedData)
        //            //            print("processCompleteData: \(aa)")
        //
        //
        //            proceedFrames.append(completedData)
        //            self.transfer(bytes: completedData)
        //        } else {
        //            //            // Dispatch
        //            DispatchQueue.init(label: "VideoFrameTransfer.processFrameData.header").async {
        //                // processHeaderFrameData for element[0]
        //                let headerData = self.processHeaderFrameData(data: self.frames[0])
        //                //            let aa = self.checkFirstAndLast(bytes: 30, in: headerData)
        //                //            print("processHeaderFrameData: \(aa)")
        //
        //                proceedFrames.append(headerData)
        //                self.transfer(bytes: headerData)
        //            }
        //
        //            // processFooterFrameData for element[1..count-2]
        //            for index in 1..<(self.frames.count - 1) {
        //                // Dispatch
        //                DispatchQueue.init(label: "VideoFrameTransfer.processFrameData.body.\(index)").async {
        //                    let bodyData = self.processBodyFrameData(data: self.frames[index], order: index)
        //                    //                let bb = self.checkFirstAndLast(bytes: 30, in: bodyData)
        //                    //                print("processBodyFrameData: \(bb)")
        //
        //                    proceedFrames.append(bodyData)
        //                    self.transfer(bytes: bodyData)
        //                }
        //            }
        //
        //            // Dispatch
        //            DispatchQueue.init(label: "VideoFrameTransfer.processFrameData.footer").async {
        //                let footerData = self.processFooterFrameData(data: self.frames[self.frames.count - 1], order: self.frames.count - 1)
        //                //            let cc = self.checkFirstAndLast(bytes: 30, in: footerData)
        //                //            print("processFooterFrameData: \(cc)")
        //                
        //                proceedFrames.append(footerData)
        //                self.transfer(bytes: footerData)
        //            }
        //        }
        //        //        }
        //        //        proceedFrameLock.unlock()
        //        return proceedFrames
        //    }
        
        
}
