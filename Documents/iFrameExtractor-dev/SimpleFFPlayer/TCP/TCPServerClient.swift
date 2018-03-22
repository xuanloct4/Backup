//
//  UDPVC2.swift
//  CloudStorage
//
//  Created by tranvanloc on 2/17/17.
//  Copyright © 2017 toshiba. All rights reserved.
//

import UIKit

//import SwiftSocket

class TCPClientVC: ViewControllerTextView {
    @IBOutlet weak var ipAd: UITextField!
    @IBOutlet weak var portt: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    //    let host = "apple.com"
    //    let port = 80
    var client: TCPClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        client = TCPClient(address: host, port: Int32(port))
        
//        let port = Int(portt.text!)
//        client = TCPClient(address: ipAd.text!, port: Int32(port!))
        
        ////       Close Socket
        //        client?.close()
    }
    
    @IBAction func sendButtonAction() {

        let port = Int(portt.text!)
        client = TCPClient(address: ipAd.text!, port: Int32(port!))
        
                guard let client = client else { return }
        switch client.connect(timeout: 10) {
        case .success:
            appendToTextField(string: "Connected to host \(client.address)")
            if let response = sendRequest(string: "GET / HTTP/1.0\n\n", using: client) {
                appendToTextField(string: "Response: \(response)")
            }
        case .failure(let error):
            appendToTextField(string: String(describing: error))
        }
    }
    
    private func sendRequest(string: String, using client: TCPClient) -> String? {
        appendToTextField(string: "Sending data ... ")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            appendToTextField(string: String(describing: error))
            return nil
        }
    }
    
    private func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(1024*12) else { return nil }
        
        return String(bytes: response, encoding: .utf8)
    }
    
    private func appendToTextField(string: String) {
        print(string)
        textView.text = textView.text.appending("\n\(string)")
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
}

class TCPServerVC: ViewControllerTextView {
    @IBOutlet weak var ipAd: UITextField!
    @IBOutlet weak var portt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Server socket example (echo server)
    func echoService(client: TCPClient) {
        print("Newclient from:\(client.address)[\(client.port)]")
        let d = client.read(1024*12)
        client.send(data: d!)
        client.close()
    }
    
    @IBAction func startServer(_ sender: Any) {
        self.testServer()
    }
    
    func testServer() {
         guard let _ = portt.text else { return  }
        guard Int32(portt.text!) != nil else { return  }
        let server = TCPServer(address: ipAd.text!, port: Int32(portt.text!)!)
        switch server.listen() {
        case .success:
            while true {
                if let client = server.accept() {
                    echoService(client: client)
                } else {
                    print("accept error")
                }
            }
        case .failure(let error):
            print(error)
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
    
        
    
    
}

