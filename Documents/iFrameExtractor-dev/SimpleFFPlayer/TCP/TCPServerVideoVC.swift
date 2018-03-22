//
//  UDPServerVideoVC.swift
//  CloudStorage
//
//  Created by tranvanloc on 4/3/17.
//  Copyright © 2017 toshiba. All rights reserved.
//

import UIKit

class TCPServerVideoVC:  ViewControllerTextView,VideoTransferDelegate,VideoReceiverDelegate {
    @IBOutlet weak var portt: UITextField!
    @IBOutlet weak var ipAd: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    
    var server:TCPServer?
    
    var client:TCPClient?
    
    var video:FFDecoder!
    //    var transer:VideoFrameTransfer!
    var receiver:VideoFrameReceiver!
    var videoTranser:VideoTransfer!
    var vContinuousTranser:VTransferContinuous!
    var proceedFrames = [[UInt8]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDefaults()
        receiver = VideoFrameReceiver.init(receiverDelegate: self)
        videoTranser = VideoTransfer.init(videoPath: Utilities.bundlePath("Jellyfish-3-Mbps-1080p-hevc.mkv"), outputSize: CGSize.init(width: 640, height: 480), address: ipAd.text!, port: Int32(portt.text!)!, fps: 30, transferDelegate: self)
        
        vContinuousTranser = VTransferContinuous.init(videoPath: Utilities.bundlePath("Jellyfish-3-Mbps-1080p-hevc.mkv"), outputSize: CGSize.init(width: 640, height: 480), address: ipAd.text!, port: Int32(portt.text!)!, fps: 30, transferDelegate: self)

        
        
//        var localizedString:String = NSLocalizedString("Myster", comment: "")
//        localizedString = NSLocalizedString("Myster", tableName: "Localizable2", bundle: Bundle.main, value: "", comment: "")
//        startButton.setTitle(localizedString, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        videoTranser.loadVideo(fromTime: 0)
        //        playFrames()
        
}
    
    
    func playFrames() {
        Timer.scheduledTimer(timeInterval: Double(1/30), target: self, selector: #selector(showFrameTimer), userInfo: nil, repeats: true)
    }
    
    func showFrameTimer(_ timer:Timer){
        if let _ = receiver.nextFrame(){
            //            let bytes = nextFrame.getImageData()
            let data = receiver.currentFrameData
            DispatchQueue.main.async {
                [unowned self] in
                if let img = UIImage.init(data: data){
                    self.imageView.image = img
                }
            }
        }
    }
    
    //MARK: -VideoTransferDelegate
    func transferBuffer(data:Data) -> Bool{
//        DispatchQueue.init(label: "VideoTransferDelegate.transferBuffer.dataHandle").async {
//            [unowned self] in
//            self.receiver.dataHandle(data: data)
//            //        self.client?.send(data: data)
//        }
        
//        DispatchQueue.init(label: "VideoTransferDelegate.transferBuffer.send").async {
//            [unowned self] in
            self.client?.send(data: data)
//        }
        
        return true
    }
    
    //MARK: -VideoTransferDelegate
    func receiverBuffer(data:Data) -> Bool{
        return true
    }
    
    @IBAction func startServer(_ sender: Any) {
        guard let _ = portt.text else { return  }
        guard let portNumber = Int32(portt.text!) else { return  }
        if server != nil { return }
        server = TCPServer(address: ipAd.text!, port: Int32(portNumber))
        let status:Result = server!.listen()
        switch status
        {
        case Result.success:
            self.startButton.isEnabled = false;
            DispatchQueue.init(label: "abc").async {
                //            DispatchQueue.global(qos: .background).async {
                // Background Thread
                while true {
                    if let client = self.server?.accept() {
                        self.client = client
                        DispatchQueue.main.async {
                            [unowned self] in
                            // Run UI Updates
                            print("Newclient from:\(client.address)[\(client.port)]")
                            
//                            self.videoTranser.loadVideo(fromTime: 0)
                               self.vContinuousTranser.loadVideo(fromTime: 0)
                            
                            self.playFrames()
                        }
                    } else {
                        print("accept error")
                    }
                }
            }
        case Result.failure(let error):
            print(error)
        }
    }
    
    
    @IBAction func send(_ sender: Any) {
        guard let _ = self.client else { return  }
        for index in 0..<20{
            let result =  client?.send(string: "msg")
            print("Result \(index): \(result) message: msg")
        }
    }
    
    @IBAction func stopServer(_ sender: Any) {
        server?.close()
        server = nil
        self.startButton.isEnabled = true;
    }
    
    
    // Server socket example (echo server)
    func echoService(client: TCPClient) {
        print("Newclient from:\(client.address)[\(client.port)]")
        let d = client.read(1024*11)
        //        client.send(data: d!)
        //        client.close()
    }
    
    func saveDefaults() {
        let userDefaults:UserDefaults = UserDefaults.standard
        userDefaults.set(portt.text, forKey: "port")
        userDefaults.set(ipAd.text, forKey: "host")
        userDefaults.synchronize()
    }
    
    func loadDefaults() {
        let userDefaults:UserDefaults = UserDefaults.standard
        if let _port = userDefaults.object(forKey: "port") as? String{
            portt.text = _port
        }
        if let _host = userDefaults.object(forKey: "host") as? String{
            ipAd.text = _host
        }
    }
    
    
    // MARK: - TextViewDelegate, TextFieldDelegate
    override func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        //        self.tap.isEnabled = true;
        super.textViewShouldBeginEditing(textView)
        return true;
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        //        self.tap.isEnabled = true;
        super.textFieldShouldBeginEditing(textField)
        return true;
    }
    
    override func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        self.saveDefaults()
        return true;
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.saveDefaults()
        return true;
    }
    
    override func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        self.saveDefaults()
        return true;
    }
}

