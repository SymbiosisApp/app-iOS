//
//  IntroViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 26/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class BienvenueViewController: IntroViewController{
    
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.layer.zPosition = 2
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
    }
}

class StartViewController: IntroViewController{
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.zPosition = 2
    }
}


