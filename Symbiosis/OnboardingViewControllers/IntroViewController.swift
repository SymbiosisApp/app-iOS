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
    let background = Background()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidDisappear(animated: Bool) {

    }
    
}


class IntroPag1ViewController: IntroViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        background.addGifBackground(self.view, gifView: self.introFirst, gifSource: "graine")
    }
    
}

class IntroPag2ViewController: IntroViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        background.adddImageBaclground(self.view, imageSource: "login")
    }
    
}


