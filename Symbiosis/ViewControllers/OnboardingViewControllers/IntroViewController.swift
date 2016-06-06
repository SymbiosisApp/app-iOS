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
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chatGif = UIImage.gifWithName("bienvenue")
        let imageView = UIImageView(image: chatGif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(imageView)
        
        self.image.layer.zPosition = 1
        pageControl.layer.zPosition = 2
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
    }
}

class StartViewController: IntroViewController{
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chatGif = UIImage.gifWithName("bienvenue")
        let imageView = UIImageView(image: chatGif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(imageView)
        
        self.image.layer.zPosition = 1
        button.layer.zPosition = 2
    }
}


