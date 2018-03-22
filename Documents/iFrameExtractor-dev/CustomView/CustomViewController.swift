//
//  CustomViewController.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/9/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    @IBOutlet weak var customView: CustomView!

    var v: CustomView1!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "CustomView1", bundle: Bundle.init(for: CustomView1.self)).instantiate(withOwner: self, options: nil)
let views = Bundle.main.loadNibNamed("CustomView1", owner: self, options: nil)
//     v = nib[0] as! CustomView
         v = views?[0] as! CustomView1
        self.view.addSubview(v)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         let rect = customView.frame
         v.frame = rect
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
