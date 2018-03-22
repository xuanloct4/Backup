//
//  CustomView1.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/9/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

import UIKit

class CustomView1: UIView {
    //    @IBOutlet weak var button1: UIButton!
    //    @IBOutlet weak var button2: UIButton!
     override func awakeFromNib(){
        print("")
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initSubViews()
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        initSubViews()
    }
    
    func initSubViews(){
        let nib = UINib.init(nibName: "CustomView", bundle: nil).instantiate(withOwner: self, options: nil)
        //               let v = nib[0] as! CustomView
        //        v.frame = self.bounds
        //self.addSubview(v)
        
        //        contentView.frame = self.frame
        //        var bol = false
        //        for v in self.subviews{
        //            if(v == contentView){
        //            bol = true
        //            }
        //        }
        //        if(bol == false){
        //        self.addSubview(contentView)
        //        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initSubViews()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
