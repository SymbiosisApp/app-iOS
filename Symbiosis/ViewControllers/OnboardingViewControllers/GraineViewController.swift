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
    var imageView: UIImageView! = nil
    var imageLoaderView: UIImageView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let imageLoader : UIImage = UIImage(named:"graineToPousseLoader")!
        self.imageLoaderView = UIImageView(image: imageLoader)
        self.imageLoaderView .frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageLoaderView)
    }
    
    func loadedGif(completion: (result: Bool) -> Void){
        let gif = UIImage.gifWithName("graineToPousse")
        self.imageView = UIImageView(image: gif)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageView)
        completion(result: true)
    }
    

}

class CommentaireViewController: GrainesViewController{
    
    @IBOutlet weak var image: UIImageView!
    var imageView: UIImageView! = nil
    var imageLoaderView: UIImageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let imageLoader : UIImage = UIImage(named:"chatLoader")!
        self.imageLoaderView = UIImageView(image: imageLoader)
        self.imageLoaderView .frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageLoaderView)
    }
    
    func loadedGif(completion: (result: Bool) -> Void){
        let gif = UIImage.gifWithName("chat")
        self.imageView = UIImageView(image: gif)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageView)
        completion(result: true)
    }
}


class DeplacementViewController: GrainesViewController{
    
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
        let imageLoader : UIImage = UIImage(named:"marcheLoader")!
        self.imageLoaderView = UIImageView(image: imageLoader)
        self.imageLoaderView .frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageLoaderView)
    }
    
    func loadedGif(completion: (result: Bool) -> Void){
        let gif = UIImage.gifWithName("marche")
        self.imageView = UIImageView(image: gif)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height/1.6)
        self.view.addSubview(self.imageView)
        completion(result: true)
    }
}