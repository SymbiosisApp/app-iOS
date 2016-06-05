//
//  ProfilViewController.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 28/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit
import Gifu


class ProfilViewController: UIViewController {
    
    @IBOutlet weak var imageAnimTest: UIImageView!
    @IBOutlet weak var gifuTest: UIImageView!
    
    
    override func viewDidLoad() {
        
//        self.imageAnimTest.contentMode =  UIViewContentMode.ScaleToFill
//        self.imageAnimTest.clipsToBounds = true
//        self.imageAnimTest.center = self.view.center
//        
//        //let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
//            var images = [UIImage]()
//            for i in 1...3 {
//                print("Load image \(i)")
//                let img = UIImage(named: "bienvenue-\(i)")!
//                images.append(img)
//            }
//            self.imageAnimTest.animationImages = images
//            
//            self.imageAnimTest.startAnimating()
//        //}
        
        let animImg = AnimatableImageView(frame: gifuTest.frame)
        
        self.view.addSubview(animImg)
        
        animImg.animateWithImage(named: "chat.gif")
        animImg.startAnimating()
        
    }
    
}