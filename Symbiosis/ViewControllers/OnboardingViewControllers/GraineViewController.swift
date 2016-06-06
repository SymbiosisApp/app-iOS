//
//  GraineViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 30/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class GrainesViewController: UIViewController {
    let background = Background()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


class GraineViewController: GrainesViewController{
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageAnimTest: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.image.layer.zPosition = 1
        pageControl.layer.zPosition = 2
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
        let graineGif = UIImage.gifWithName("graineReduce")
        let imageView = UIImageView(image: graineGif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        view.addSubview(imageView)
        
    }

}

class CommentaireViewController: GrainesViewController{
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageAnimTest: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.image.layer.zPosition = 1
        pageControl.layer.zPosition = 2
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 1
        
        let chatGif = UIImage.gifWithName("graineReduce")
        let imageView = UIImageView(image: chatGif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        view.addSubview(imageView)
        
    }

}

class DeplacementViewController: GrainesViewController{
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageAnimTest: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.layer.zPosition = 2
        self.image.layer.zPosition = 1
        
        let marcheGif = UIImage.gifWithName("graineReduce")
        let imageView = UIImageView(image: marcheGif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        view.addSubview(imageView)
        
    }
}