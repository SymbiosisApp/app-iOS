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
        //addGifBackground(self.introFirst, gifSource: "graine");
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        self.introFirst.hidden = true
    }
    
    
    func addGifBackground(gifView:UIWebView, gifSource: String){
        
        let filePath = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource(gifSource, withExtension:"gif")!)
        
        let webViewBG = gifView
        
        webViewBG.loadData(filePath!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false;
        self.view.addSubview(webViewBG)
    }
    
}
