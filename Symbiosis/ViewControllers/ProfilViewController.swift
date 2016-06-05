//
//  ProfilViewController.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 28/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class ProfilViewController: UIViewController {
    
    @IBOutlet weak var imageAnimTest: UIImageView!
    @IBOutlet weak var imageAnimTest2: UIImageView!
    
    
    override func viewDidLoad() {
        
        self.imageAnimTest.contentMode = UIViewContentMode.ScaleToFill
        self.imageAnimTest.clipsToBounds = true
        self.imageAnimTest.center = self.view.center
        
        let numberOfImages: Int = 50
        var images = [UIImage]()
        for i in 1...numberOfImages {
            print("Load image \(i)")
            let imgName = String(format: "bienvenue-%05d.png", i)
            //let img = UIImage(named: "bienvenue-\(i)")!
            let img = UIImage(data: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource(imgName, ofType: nil)!)!)
            images.append(img!)
        }
        self.imageAnimTest.animationImages = images
        self.imageAnimTest.animationDuration = Double(numberOfImages) * (1/15)
        self.imageAnimTest.startAnimating()
        
        
        self.imageAnimTest2.contentMode = UIViewContentMode.ScaleToFill
        self.imageAnimTest2.clipsToBounds = true
        self.imageAnimTest2.center = self.view.center
        
        var images2 = [UIImage]()
        for i in 1...numberOfImages {
            print("Load image \(i)")
            let imgName = String(format: "bienvenue-%05d.png", i)
            //let img = UIImage(named: "bienvenue-\(i)")!
            let img = UIImage(data: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource(imgName, ofType: nil)!)!)
            images2.append(img!)
        }
        self.imageAnimTest2.animationImages = images2
        self.imageAnimTest2.animationDuration = Double(numberOfImages) * (1/15)
        self.imageAnimTest2.startAnimating()
        
    }
    
}