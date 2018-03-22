//
//  WebViewController.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/13/17.
//  Copyright © 2017 jefby. All rights reserved.
//

import UIKit

class WebViewController: ViewControllerTextView,UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var goButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func go(_ sender: Any) {
        if let u = url.text{
            if let addr = URL.init(string: u){
        let request = URLRequest.init(url: addr, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
   webView.loadRequest(request)
        }
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
   
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }

    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }

    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
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
