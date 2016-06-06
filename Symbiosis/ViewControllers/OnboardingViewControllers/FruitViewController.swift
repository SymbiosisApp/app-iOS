//
//  FruitViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 30/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class FruitViewController: UIViewController {
    let background = Background()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


class EclosionViewController: FruitViewController{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.image.layer.zPosition = 1
        
        let chatGif = UIImage.gifWithName("fruitToGraine")
        let imageView = UIImageView(image: chatGif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        view.addSubview(imageView)
        
        pageControl.layer.zPosition = 2
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
    }

}

class PartageViewController: FruitViewController{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.layer.zPosition = 2
        self.image.layer.zPosition = 1
        
        let chatGif = UIImage.gifWithName("carte")
        let imageView = UIImageView(image: chatGif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        view.addSubview(imageView)
    }

}


