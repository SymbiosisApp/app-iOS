//
//  PlantViewControllerViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 08/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class PlantViewController: UIViewController, SYStateListener {

    @IBOutlet weak var computeLabel: UILabel!
    
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
        if state.getPlantStatus() == SYStatePlantStatus.Generated {
            // Hide label
            UIView.animateWithDuration(0.2, animations: { 
                self.computeLabel.alpha = 0
                }, completion: { (completed) in
                    // done
                    self.computeLabel.alpha = 0
            })
        }
        if state.getPlantStatus() == SYStatePlantStatus.Generating {
            // Show label
            UIView.animateWithDuration(0.2, animations: {
                self.computeLabel.alpha = 1
                }, completion: { (completed) in
                    // done
                    self.computeLabel.alpha = 1
            })
        }
    }

    func onStateUpdate() {
        let showPin = state.allFunctionnalities()
        
        if showPin{
            photo.hidden = false
            
        }else{
            photo.hidden = true
        }
        
        if state.plantStatusHasChanged() {
            self.onStateSetup()
        }

    }

}
