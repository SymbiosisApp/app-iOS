//
//  SYPopup.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 01/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class SYPopup: UIViewController{
    
    let background = Background()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("popup")
        
        background.adddImageBaclground(self.view, imageSource: "page1.png")
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    
}