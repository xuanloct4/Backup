//
//  VFReceiverContinuous.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/8/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

import UIKit

@objc
class VFReceiverContinuous: VideoFrameReceiver {
    
}


class VFHandlerContinuous: VideoFrameHandler {
    
    func dataHandle(bytes:[UInt8]) -> [UInt8]?{
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
        
        let headerInd = VideoTransUtils.dataContain(dataBytes: bytes, subDataBytes: VideoTransUtils.headerSample)
        let footerInd = VideoTransUtils.dataContain(dataBytes: bytes, subDataBytes: VideoTransUtils.footerSample)
        // If data does not contain header and footer
        if(headerInd == -1 && footerInd == -1){
            // Check if header is partly contained in previous frame or footer is partly contained in next frame
            if(checkPartlyHeaderFooter() == false){
           processBodyFrameData(bytes: bytes)
            }
        } else if(headerInd == -1 && footerInd != -1){
              let nextFrameIndex = footerInd + VideoTransUtils.footerSample.count
            if let footerFrame = bytes.arrayElements(fromIndex: 0, toIndex: nextFrameIndex) as? [UInt8]{
                     if(checkPartlyHeaderFooter() == false){
            processFooterFrameData(bytes: footerFrame)
                }
            }

          if let nextFrame = bytes.arrayElements(fromIndex: nextFrameIndex, toIndex: bytes.count) as? [UInt8]{
          return dataHandle(bytes: nextFrame)
            }
        } else if(headerInd != -1 && footerInd == -1){
            // Append
            if let footerFrame = bytes.arrayElements(fromIndex: 0, toIndex: headerInd) as? [UInt8]{
                     if(checkPartlyHeaderFooter() == false){
                processFooterFrameData(bytes: footerFrame)
                }
            }
      
            if let headerFrame = bytes.arrayElements(fromIndex: headerInd, toIndex: bytes.count) as? [UInt8]{
               return dataHandle(bytes: headerFrame)
            }
        } else if(headerInd != -1 && footerInd != -1){
            // Append
         
            if(headerInd < footerInd){
                   let footerFrameInd = footerInd + VideoTransUtils.footerSample.count
                if let completeFrame = bytes.arrayElements(fromIndex: headerInd, toIndex: footerFrameInd) as? [UInt8]{
                    processCompleteFrameData(bytes: completeFrame)
                }
                
                if let nextFrame = bytes.arrayElements(fromIndex: footerFrameInd, toIndex: bytes.count) as? [UInt8]{
                 return dataHandle(bytes: nextFrame)
                }
                
                let nextFrameIndex = footerInd + VideoTransUtils.footerSample.count
                if let nextFrame = bytes.arrayElements(fromIndex: nextFrameIndex, toIndex: bytes.count) as? [UInt8]{
                    return dataHandle(bytes: nextFrame)
                }
   
            }else{
                
            }
          
            
        }
        return nil
    }
    
    
    func checkPartlyHeaderFooter() -> Bool{
    
        return false
    }
    
    
    func processCompleteFrameData(bytes:[UInt8]!) {
        // Get Info
        let fromIndex = 0
        let toIndex = bytes.count - VideoTransUtils.footFooterSample.count
        if let _dat = bytes.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            processHeaderFrameData(bytes: _dat)
        }
    }
    
    func processHeaderFrameData(bytes:[UInt8]!) {
        let _fps = VideoTransUtils.findFrameRateInfo(data: bytes)
        let _seekTime = VideoTransUtils.findSeekTimeInfo(data: bytes)
        let _sendTime = VideoTransUtils.findSendTimeInfo(data: bytes)
        let headerFrameInfo = VideoFrameInfo.init(data: [], fps: _fps, seekTime: _seekTime, sendTime: _sendTime, order: 1, position: VFPosition.head)
        data.append(headerFrameInfo)
        
        let fromIndex = VideoTransUtils.headHeaderSample.count
        let toIndex = bytes.count
        if let _dat = bytes.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            processBodyFrameData(bytes: _dat)
        }
        
    }
    
    func processBodyFrameData(bytes:[UInt8]!){
        let dataCount = data.count
        if(dataCount > 0){
            let ind = dataCount - 1
            data[ind].data.append(contentsOf: bytes)
        }
    }
    
    func processFooterFrameData(bytes:[UInt8]!) {
        let fromIndex = 0
        let toIndex = bytes.count - VideoTransUtils.footFooterSample.count
        if let _dat = bytes.arrayElements(fromIndex: fromIndex, toIndex: toIndex) as? [UInt8]{
            processBodyFrameData(bytes: _dat)
        }
    }
    
}
