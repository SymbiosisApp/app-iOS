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
        if self.imageView != nil {
            self.imageView.removeFromSuperview()
        }
    }
    
    func imageLoader(){
        let imageLoader : UIImage = UIImage(named:"fruitToGraineLoader")!
        self.imageLoaderView = UIImageView(image: imageLoader)
        self.imageLoaderView .frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageLoaderView)
    }

    func loadedGif(completion: (result: Bool) -> Void){
        let gif = UIImage.gifWithName("fruitToGraine")
        self.imageView = UIImageView(image: gif)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageView)
        completion(result: true)
    }

}


class PartageViewController: FruitViewController{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    var imageView: UIImageView! = nil
    var imageLoaderView: UIImageView! = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.layer.zPosition = 2
        self.image.layer.zPosition = 1
      
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
        if self.imageView != nil {
            self.imageView.removeFromSuperview()
        }
    }
    
    func imageLoader(){
        let imageLoader : UIImage = UIImage(named:"carteLoader")!
        self.imageLoaderView = UIImageView(image: imageLoader)
        self.imageLoaderView .frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageLoaderView)
    }
    
    func loadedGif(completion: (result: Bool) -> Void){
        let gif = UIImage.gifWithName("carte")
        self.imageView = UIImageView(image: gif)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageView)
        completion(result: true)
    }
    
}


