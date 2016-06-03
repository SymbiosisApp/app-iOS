//
//  PollenViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 30/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class PollenViewController: UIViewController {
    let background = Background()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


class DisseminationViewController: PollenViewController{
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.image.layer.zPosition = 1
        background.addGifBackground(self.view, gifView: self.webView, gifSource: "courses")
        pageControl.layer.zPosition = 2
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
    }

}

class RecolteViewController: PollenViewController{
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.layer.zPosition = 2
        self.image.layer.zPosition = 1
        background.addGifBackground(self.view, gifView: self.webView, gifSource: "pollenToFruit")
    }

}

