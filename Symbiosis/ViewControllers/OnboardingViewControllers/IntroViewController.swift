//
//  IntroViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 26/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    let background = Background()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class BienvenueViewController: IntroViewController{
    
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.addGifBackground(self.view, gifView: self.webView, gifSource: "bienvenue")
        webView.layer.zPosition = -1
        pageControl.layer.zPosition = 2
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
    }
}

class StartViewController: IntroViewController{
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.addGifBackground(self.view, gifView: self.webView, gifSource: "bienvenue")
        webView.layer.zPosition = -1
        button.layer.zPosition = 2
    }
}


