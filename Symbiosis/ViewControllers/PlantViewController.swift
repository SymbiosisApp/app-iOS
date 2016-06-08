//
//  PlantViewControllerViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 08/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class PlantViewController: UIViewController, SYStateListener {

    
    @IBOutlet weak var photo: UIButton!
    let state = SYStateManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        state.addListener(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func onStateSetup() {
 
    }

    func onStateUpdate() {
        let showPin = state.allFunctionnalities()
        
        if showPin{
            photo.hidden = false
            
        }else{
            photo.hidden = true
        }

    }

}
