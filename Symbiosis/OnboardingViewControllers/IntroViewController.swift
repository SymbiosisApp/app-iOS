//
//  IntroViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 26/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    
    @IBOutlet weak var introFirst: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        let gif = OnboardingGif()
        gif.addGifBackground(self.view, gifView: self.introFirst, gifSource: "graine")
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        self.introFirst.hidden = true
    }
   
    
}
