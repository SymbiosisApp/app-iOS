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
    var imageView: UIImageView! = nil
    var imageLoaderView: UIImageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.image.layer.zPosition = 1
        pageControl.layer.zPosition = 2
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        
        self.imageLoader()
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.loadedGif(){
                (result: Bool) in
                if result {
                    self.imageLoaderView.removeFromSuperview()
                }
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.imageLoader()
        self.imageView.removeFromSuperview()
    }
    
    func imageLoader(){
        let imageLoader : UIImage = UIImage(named:"bienvenueLoader")!
        self.imageLoaderView = UIImageView(image: imageLoader)
        self.imageLoaderView .frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.imageLoaderView)
    }
    
    func loadedGif(completion: (result: Bool) -> Void){
        let gif = UIImage.gifWithName("bienvenue")
        self.imageView = UIImageView(image: gif)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.imageView)
        completion(result: true)
    }
}


class StartViewController: IntroViewController{
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    var imageView: UIImageView! = nil
    var imageLoaderView: UIImageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.image.layer.zPosition = 1
        button.layer.zPosition = 2
        
        self.imageLoader()
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.loadedGif(){
                (result: Bool) in
                if result {
                    self.imageLoaderView.removeFromSuperview()
                }
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.imageLoader()
        self.imageView.removeFromSuperview()
    }
    
    func imageLoader(){
        let imageLoader : UIImage = UIImage(named:"bienvenueLoader")!
        self.imageLoaderView = UIImageView(image: imageLoader)
        self.imageLoaderView .frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.imageLoaderView)
    }
    
    func loadedGif(completion: (result: Bool) -> Void){
        let gif = UIImage.gifWithName("bienvenue")
        self.imageView = UIImageView(image: gif)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.imageView)
        completion(result: true)
    }
}


